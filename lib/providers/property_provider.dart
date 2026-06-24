import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/redis_service.dart';
import '../services/sync_service.dart';
import 'package:uuid/uuid.dart';

// ═══════════════════════════════════════════════
//  ENUMS
// ═══════════════════════════════════════════════
enum PropertyType { apartment, hostel, mixed }

enum UnitType { apartment, hostelRoom }

// ═══════════════════════════════════════════════
//  MODELS
// ═══════════════════════════════════════════════

class AppTenant {
  final String id;
  final String name;
  final String unitId;
  final String unitName;
  final String bedLabel;
  final String avatar;
  String status; // mutable — payment status changes
  final double rent;
  final double deposit;
  final String phone;
  final bool isHostelTenant;

  AppTenant({
    required this.id,
    required this.name,
    required this.unitId,
    required this.unitName,
    required this.avatar,
    required this.status,
    required this.rent,
    required this.phone,
    this.bedLabel = '',
    this.deposit = 0,
    this.isHostelTenant = false,
  });
}

class AppUnit {
  final String id;
  final String name;
  final String roomType; // 'bedsitter'|'1br'|'2br'|'3br'|'hostel'
  final UnitType unitType;
  final double rentPerBed;
  final double rentTotal;
  final int capacity;
  final List<String> tenantIds; // immutable — replaced on change

  AppUnit({
    required this.id,
    required this.name,
    required this.roomType,
    required this.unitType,
    required this.capacity,
    required this.tenantIds,
    this.rentPerBed = 0,
    this.rentTotal = 0,
  });

  bool get isOccupied => tenantIds.isNotEmpty;
  bool get isFull => tenantIds.length >= capacity;
  bool get isHostel => unitType == UnitType.hostelRoom;
  int get availableBeds => capacity - tenantIds.length;
}

class AppMaintenance {
  final String id;
  final String title;
  final String unitName;
  final String type; // 'invoice' | 'receipt'
  String status; // 'paid' | 'unpaid'
  final double amount;
  final DateTime date;

  AppMaintenance({
    required this.id,
    required this.title,
    required this.unitName,
    required this.type,
    required this.status,
    required this.amount,
    required this.date,
  });
}

class AppBuilding {
  final String id;
  String name;
  final PropertyType propertyType;
  final List<AppUnit> units;
  final List<AppTenant> tenants;
  final List<AppMaintenance> maintenance;

  AppBuilding({
    required this.id,
    required this.name,
    required this.propertyType,
    List<AppUnit>? units,
    List<AppTenant>? tenants,
    List<AppMaintenance>? maintenance,
  })  : units = units ?? [],
        tenants = tenants ?? [],
        maintenance = maintenance ?? [];

  // ── Computed stats ──────────────────────────
  int get totalUnits => units.length;
  int get occupiedUnits => units.where((u) => u.isOccupied).length;
  int get vacantUnits => units.where((u) => !u.isOccupied).length;
  int get partialUnits => units.where((u) => u.isOccupied && !u.isFull).length;
  int get totalBeds => units.fold(0, (s, u) => s + u.capacity);
  int get occupiedBeds => units.fold(0, (s, u) => s + u.tenantIds.length);
  int get availableBeds => totalBeds - occupiedBeds;

  double get occupancyRate {
    if (propertyType == PropertyType.hostel) {
      return totalBeds == 0 ? 0 : occupiedBeds / totalBeds;
    }
    return totalUnits == 0 ? 0 : occupiedUnits / totalUnits;
  }

  double get totalRevenue =>
      tenants.where((t) => t.status == 'paid').fold(0, (s, t) => s + t.rent);
  double get expectedRevenue => tenants.fold(0, (s, t) => s + t.rent);
  double get revenueRate =>
      expectedRevenue == 0 ? 0 : totalRevenue / expectedRevenue;
  double get totalDeposits => tenants.fold(0, (s, t) => s + t.deposit);

  bool get isHostel => propertyType == PropertyType.hostel;
  bool get isApartment => propertyType == PropertyType.apartment;
  bool get isMixed => propertyType == PropertyType.mixed;
}

