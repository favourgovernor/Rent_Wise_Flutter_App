// lib/services/sync_service.dart
//
// THE WHATSAPP ENGINE
//
// This service does two things:
//
// 1. WRITE INTERCEPTION
//    Every write (add building, add tenant, etc.)
//    goes through here. It:
//      a. Saves to local Drift DB immediately
//      b. If online: also saves to Supabase
//      c. If offline: adds to OutboxQueue
//
// 2. OUTBOX FLUSH
//    When the device reconnects, it processes
//    every item in OutboxQueue and pushes it
//    to Supabase. Like WhatsApp sending queued
//    messages when you reconnect.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import 'redis_service.dart';

class SyncService {
  static final _db = AppDatabase();
  static bool _isOnline = true;
  static bool _isSyncing = false;

  // ── Call once in main() to start listening ────
  static void init() {
    Connectivity().onConnectivityChanged.listen((results) {
      final wasOffline = !_isOnline;
      _isOnline = results.any((r) => r != ConnectivityResult.none);

      if (wasOffline && _isOnline) {
        // Just came back online — flush the queue
        debugPrint('SyncService: back online — flushing outbox');
        flushOutbox();
      }
    });

    // Check initial state
    Connectivity().checkConnectivity().then((results) {
      _isOnline = results.any((r) => r != ConnectivityResult.none);
    });
  }

  // ── Expose DB for PropertyProvider reads ──────
  static AppDatabase get db => _db;

  // ════════════════════════════════════════════
  //  WRITE: ADD BUILDING
  //  Called by PropertyProvider.addBuilding()
  // ════════════════════════════════════════════
  static Future<void> writeBuilding({
    required String id,
    required String landlordId,
    required String name,
    required String propertyType,
  }) async {
    final row = BuildingsLocalCompanion(
      id: Value(id),
      landlordId: Value(landlordId),
      name: Value(name),
      propertyType: Value(propertyType),
      synced: Value(_isOnline),
    );

    // Always save locally first
    await _db.upsertBuilding(row);

    if (_isOnline) {
      // Push to Supabase immediately
      try {
        await Supabase.instance.client.from('buildings').upsert({
          'id': id,
          'landlord_id': landlordId,
          'name': name,
          'property_type': propertyType,
        });
        // Invalidate Redis cache
        final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
        await RedisService.invalidateLandlord(authId);
      } catch (e) {
        debugPrint('SyncService building online write failed: $e');
        await _queueForLater('buildings', 'insert', {
          'id': id,
          'landlord_id': landlordId,
          'name': name,
          'property_type': propertyType,
        });
      }
    } else {
      // Offline — queue for later
      await _queueForLater('buildings', 'insert', {
        'id': id,
        'landlord_id': landlordId,
        'name': name,
        'property_type': propertyType,
      });
    }
  }

  // ════════════════════════════════════════════
  //  WRITE: ADD UNIT
  // ════════════════════════════════════════════
  static Future<void> writeUnit({
    required String id,
    required String buildingId,
    required String name,
    required String unitType,
    required String roomType,
    required int capacity,
    required double rentPerBed,
    required double rentTotal,
  }) async {
    final row = UnitsLocalCompanion(
      id: Value(id),
      buildingId: Value(buildingId),
      name: Value(name),
      unitType: Value(unitType),
      roomType: Value(roomType),
      capacity: Value(capacity),
      rentPerBed: Value(rentPerBed),
      rentTotal: Value(rentTotal),
      synced: Value(_isOnline),
    );

    await _db.upsertUnit(row);

    final payload = {
      'id': id,
      'building_id': buildingId,
      'name': name,
      'unit_type': unitType,
      'room_type': roomType,
      'capacity': capacity,
      'rent_per_bed': rentPerBed,
      'rent_total': rentTotal,
    };

    if (_isOnline) {
      try {
        await Supabase.instance.client.from('units').upsert(payload);
        final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
        await RedisService.invalidateLandlord(authId);
      } catch (e) {
        await _queueForLater('units', 'insert', payload);
      }
    } else {
      await _queueForLater('units', 'insert', payload);
    }
  }

