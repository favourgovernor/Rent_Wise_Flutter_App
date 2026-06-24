// lib/database/app_database.dart
//
// This is your LOCAL SQLite database (Drift).
// It mirrors your Supabase tables on device.
//
// PURPOSE:
//   • App works fully offline — reads from here
//   • Writes go here first, then sync to Supabase
//   • OutboxQueue holds pending writes when offline
//
// TABLES:
//   buildings_local   — mirrors Supabase buildings
//   units_local       — mirrors Supabase units
//   tenants_local     — mirrors Supabase tenants
//   maintenance_local — mirrors Supabase maintenance
//   outbox_queue      — pending offline writes

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ══════════════════════════════════════════════════
//  TABLE DEFINITIONS
// ══════════════════════════════════════════════════

// Buildings
class BuildingsLocal extends Table {
  TextColumn get id => text()();
  TextColumn get landlordId => text()();
  TextColumn get name => text()();
  TextColumn get propertyType =>
      text().withDefault(const Constant('apartment'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get synced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// Units
class UnitsLocal extends Table {
  TextColumn get id => text()();
  TextColumn get buildingId => text()();
  TextColumn get name => text()();
  TextColumn get unitType => text().withDefault(const Constant('apartment'))();
  TextColumn get roomType => text().withDefault(const Constant('1br'))();
  IntColumn get capacity => integer().withDefault(const Constant(1))();
  RealColumn get rentPerBed => real().withDefault(const Constant(0))();
  RealColumn get rentTotal => real().withDefault(const Constant(0))();
  BoolColumn get isOccupied => boolean().withDefault(const Constant(false))();
  BoolColumn get synced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// Tenants
class TenantsLocal extends Table {
  TextColumn get id => text()();
  TextColumn get buildingId => text()();
  TextColumn get unitId => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().nullable()();
  TextColumn get bedLabel => text().withDefault(const Constant(''))();
  BoolColumn get isHostelTenant =>
      boolean().withDefault(const Constant(false))();
  RealColumn get deposit => real().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get synced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// Maintenance
class MaintenanceLocal extends Table {
  TextColumn get id => text()();
  TextColumn get buildingId => text()();
  TextColumn get title => text()();
  TextColumn get type => text()(); // invoice | receipt
  TextColumn get status => text().withDefault(const Constant('unpaid'))();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Outbox Queue ───────────────────────────────────
// Every write that happens while offline is stored
// here. SyncService processes this queue when the
// device reconnects.
//
// operation: 'insert' | 'update' | 'delete'
// tableName:  'buildings' | 'units' | 'tenants' etc.
// payload:    JSON string of the row data
class OutboxQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operation => text()(); // insert|update|delete
  // Named 'targetTable' to avoid conflict with Drift's
  // built-in Table.tableName getter
  TextColumn get targetTable => text()();
  TextColumn get payload => text()(); // JSON
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retries => integer().withDefault(const Constant(0))();
  BoolColumn get failed => boolean().withDefault(const Constant(false))();
}

// ══════════════════════════════════════════════════
//  DATABASE CLASS
// ══════════════════════════════════════════════════
@DriftDatabase(tables: [
  BuildingsLocal,
  UnitsLocal,
  TenantsLocal,
  MaintenanceLocal,
  OutboxQueue,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ── Buildings ─────────────────────────────────
  Future<List<BuildingsLocalData>> getBuildingsByLandlord(String landlordId) =>
      (select(buildingsLocal)..where((t) => t.landlordId.equals(landlordId)))
          .get();

  Future<void> upsertBuilding(BuildingsLocalCompanion row) =>
      into(buildingsLocal).insertOnConflictUpdate(row);

  Future<void> deleteBuildingLocal(String id) =>
      (delete(buildingsLocal)..where((t) => t.id.equals(id))).go();

  // ── Units ─────────────────────────────────────
  Future<List<UnitsLocalData>> getUnitsByBuilding(String buildingId) =>
      (select(unitsLocal)..where((t) => t.buildingId.equals(buildingId))).get();

  Future<void> upsertUnit(UnitsLocalCompanion row) =>
      into(unitsLocal).insertOnConflictUpdate(row);

  // ── Tenants ───────────────────────────────────
  Future<List<TenantsLocalData>> getTenantsByBuilding(String buildingId) =>
      (select(tenantsLocal)
            ..where((t) =>
                t.buildingId.equals(buildingId) & t.isActive.equals(true)))
          .get();

  Future<void> upsertTenant(TenantsLocalCompanion row) =>
      into(tenantsLocal).insertOnConflictUpdate(row);

  // ── Maintenance ───────────────────────────────
  Future<List<MaintenanceLocalData>> getMaintenanceByBuilding(
          String buildingId) =>
      (select(maintenanceLocal)..where((t) => t.buildingId.equals(buildingId)))
          .get();

  Future<void> upsertMaintenance(MaintenanceLocalCompanion row) =>
      into(maintenanceLocal).insertOnConflictUpdate(row);

  // ── Outbox Queue ──────────────────────────────
  Future<List<OutboxQueueData>> getPendingOutbox() => (select(outboxQueue)
        ..where((t) => t.failed.equals(false))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .get();

  Future<int> addToOutbox(OutboxQueueCompanion row) =>
      into(outboxQueue).insert(row);

  Future<void> deleteOutboxItem(int id) =>
      (delete(outboxQueue)..where((t) => t.id.equals(id))).go();

  Future<void> markOutboxFailed(int id) =>
      (update(outboxQueue)..where((t) => t.id.equals(id)))
          .write(const OutboxQueueCompanion(failed: Value(true)));

  Future<void> clearOutbox() => delete(outboxQueue).go();

  // ── Clear all local data (on sign out) ────────
  Future<void> clearAll() async {
    await delete(buildingsLocal).go();
    await delete(unitsLocal).go();
    await delete(tenantsLocal).go();
    await delete(maintenanceLocal).go();
    await delete(outboxQueue).go();
  }
}

// ── Open the SQLite file ─────────────────────────
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'rentwise.db'));
    return NativeDatabase.createInBackground(file);
  });
}