// ═══════════════════════════════════════════════
//  PROPERTY PROVIDER
// ═══════════════════════════════════════════════
class PropertyProvider extends ChangeNotifier {
  static const _uuid = Uuid();
  final List<AppBuilding> _buildings = [];

  List<AppBuilding> get buildings => List.unmodifiable(_buildings);
  bool get isEmpty => _buildings.isEmpty;

  // ── Called at end of signup ─────────────────
  void initFromSignup(List<Map<String, dynamic>> properties) {
    _buildings.clear();
    for (int i = 0; i < properties.length; i++) {
      final p = properties[i];
      _buildings.add(AppBuilding(
        id: _uuid.v4(),
        name: p['name'] as String,
        propertyType: p['type'] as PropertyType,
      ));
    }
    notifyListeners();
  }

  // ── Add a new building ──────────────────────
  Future<void> addBuilding(String name, PropertyType type) async {
    final id = _uuid.v4();
    final landlordId = await _getLandlordId();
    _buildings.add(AppBuilding(id: id, name: name, propertyType: type));
    notifyListeners();

    await SyncService.writeBuilding(
      id: id,
      landlordId: landlordId,
      name: name,
      propertyType: _propertyTypeString(type),
    );
    await _invalidateCache();
  }

  // ── Add a unit to a building ────────────────
  Future<void> addUnit(String buildingId, AppUnit unit) async {
    final idx = _buildings.indexWhere((b) => b.id == buildingId);
    if (idx == -1) return;
    final b = _buildings[idx];

    // Replace the building with a new instance — forces Flutter to re-render
    _buildings[idx] = AppBuilding(
      id: b.id,
      name: b.name,
      propertyType: b.propertyType,
      units: [...b.units, unit],
      tenants: b.tenants,
      maintenance: b.maintenance,
    );
    notifyListeners();

    await SyncService.writeUnit(
      id: unit.id,
      buildingId: buildingId,
      name: unit.name,
      unitType:
          unit.unitType == UnitType.hostelRoom ? 'hostel_room' : 'apartment',
      roomType: unit.roomType,
      capacity: unit.capacity,
      rentPerBed: unit.rentPerBed,
      rentTotal: unit.rentTotal,
    );
    await _invalidateCache();
  }

  // ── Add a maintenance record ────────────────
  Future<void> addMaintenance(String buildingId, AppMaintenance item) async {
    final idx = _buildings.indexWhere((b) => b.id == buildingId);
    if (idx == -1) return;
    final b = _buildings[idx];
    _buildings[idx] = AppBuilding(
      id: b.id,
      name: b.name,
      propertyType: b.propertyType,
      units: b.units,
      tenants: b.tenants,
      maintenance: [...b.maintenance, item],
    );
    notifyListeners();

    await SyncService.writeMaintenance(
      id: item.id,
      buildingId: buildingId,
      title: item.title,
      type: item.type,
      status: item.status,
      amount: item.amount,
      date: item.date,
    );
    await _invalidateCache();
  }

  // ── Add a tenant ────────────────────────────
  Future<void> addTenant(String buildingId, AppTenant tenant) async {
    final idx = _buildings.indexWhere((b) => b.id == buildingId);
    if (idx == -1) return;
    final b = _buildings[idx];

    final updatedUnits = b.units.map((u) {
      if (u.id == tenant.unitId && !u.tenantIds.contains(tenant.id)) {
        return AppUnit(
          id: u.id,
          name: u.name,
          roomType: u.roomType,
          unitType: u.unitType,
          capacity: u.capacity,
          tenantIds: [...u.tenantIds, tenant.id],
          rentPerBed: u.rentPerBed,
          rentTotal: u.rentTotal,
        );
      }
      return u;
    }).toList();

    _buildings[idx] = AppBuilding(
      id: b.id,
      name: b.name,
      propertyType: b.propertyType,
      units: updatedUnits,
      tenants: [...b.tenants, tenant],
      maintenance: b.maintenance,
    );
    notifyListeners();

    await SyncService.writeTenant(
      id: tenant.id,
      buildingId: buildingId,
      unitId: tenant.unitId,
      name: tenant.name,
      phone: tenant.phone,
      bedLabel: tenant.bedLabel,
      isHostelTenant: tenant.isHostelTenant,
      deposit: tenant.deposit,
    );
    await _invalidateCache();
  }