  // ════════════════════════════════════════════
  //  WRITE: ADD TENANT
  // ════════════════════════════════════════════
  static Future<void> writeTenant({
    required String id,
    required String buildingId,
    required String unitId,
    required String name,
    required String phone,
    String? email,
    String bedLabel = '',
    bool isHostelTenant = false,
    double deposit = 0,
  }) async {
    final row = TenantsLocalCompanion(
      id: Value(id),
      buildingId: Value(buildingId),
      unitId: Value(unitId),
      name: Value(name),
      phone: Value(phone),
      email: Value(email),
      bedLabel: Value(bedLabel),
      isHostelTenant: Value(isHostelTenant),
      deposit: Value(deposit),
      synced: Value(_isOnline),
    );

    await _db.upsertTenant(row);

    final payload = {
      'id': id,
      'building_id': buildingId,
      'unit_id': unitId,
      'name': name,
      'phone': phone,
      'email': email,
      'bed_label': bedLabel,
      'is_hostel_tenant': isHostelTenant,
      'deposit': deposit,
      'is_active': true,
    };

    if (_isOnline) {
      try {
        await Supabase.instance.client.from('tenants').upsert(payload);
        final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
        await RedisService.invalidateLandlord(authId);
      } catch (e) {
        await _queueForLater('tenants', 'insert', payload);
      }
    } else {
      await _queueForLater('tenants', 'insert', payload);
    }
  }

  // ════════════════════════════════════════════
  //  WRITE: ADD MAINTENANCE
  // ════════════════════════════════════════════
  static Future<void> writeMaintenance({
    required String id,
    required String buildingId,
    required String title,
    required String type,
    required String status,
    required double amount,
    required DateTime date,
  }) async {
    final row = MaintenanceLocalCompanion(
      id: Value(id),
      buildingId: Value(buildingId),
      title: Value(title),
      type: Value(type),
      status: Value(status),
      amount: Value(amount),
      date: Value(date),
      synced: Value(_isOnline),
    );

    await _db.upsertMaintenance(row);

    final payload = {
      'id': id,
      'building_id': buildingId,
      'title': title,
      'type': type,
      'status': status,
      'amount': amount,
      'date': date.toIso8601String(),
    };

    if (_isOnline) {
      try {
        await Supabase.instance.client.from('maintenance').upsert(payload);
        final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
        await RedisService.invalidateLandlord(authId);
      } catch (e) {
        await _queueForLater('maintenance', 'insert', payload);
      }
    } else {
      await _queueForLater('maintenance', 'insert', payload);
    }
  }

  // ════════════════════════════════════════════
  //  QUEUE FOR LATER (offline write)
  // ════════════════════════════════════════════
  static Future<void> _queueForLater(
    String tableName,
    String operation,
    Map<String, dynamic> payload,
  ) async {
    await _db.addToOutbox(OutboxQueueCompanion(
      operation: Value(operation),
      targetTable: Value(tableName),
      payload: Value(jsonEncode(payload)),
    ));
    // Invalidate Redis so next login fetches fresh data from Supabase
    // instead of serving the stale cached version
    final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
    if (authId.isNotEmpty) {
      await RedisService.invalidateLandlord(authId);
    }
    debugPrint('SyncService: queued \$operation on \$tableName for later');
  }

  // ════════════════════════════════════════════
  //  FLUSH OUTBOX
  //  Called automatically when device reconnects.
  //  Processes every pending write in order.
  // ════════════════════════════════════════════
  static Future<void> flushOutbox() async {
    if (_isSyncing) return; // prevent concurrent flushes
    _isSyncing = true;

    try {
      final pending = await _db.getPendingOutbox();
      if (pending.isEmpty) {
        debugPrint('SyncService: outbox empty — nothing to sync');
        return;
      }

      debugPrint('SyncService: flushing ${pending.length} queued operations');

      int success = 0;
      int failed = 0;

      for (final item in pending) {
        try {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;

          switch (item.operation) {
            case 'insert':
            case 'update':
              await Supabase.instance.client
                  .from(item.targetTable)
                  .upsert(payload);
              break;
            case 'delete':
              final id = payload['id'] as String;
              await Supabase.instance.client
                  .from(item.targetTable)
                  .delete()
                  .eq('id', id);
              break;
          }

          // Remove from queue on success
          await _db.deleteOutboxItem(item.id);
          success++;
        } catch (e) {
          debugPrint('SyncService: failed to sync item ${item.id}: $e');
          // Mark as failed — won't retry automatically
          // Landlord can manually retry from settings
          await _db.markOutboxFailed(item.id);
          failed++;
        }
      }

      debugPrint('SyncService: flush complete — '
          '$success synced, $failed failed');

      // Invalidate Redis so fresh data is loaded
      if (success > 0) {
        final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
        if (authId.isNotEmpty) {
          await RedisService.invalidateLandlord(authId);
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  // ── Expose online state to UI ─────────────────
  static bool get isOnline => _isOnline;

  // ── Count pending items (for UI indicator) ────
  static Future<int> pendingCount() async {
    final items = await _db.getPendingOutbox();
    return items.length;
  }

  // ── Clear all local data on sign out ──────────
  static Future<void> clearLocalData() => _db.clearAll();
}