  // ── Update payment status ───────────────────
  void updatePaymentStatus(String buildingId, String tenantId, String status) {
    final idx = _buildings.indexWhere((b) => b.id == buildingId);
    if (idx == -1) return;
    final b = _buildings[idx];
    final updatedTenants = b.tenants.map((t) {
      if (t.id == tenantId) {
        return AppTenant(
          id: t.id,
          name: t.name,
          unitId: t.unitId,
          unitName: t.unitName,
          avatar: t.avatar,
          status: status,
          rent: t.rent,
          phone: t.phone,
          bedLabel: t.bedLabel,
          deposit: t.deposit,
          isHostelTenant: t.isHostelTenant,
        );
      }
      return t;
    }).toList();
    _buildings[idx] = AppBuilding(
      id: b.id,
      name: b.name,
      propertyType: b.propertyType,
      units: b.units,
      tenants: updatedTenants,
      maintenance: b.maintenance,
    );
    notifyListeners();
  }

  // ── Invalidate Redis cache ───────────────────
  Future<void> _invalidateCache() async {
    final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
    if (authId.isNotEmpty) await RedisService.invalidateLandlord(authId);
  }

  // ignore: unused_element
  AppBuilding? _findBuilding(String id) =>
      _buildings.where((b) => b.id == id).firstOrNull;

  // ignore: unused_element
  Future<String> _getLandlordId() async {
    final authId = Supabase.instance.client.auth.currentUser?.id;
    if (authId == null) return '';
    final row = await Supabase.instance.client
        .from('landlords')
        .select('id')
        .eq('auth_id', authId)
        .maybeSingle();
    return row?['id'] as String? ?? '';
  }

  // ════════════════════════════════════════════
  //  LOAD FROM SUPABASE
  //  Always queries Supabase directly.
  //  Redis caching is disabled until credentials
  //  are filled in — avoids silent cache failures.
  // ════════════════════════════════════════════
  Future<void> loadFromSupabase() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // ── Get landlord internal ID ─────────────
      final landlordRow = await Supabase.instance.client
          .from('landlords')
          .select('id')
          .eq('auth_id', user.id)
          .maybeSingle();

      if (landlordRow == null) {
        debugPrint('PropertyProvider: no landlord row found for ${user.id}');
        return;
      }
      final landlordId = landlordRow['id'] as String;

      // ── Load buildings ───────────────────────
      final buildingsData = await Supabase.instance.client
          .from('buildings')
          .select('id, name, property_type')
          .eq('landlord_id', landlordId)
          .order('created_at') as List;

      debugPrint('PropertyProvider: found ${buildingsData.length} buildings');

      if (buildingsData.isEmpty) {
        _buildings.clear();
        notifyListeners();
        return;
      }

      final buildingIds = buildingsData.map((b) => b['id'] as String).toList();

      // ── Load units ───────────────────────────
      final unitsData = await Supabase.instance.client
          .from('units')
          .select(
              'id, building_id, name, unit_type, room_type, capacity, rent_per_bed, rent_total')
          .inFilter('building_id', buildingIds) as List;

      // ── Load tenants ─────────────────────────
      final tenantsData = await Supabase.instance.client
          .from('tenants')
          .select(
              'id, building_id, unit_id, name, phone, bed_label, is_hostel_tenant, deposit')
          .inFilter('building_id', buildingIds)
          .eq('is_active', true) as List;

      // ── Load maintenance ─────────────────────
      final maintenanceData = await Supabase.instance.client
          .from('maintenance')
          .select('id, building_id, title, type, status, amount, date')
          .inFilter('building_id', buildingIds) as List;

      // ── Rebuild state ────────────────────────
      _buildings.clear();

      for (final b in buildingsData) {
        final bId = b['id'] as String;
        final bName = b['name'] as String;
        final bType =
            _parsePropertyType(b['property_type'] as String? ?? 'apartment');

        final bUnits = unitsData.where((u) => u['building_id'] == bId).map((u) {
          final uId = u['id'] as String;
          final unitTenantIds = tenantsData
              .where((t) => t['unit_id'] == uId)
              .map((t) => t['id'] as String)
              .toList();
          return AppUnit(
            id: uId,
            name: u['name'] as String,
            roomType: u['room_type'] as String? ?? '1br',
            unitType: (u['unit_type'] as String?) == 'hostel_room'
                ? UnitType.hostelRoom
                : UnitType.apartment,
            capacity: u['capacity'] as int? ?? 1,
            tenantIds: unitTenantIds,
            rentPerBed: (u['rent_per_bed'] as num?)?.toDouble() ?? 0,
            rentTotal: (u['rent_total'] as num?)?.toDouble() ?? 0,
          );
        }).toList();

        final bTenants =
            tenantsData.where((t) => t['building_id'] == bId).map((t) {
          final unitName = bUnits
                  .where((u) => u.id == (t['unit_id'] as String))
                  .firstOrNull
                  ?.name ??
              '';
          return AppTenant(
            id: t['id'] as String,
            name: t['name'] as String,
            unitId: t['unit_id'] as String,
            unitName: unitName,
            bedLabel: t['bed_label'] as String? ?? '',
            avatar: '',
            status: 'pending',
            rent: 0,
            deposit: (t['deposit'] as num?)?.toDouble() ?? 0,
            phone: t['phone'] as String? ?? '',
            isHostelTenant: t['is_hostel_tenant'] as bool? ?? false,
          );
        }).toList();

        final bMaintenance = maintenanceData
            .where((m) => m['building_id'] == bId)
            .map((m) => AppMaintenance(
                  id: m['id'] as String,
                  title: m['title'] as String,
                  unitName: '',
                  type: m['type'] as String,
                  status: m['status'] as String? ?? 'unpaid',
                  amount: (m['amount'] as num).toDouble(),
                  date: DateTime.parse(m['date'] as String),
                ))
            .toList();

        _buildings.add(AppBuilding(
          id: bId,
          name: bName,
          propertyType: bType,
          units: bUnits,
          tenants: bTenants,
          maintenance: bMaintenance,
        ));
      }

      notifyListeners();
      debugPrint('PropertyProvider: loaded ${_buildings.length} buildings ✅');
    } catch (e) {
      debugPrint('PropertyProvider.loadFromSupabase error: $e');
    }
  }

  // ════════════════════════════════════════════
  //  SAVE TO SUPABASE (called from SetupScreen)
  // ════════════════════════════════════════════
  Future<bool> saveToSupabase(String landlordId) async {
    if (landlordId.isEmpty) {
      debugPrint('saveToSupabase: landlordId is empty — aborting');
      return false;
    }
    if (_buildings.isEmpty) {
      debugPrint('saveToSupabase: _buildings list is empty — nothing to save');
      return true; // not an error — landlord may have added 0 properties
    }

    debugPrint('saveToSupabase: attempting to save ${_buildings.length} '
        'buildings for landlordId=$landlordId');

    try {
      for (final b in _buildings) {
        debugPrint('saveToSupabase: saving "${b.name}" '
            '(id=${b.id}, type=${_propertyTypeString(b.propertyType)})');

        final result = await Supabase.instance.client.from('buildings').upsert({
          'id': b.id,
          'landlord_id': landlordId,
          'name': b.name,
          'property_type': _propertyTypeString(b.propertyType),
        }).select();

        debugPrint('saveToSupabase: insert result -> $result');
      }
      debugPrint('saveToSupabase: ALL ${_buildings.length} buildings saved ✅');
      return true;
    } on PostgrestException catch (e) {
      // This catches the EXACT Postgres/RLS error message
      debugPrint('saveToSupabase POSTGREST ERROR: '
          'code=${e.code} message=${e.message} details=${e.details}');
      return false;
    } catch (e) {
      debugPrint('saveToSupabase UNKNOWN ERROR: $e');
      return false;
    }
  }

  PropertyType _parsePropertyType(String s) {
    switch (s) {
      case 'hostel':
        return PropertyType.hostel;
      case 'mixed':
        return PropertyType.mixed;
      default:
        return PropertyType.apartment;
    }
  }

  String _propertyTypeString(PropertyType t) {
    switch (t) {
      case PropertyType.hostel:
        return 'hostel';
      case PropertyType.mixed:
        return 'mixed';
      default:
        return 'apartment';
    }
  }
}
