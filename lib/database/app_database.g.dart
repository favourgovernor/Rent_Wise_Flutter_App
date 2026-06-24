// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BuildingsLocalTable extends BuildingsLocal
    with TableInfo<$BuildingsLocalTable, BuildingsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuildingsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _landlordIdMeta =
      const VerificationMeta('landlordId');
  @override
  late final GeneratedColumn<String> landlordId = GeneratedColumn<String>(
      'landlord_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _propertyTypeMeta =
      const VerificationMeta('propertyType');
  @override
  late final GeneratedColumn<String> propertyType = GeneratedColumn<String>(
      'property_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('apartment'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, landlordId, name, propertyType, createdAt, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'buildings_local';
  @override
  VerificationContext validateIntegrity(Insertable<BuildingsLocalData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('landlord_id')) {
      context.handle(
          _landlordIdMeta,
          landlordId.isAcceptableOrUnknown(
              data['landlord_id']!, _landlordIdMeta));
    } else if (isInserting) {
      context.missing(_landlordIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('property_type')) {
      context.handle(
          _propertyTypeMeta,
          propertyType.isAcceptableOrUnknown(
              data['property_type']!, _propertyTypeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BuildingsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BuildingsLocalData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      landlordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}landlord_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      propertyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}property_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $BuildingsLocalTable createAlias(String alias) {
    return $BuildingsLocalTable(attachedDatabase, alias);
  }
}

class BuildingsLocalData extends DataClass
    implements Insertable<BuildingsLocalData> {
  final String id;
  final String landlordId;
  final String name;
  final String propertyType;
  final DateTime createdAt;
  final bool synced;
  const BuildingsLocalData(
      {required this.id,
      required this.landlordId,
      required this.name,
      required this.propertyType,
      required this.createdAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['landlord_id'] = Variable<String>(landlordId);
    map['name'] = Variable<String>(name);
    map['property_type'] = Variable<String>(propertyType);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  BuildingsLocalCompanion toCompanion(bool nullToAbsent) {
    return BuildingsLocalCompanion(
      id: Value(id),
      landlordId: Value(landlordId),
      name: Value(name),
      propertyType: Value(propertyType),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory BuildingsLocalData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BuildingsLocalData(
      id: serializer.fromJson<String>(json['id']),
      landlordId: serializer.fromJson<String>(json['landlordId']),
      name: serializer.fromJson<String>(json['name']),
      propertyType: serializer.fromJson<String>(json['propertyType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'landlordId': serializer.toJson<String>(landlordId),
      'name': serializer.toJson<String>(name),
      'propertyType': serializer.toJson<String>(propertyType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  BuildingsLocalData copyWith(
          {String? id,
          String? landlordId,
          String? name,
          String? propertyType,
          DateTime? createdAt,
          bool? synced}) =>
      BuildingsLocalData(
        id: id ?? this.id,
        landlordId: landlordId ?? this.landlordId,
        name: name ?? this.name,
        propertyType: propertyType ?? this.propertyType,
        createdAt: createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
      );
  BuildingsLocalData copyWithCompanion(BuildingsLocalCompanion data) {
    return BuildingsLocalData(
      id: data.id.present ? data.id.value : this.id,
      landlordId:
          data.landlordId.present ? data.landlordId.value : this.landlordId,
      name: data.name.present ? data.name.value : this.name,
      propertyType: data.propertyType.present
          ? data.propertyType.value
          : this.propertyType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BuildingsLocalData(')
          ..write('id: $id, ')
          ..write('landlordId: $landlordId, ')
          ..write('name: $name, ')
          ..write('propertyType: $propertyType, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, landlordId, name, propertyType, createdAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BuildingsLocalData &&
          other.id == this.id &&
          other.landlordId == this.landlordId &&
          other.name == this.name &&
          other.propertyType == this.propertyType &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class BuildingsLocalCompanion extends UpdateCompanion<BuildingsLocalData> {
  final Value<String> id;
  final Value<String> landlordId;
  final Value<String> name;
  final Value<String> propertyType;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const BuildingsLocalCompanion({
    this.id = const Value.absent(),
    this.landlordId = const Value.absent(),
    this.name = const Value.absent(),
    this.propertyType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BuildingsLocalCompanion.insert({
    required String id,
    required String landlordId,
    required String name,
    this.propertyType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        landlordId = Value(landlordId),
        name = Value(name);
  static Insertable<BuildingsLocalData> custom({
    Expression<String>? id,
    Expression<String>? landlordId,
    Expression<String>? name,
    Expression<String>? propertyType,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (landlordId != null) 'landlord_id': landlordId,
      if (name != null) 'name': name,
      if (propertyType != null) 'property_type': propertyType,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BuildingsLocalCompanion copyWith(
      {Value<String>? id,
      Value<String>? landlordId,
      Value<String>? name,
      Value<String>? propertyType,
      Value<DateTime>? createdAt,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return BuildingsLocalCompanion(
      id: id ?? this.id,
      landlordId: landlordId ?? this.landlordId,
      name: name ?? this.name,
      propertyType: propertyType ?? this.propertyType,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (landlordId.present) {
      map['landlord_id'] = Variable<String>(landlordId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (propertyType.present) {
      map['property_type'] = Variable<String>(propertyType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuildingsLocalCompanion(')
          ..write('id: $id, ')
          ..write('landlordId: $landlordId, ')
          ..write('name: $name, ')
          ..write('propertyType: $propertyType, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsLocalTable extends UnitsLocal
    with TableInfo<$UnitsLocalTable, UnitsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _buildingIdMeta =
      const VerificationMeta('buildingId');
  @override
  late final GeneratedColumn<String> buildingId = GeneratedColumn<String>(
      'building_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitTypeMeta =
      const VerificationMeta('unitType');
  @override
  late final GeneratedColumn<String> unitType = GeneratedColumn<String>(
      'unit_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('apartment'));
  static const VerificationMeta _roomTypeMeta =
      const VerificationMeta('roomType');
  @override
  late final GeneratedColumn<String> roomType = GeneratedColumn<String>(
      'room_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1br'));
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _rentPerBedMeta =
      const VerificationMeta('rentPerBed');
  @override
  late final GeneratedColumn<double> rentPerBed = GeneratedColumn<double>(
      'rent_per_bed', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _rentTotalMeta =
      const VerificationMeta('rentTotal');
  @override
  late final GeneratedColumn<double> rentTotal = GeneratedColumn<double>(
      'rent_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isOccupiedMeta =
      const VerificationMeta('isOccupied');
  @override
  late final GeneratedColumn<bool> isOccupied = GeneratedColumn<bool>(
      'is_occupied', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_occupied" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        buildingId,
        name,
        unitType,
        roomType,
        capacity,
        rentPerBed,
        rentTotal,
        isOccupied,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units_local';
  @override
  VerificationContext validateIntegrity(Insertable<UnitsLocalData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('building_id')) {
      context.handle(
          _buildingIdMeta,
          buildingId.isAcceptableOrUnknown(
              data['building_id']!, _buildingIdMeta));
    } else if (isInserting) {
      context.missing(_buildingIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit_type')) {
      context.handle(_unitTypeMeta,
          unitType.isAcceptableOrUnknown(data['unit_type']!, _unitTypeMeta));
    }
    if (data.containsKey('room_type')) {
      context.handle(_roomTypeMeta,
          roomType.isAcceptableOrUnknown(data['room_type']!, _roomTypeMeta));
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    }
    if (data.containsKey('rent_per_bed')) {
      context.handle(
          _rentPerBedMeta,
          rentPerBed.isAcceptableOrUnknown(
              data['rent_per_bed']!, _rentPerBedMeta));
    }
    if (data.containsKey('rent_total')) {
      context.handle(_rentTotalMeta,
          rentTotal.isAcceptableOrUnknown(data['rent_total']!, _rentTotalMeta));
    }
    if (data.containsKey('is_occupied')) {
      context.handle(
          _isOccupiedMeta,
          isOccupied.isAcceptableOrUnknown(
              data['is_occupied']!, _isOccupiedMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitsLocalData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      buildingId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}building_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      unitType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_type'])!,
      roomType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}room_type'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity'])!,
      rentPerBed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rent_per_bed'])!,
      rentTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rent_total'])!,
      isOccupied: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_occupied'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $UnitsLocalTable createAlias(String alias) {
    return $UnitsLocalTable(attachedDatabase, alias);
  }
}

class UnitsLocalData extends DataClass implements Insertable<UnitsLocalData> {
  final String id;
  final String buildingId;
  final String name;
  final String unitType;
  final String roomType;
  final int capacity;
  final double rentPerBed;
  final double rentTotal;
  final bool isOccupied;
  final bool synced;
  const UnitsLocalData(
      {required this.id,
      required this.buildingId,
      required this.name,
      required this.unitType,
      required this.roomType,
      required this.capacity,
      required this.rentPerBed,
      required this.rentTotal,
      required this.isOccupied,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['building_id'] = Variable<String>(buildingId);
    map['name'] = Variable<String>(name);
    map['unit_type'] = Variable<String>(unitType);
    map['room_type'] = Variable<String>(roomType);
    map['capacity'] = Variable<int>(capacity);
    map['rent_per_bed'] = Variable<double>(rentPerBed);
    map['rent_total'] = Variable<double>(rentTotal);
    map['is_occupied'] = Variable<bool>(isOccupied);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  UnitsLocalCompanion toCompanion(bool nullToAbsent) {
    return UnitsLocalCompanion(
      id: Value(id),
      buildingId: Value(buildingId),
      name: Value(name),
      unitType: Value(unitType),
      roomType: Value(roomType),
      capacity: Value(capacity),
      rentPerBed: Value(rentPerBed),
      rentTotal: Value(rentTotal),
      isOccupied: Value(isOccupied),
      synced: Value(synced),
    );
  }

  factory UnitsLocalData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitsLocalData(
      id: serializer.fromJson<String>(json['id']),
      buildingId: serializer.fromJson<String>(json['buildingId']),
      name: serializer.fromJson<String>(json['name']),
      unitType: serializer.fromJson<String>(json['unitType']),
      roomType: serializer.fromJson<String>(json['roomType']),
      capacity: serializer.fromJson<int>(json['capacity']),
      rentPerBed: serializer.fromJson<double>(json['rentPerBed']),
      rentTotal: serializer.fromJson<double>(json['rentTotal']),
      isOccupied: serializer.fromJson<bool>(json['isOccupied']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'buildingId': serializer.toJson<String>(buildingId),
      'name': serializer.toJson<String>(name),
      'unitType': serializer.toJson<String>(unitType),
      'roomType': serializer.toJson<String>(roomType),
      'capacity': serializer.toJson<int>(capacity),
      'rentPerBed': serializer.toJson<double>(rentPerBed),
      'rentTotal': serializer.toJson<double>(rentTotal),
      'isOccupied': serializer.toJson<bool>(isOccupied),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  UnitsLocalData copyWith(
          {String? id,
          String? buildingId,
          String? name,
          String? unitType,
          String? roomType,
          int? capacity,
          double? rentPerBed,
          double? rentTotal,
          bool? isOccupied,
          bool? synced}) =>
      UnitsLocalData(
        id: id ?? this.id,
        buildingId: buildingId ?? this.buildingId,
        name: name ?? this.name,
        unitType: unitType ?? this.unitType,
        roomType: roomType ?? this.roomType,
        capacity: capacity ?? this.capacity,
        rentPerBed: rentPerBed ?? this.rentPerBed,
        rentTotal: rentTotal ?? this.rentTotal,
        isOccupied: isOccupied ?? this.isOccupied,
        synced: synced ?? this.synced,
      );
  UnitsLocalData copyWithCompanion(UnitsLocalCompanion data) {
    return UnitsLocalData(
      id: data.id.present ? data.id.value : this.id,
      buildingId:
          data.buildingId.present ? data.buildingId.value : this.buildingId,
      name: data.name.present ? data.name.value : this.name,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      roomType: data.roomType.present ? data.roomType.value : this.roomType,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      rentPerBed:
          data.rentPerBed.present ? data.rentPerBed.value : this.rentPerBed,
      rentTotal: data.rentTotal.present ? data.rentTotal.value : this.rentTotal,
      isOccupied:
          data.isOccupied.present ? data.isOccupied.value : this.isOccupied,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitsLocalData(')
          ..write('id: $id, ')
          ..write('buildingId: $buildingId, ')
          ..write('name: $name, ')
          ..write('unitType: $unitType, ')
          ..write('roomType: $roomType, ')
          ..write('capacity: $capacity, ')
          ..write('rentPerBed: $rentPerBed, ')
          ..write('rentTotal: $rentTotal, ')
          ..write('isOccupied: $isOccupied, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, buildingId, name, unitType, roomType,
      capacity, rentPerBed, rentTotal, isOccupied, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitsLocalData &&
          other.id == this.id &&
          other.buildingId == this.buildingId &&
          other.name == this.name &&
          other.unitType == this.unitType &&
          other.roomType == this.roomType &&
          other.capacity == this.capacity &&
          other.rentPerBed == this.rentPerBed &&
          other.rentTotal == this.rentTotal &&
          other.isOccupied == this.isOccupied &&
          other.synced == this.synced);
}

class UnitsLocalCompanion extends UpdateCompanion<UnitsLocalData> {
  final Value<String> id;
  final Value<String> buildingId;
  final Value<String> name;
  final Value<String> unitType;
  final Value<String> roomType;
  final Value<int> capacity;
  final Value<double> rentPerBed;
  final Value<double> rentTotal;
  final Value<bool> isOccupied;
  final Value<bool> synced;
  final Value<int> rowid;
  const UnitsLocalCompanion({
    this.id = const Value.absent(),
    this.buildingId = const Value.absent(),
    this.name = const Value.absent(),
    this.unitType = const Value.absent(),
    this.roomType = const Value.absent(),
    this.capacity = const Value.absent(),
    this.rentPerBed = const Value.absent(),
    this.rentTotal = const Value.absent(),
    this.isOccupied = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsLocalCompanion.insert({
    required String id,
    required String buildingId,
    required String name,
    this.unitType = const Value.absent(),
    this.roomType = const Value.absent(),
    this.capacity = const Value.absent(),
    this.rentPerBed = const Value.absent(),
    this.rentTotal = const Value.absent(),
    this.isOccupied = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        buildingId = Value(buildingId),
        name = Value(name);
  static Insertable<UnitsLocalData> custom({
    Expression<String>? id,
    Expression<String>? buildingId,
    Expression<String>? name,
    Expression<String>? unitType,
    Expression<String>? roomType,
    Expression<int>? capacity,
    Expression<double>? rentPerBed,
    Expression<double>? rentTotal,
    Expression<bool>? isOccupied,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (buildingId != null) 'building_id': buildingId,
      if (name != null) 'name': name,
      if (unitType != null) 'unit_type': unitType,
      if (roomType != null) 'room_type': roomType,
      if (capacity != null) 'capacity': capacity,
      if (rentPerBed != null) 'rent_per_bed': rentPerBed,
      if (rentTotal != null) 'rent_total': rentTotal,
      if (isOccupied != null) 'is_occupied': isOccupied,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsLocalCompanion copyWith(
      {Value<String>? id,
      Value<String>? buildingId,
      Value<String>? name,
      Value<String>? unitType,
      Value<String>? roomType,
      Value<int>? capacity,
      Value<double>? rentPerBed,
      Value<double>? rentTotal,
      Value<bool>? isOccupied,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return UnitsLocalCompanion(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      name: name ?? this.name,
      unitType: unitType ?? this.unitType,
      roomType: roomType ?? this.roomType,
      capacity: capacity ?? this.capacity,
      rentPerBed: rentPerBed ?? this.rentPerBed,
      rentTotal: rentTotal ?? this.rentTotal,
      isOccupied: isOccupied ?? this.isOccupied,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (buildingId.present) {
      map['building_id'] = Variable<String>(buildingId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<String>(unitType.value);
    }
    if (roomType.present) {
      map['room_type'] = Variable<String>(roomType.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (rentPerBed.present) {
      map['rent_per_bed'] = Variable<double>(rentPerBed.value);
    }
    if (rentTotal.present) {
      map['rent_total'] = Variable<double>(rentTotal.value);
    }
    if (isOccupied.present) {
      map['is_occupied'] = Variable<bool>(isOccupied.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsLocalCompanion(')
          ..write('id: $id, ')
          ..write('buildingId: $buildingId, ')
          ..write('name: $name, ')
          ..write('unitType: $unitType, ')
          ..write('roomType: $roomType, ')
          ..write('capacity: $capacity, ')
          ..write('rentPerBed: $rentPerBed, ')
          ..write('rentTotal: $rentTotal, ')
          ..write('isOccupied: $isOccupied, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TenantsLocalTable extends TenantsLocal
    with TableInfo<$TenantsLocalTable, TenantsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _buildingIdMeta =
      const VerificationMeta('buildingId');
  @override
  late final GeneratedColumn<String> buildingId = GeneratedColumn<String>(
      'building_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bedLabelMeta =
      const VerificationMeta('bedLabel');
  @override
  late final GeneratedColumn<String> bedLabel = GeneratedColumn<String>(
      'bed_label', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isHostelTenantMeta =
      const VerificationMeta('isHostelTenant');
  @override
  late final GeneratedColumn<bool> isHostelTenant = GeneratedColumn<bool>(
      'is_hostel_tenant', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_hostel_tenant" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _depositMeta =
      const VerificationMeta('deposit');
  @override
  late final GeneratedColumn<double> deposit = GeneratedColumn<double>(
      'deposit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        buildingId,
        unitId,
        name,
        phone,
        email,
        bedLabel,
        isHostelTenant,
        deposit,
        status,
        isActive,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenants_local';
  @override
  VerificationContext validateIntegrity(Insertable<TenantsLocalData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('building_id')) {
      context.handle(
          _buildingIdMeta,
          buildingId.isAcceptableOrUnknown(
              data['building_id']!, _buildingIdMeta));
    } else if (isInserting) {
      context.missing(_buildingIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('bed_label')) {
      context.handle(_bedLabelMeta,
          bedLabel.isAcceptableOrUnknown(data['bed_label']!, _bedLabelMeta));
    }
    if (data.containsKey('is_hostel_tenant')) {
      context.handle(
          _isHostelTenantMeta,
          isHostelTenant.isAcceptableOrUnknown(
              data['is_hostel_tenant']!, _isHostelTenantMeta));
    }
    if (data.containsKey('deposit')) {
      context.handle(_depositMeta,
          deposit.isAcceptableOrUnknown(data['deposit']!, _depositMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TenantsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TenantsLocalData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      buildingId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}building_id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      bedLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bed_label'])!,
      isHostelTenant: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_hostel_tenant'])!,
      deposit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}deposit'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $TenantsLocalTable createAlias(String alias) {
    return $TenantsLocalTable(attachedDatabase, alias);
  }
}

class TenantsLocalData extends DataClass
    implements Insertable<TenantsLocalData> {
  final String id;
  final String buildingId;
  final String unitId;
  final String name;
  final String phone;
  final String? email;
  final String bedLabel;
  final bool isHostelTenant;
  final double deposit;
  final String status;
  final bool isActive;
  final bool synced;
  const TenantsLocalData(
      {required this.id,
      required this.buildingId,
      required this.unitId,
      required this.name,
      required this.phone,
      this.email,
      required this.bedLabel,
      required this.isHostelTenant,
      required this.deposit,
      required this.status,
      required this.isActive,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['building_id'] = Variable<String>(buildingId);
    map['unit_id'] = Variable<String>(unitId);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['bed_label'] = Variable<String>(bedLabel);
    map['is_hostel_tenant'] = Variable<bool>(isHostelTenant);
    map['deposit'] = Variable<double>(deposit);
    map['status'] = Variable<String>(status);
    map['is_active'] = Variable<bool>(isActive);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  TenantsLocalCompanion toCompanion(bool nullToAbsent) {
    return TenantsLocalCompanion(
      id: Value(id),
      buildingId: Value(buildingId),
      unitId: Value(unitId),
      name: Value(name),
      phone: Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      bedLabel: Value(bedLabel),
      isHostelTenant: Value(isHostelTenant),
      deposit: Value(deposit),
      status: Value(status),
      isActive: Value(isActive),
      synced: Value(synced),
    );
  }

  factory TenantsLocalData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TenantsLocalData(
      id: serializer.fromJson<String>(json['id']),
      buildingId: serializer.fromJson<String>(json['buildingId']),
      unitId: serializer.fromJson<String>(json['unitId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      bedLabel: serializer.fromJson<String>(json['bedLabel']),
      isHostelTenant: serializer.fromJson<bool>(json['isHostelTenant']),
      deposit: serializer.fromJson<double>(json['deposit']),
      status: serializer.fromJson<String>(json['status']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'buildingId': serializer.toJson<String>(buildingId),
      'unitId': serializer.toJson<String>(unitId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String?>(email),
      'bedLabel': serializer.toJson<String>(bedLabel),
      'isHostelTenant': serializer.toJson<bool>(isHostelTenant),
      'deposit': serializer.toJson<double>(deposit),
      'status': serializer.toJson<String>(status),
      'isActive': serializer.toJson<bool>(isActive),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  TenantsLocalData copyWith(
          {String? id,
          String? buildingId,
          String? unitId,
          String? name,
          String? phone,
          Value<String?> email = const Value.absent(),
          String? bedLabel,
          bool? isHostelTenant,
          double? deposit,
          String? status,
          bool? isActive,
          bool? synced}) =>
      TenantsLocalData(
        id: id ?? this.id,
        buildingId: buildingId ?? this.buildingId,
        unitId: unitId ?? this.unitId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email.present ? email.value : this.email,
        bedLabel: bedLabel ?? this.bedLabel,
        isHostelTenant: isHostelTenant ?? this.isHostelTenant,
        deposit: deposit ?? this.deposit,
        status: status ?? this.status,
        isActive: isActive ?? this.isActive,
        synced: synced ?? this.synced,
      );
  TenantsLocalData copyWithCompanion(TenantsLocalCompanion data) {
    return TenantsLocalData(
      id: data.id.present ? data.id.value : this.id,
      buildingId:
          data.buildingId.present ? data.buildingId.value : this.buildingId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      bedLabel: data.bedLabel.present ? data.bedLabel.value : this.bedLabel,
      isHostelTenant: data.isHostelTenant.present
          ? data.isHostelTenant.value
          : this.isHostelTenant,
      deposit: data.deposit.present ? data.deposit.value : this.deposit,
      status: data.status.present ? data.status.value : this.status,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TenantsLocalData(')
          ..write('id: $id, ')
          ..write('buildingId: $buildingId, ')
          ..write('unitId: $unitId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('bedLabel: $bedLabel, ')
          ..write('isHostelTenant: $isHostelTenant, ')
          ..write('deposit: $deposit, ')
          ..write('status: $status, ')
          ..write('isActive: $isActive, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, buildingId, unitId, name, phone, email,
      bedLabel, isHostelTenant, deposit, status, isActive, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TenantsLocalData &&
          other.id == this.id &&
          other.buildingId == this.buildingId &&
          other.unitId == this.unitId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.bedLabel == this.bedLabel &&
          other.isHostelTenant == this.isHostelTenant &&
          other.deposit == this.deposit &&
          other.status == this.status &&
          other.isActive == this.isActive &&
          other.synced == this.synced);
}

class TenantsLocalCompanion extends UpdateCompanion<TenantsLocalData> {
  final Value<String> id;
  final Value<String> buildingId;
  final Value<String> unitId;
  final Value<String> name;
  final Value<String> phone;
  final Value<String?> email;
  final Value<String> bedLabel;
  final Value<bool> isHostelTenant;
  final Value<double> deposit;
  final Value<String> status;
  final Value<bool> isActive;
  final Value<bool> synced;
  final Value<int> rowid;
  const TenantsLocalCompanion({
    this.id = const Value.absent(),
    this.buildingId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.bedLabel = const Value.absent(),
    this.isHostelTenant = const Value.absent(),
    this.deposit = const Value.absent(),
    this.status = const Value.absent(),
    this.isActive = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TenantsLocalCompanion.insert({
    required String id,
    required String buildingId,
    required String unitId,
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.bedLabel = const Value.absent(),
    this.isHostelTenant = const Value.absent(),
    this.deposit = const Value.absent(),
    this.status = const Value.absent(),
    this.isActive = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        buildingId = Value(buildingId),
        unitId = Value(unitId),
        name = Value(name);
  static Insertable<TenantsLocalData> custom({
    Expression<String>? id,
    Expression<String>? buildingId,
    Expression<String>? unitId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? bedLabel,
    Expression<bool>? isHostelTenant,
    Expression<double>? deposit,
    Expression<String>? status,
    Expression<bool>? isActive,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (buildingId != null) 'building_id': buildingId,
      if (unitId != null) 'unit_id': unitId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (bedLabel != null) 'bed_label': bedLabel,
      if (isHostelTenant != null) 'is_hostel_tenant': isHostelTenant,
      if (deposit != null) 'deposit': deposit,
      if (status != null) 'status': status,
      if (isActive != null) 'is_active': isActive,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TenantsLocalCompanion copyWith(
      {Value<String>? id,
      Value<String>? buildingId,
      Value<String>? unitId,
      Value<String>? name,
      Value<String>? phone,
      Value<String?>? email,
      Value<String>? bedLabel,
      Value<bool>? isHostelTenant,
      Value<double>? deposit,
      Value<String>? status,
      Value<bool>? isActive,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return TenantsLocalCompanion(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      unitId: unitId ?? this.unitId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bedLabel: bedLabel ?? this.bedLabel,
      isHostelTenant: isHostelTenant ?? this.isHostelTenant,
      deposit: deposit ?? this.deposit,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (buildingId.present) {
      map['building_id'] = Variable<String>(buildingId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (bedLabel.present) {
      map['bed_label'] = Variable<String>(bedLabel.value);
    }
    if (isHostelTenant.present) {
      map['is_hostel_tenant'] = Variable<bool>(isHostelTenant.value);
    }
    if (deposit.present) {
      map['deposit'] = Variable<double>(deposit.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantsLocalCompanion(')
          ..write('id: $id, ')
          ..write('buildingId: $buildingId, ')
          ..write('unitId: $unitId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('bedLabel: $bedLabel, ')
          ..write('isHostelTenant: $isHostelTenant, ')
          ..write('deposit: $deposit, ')
          ..write('status: $status, ')
          ..write('isActive: $isActive, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceLocalTable extends MaintenanceLocal
    with TableInfo<$MaintenanceLocalTable, MaintenanceLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _buildingIdMeta =
      const VerificationMeta('buildingId');
  @override
  late final GeneratedColumn<String> buildingId = GeneratedColumn<String>(
      'building_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unpaid'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, buildingId, title, type, status, amount, date, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_local';
  @override
  VerificationContext validateIntegrity(
      Insertable<MaintenanceLocalData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('building_id')) {
      context.handle(
          _buildingIdMeta,
          buildingId.isAcceptableOrUnknown(
              data['building_id']!, _buildingIdMeta));
    } else if (isInserting) {
      context.missing(_buildingIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceLocalData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      buildingId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}building_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $MaintenanceLocalTable createAlias(String alias) {
    return $MaintenanceLocalTable(attachedDatabase, alias);
  }
}

class MaintenanceLocalData extends DataClass
    implements Insertable<MaintenanceLocalData> {
  final String id;
  final String buildingId;
  final String title;
  final String type;
  final String status;
  final double amount;
  final DateTime date;
  final bool synced;
  const MaintenanceLocalData(
      {required this.id,
      required this.buildingId,
      required this.title,
      required this.type,
      required this.status,
      required this.amount,
      required this.date,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['building_id'] = Variable<String>(buildingId);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  MaintenanceLocalCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceLocalCompanion(
      id: Value(id),
      buildingId: Value(buildingId),
      title: Value(title),
      type: Value(type),
      status: Value(status),
      amount: Value(amount),
      date: Value(date),
      synced: Value(synced),
    );
  }

  factory MaintenanceLocalData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceLocalData(
      id: serializer.fromJson<String>(json['id']),
      buildingId: serializer.fromJson<String>(json['buildingId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'buildingId': serializer.toJson<String>(buildingId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  MaintenanceLocalData copyWith(
          {String? id,
          String? buildingId,
          String? title,
          String? type,
          String? status,
          double? amount,
          DateTime? date,
          bool? synced}) =>
      MaintenanceLocalData(
        id: id ?? this.id,
        buildingId: buildingId ?? this.buildingId,
        title: title ?? this.title,
        type: type ?? this.type,
        status: status ?? this.status,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        synced: synced ?? this.synced,
      );
  MaintenanceLocalData copyWithCompanion(MaintenanceLocalCompanion data) {
    return MaintenanceLocalData(
      id: data.id.present ? data.id.value : this.id,
      buildingId:
          data.buildingId.present ? data.buildingId.value : this.buildingId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceLocalData(')
          ..write('id: $id, ')
          ..write('buildingId: $buildingId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, buildingId, title, type, status, amount, date, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceLocalData &&
          other.id == this.id &&
          other.buildingId == this.buildingId &&
          other.title == this.title &&
          other.type == this.type &&
          other.status == this.status &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.synced == this.synced);
}

class MaintenanceLocalCompanion extends UpdateCompanion<MaintenanceLocalData> {
  final Value<String> id;
  final Value<String> buildingId;
  final Value<String> title;
  final Value<String> type;
  final Value<String> status;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<bool> synced;
  final Value<int> rowid;
  const MaintenanceLocalCompanion({
    this.id = const Value.absent(),
    this.buildingId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceLocalCompanion.insert({
    required String id,
    required String buildingId,
    required String title,
    required String type,
    this.status = const Value.absent(),
    required double amount,
    required DateTime date,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        buildingId = Value(buildingId),
        title = Value(title),
        type = Value(type),
        amount = Value(amount),
        date = Value(date);
  static Insertable<MaintenanceLocalData> custom({
    Expression<String>? id,
    Expression<String>? buildingId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? status,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (buildingId != null) 'building_id': buildingId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceLocalCompanion copyWith(
      {Value<String>? id,
      Value<String>? buildingId,
      Value<String>? title,
      Value<String>? type,
      Value<String>? status,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return MaintenanceLocalCompanion(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (buildingId.present) {
      map['building_id'] = Variable<String>(buildingId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceLocalCompanion(')
          ..write('id: $id, ')
          ..write('buildingId: $buildingId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxQueueTable extends OutboxQueue
    with TableInfo<$OutboxQueueTable, OutboxQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetTableMeta =
      const VerificationMeta('targetTable');
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
      'target_table', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _retriesMeta =
      const VerificationMeta('retries');
  @override
  late final GeneratedColumn<int> retries = GeneratedColumn<int>(
      'retries', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _failedMeta = const VerificationMeta('failed');
  @override
  late final GeneratedColumn<bool> failed = GeneratedColumn<bool>(
      'failed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("failed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, operation, targetTable, payload, createdAt, retries, failed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_queue';
  @override
  VerificationContext validateIntegrity(Insertable<OutboxQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('target_table')) {
      context.handle(
          _targetTableMeta,
          targetTable.isAcceptableOrUnknown(
              data['target_table']!, _targetTableMeta));
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('retries')) {
      context.handle(_retriesMeta,
          retries.isAcceptableOrUnknown(data['retries']!, _retriesMeta));
    }
    if (data.containsKey('failed')) {
      context.handle(_failedMeta,
          failed.isAcceptableOrUnknown(data['failed']!, _failedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      targetTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_table'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retries: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retries'])!,
      failed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}failed'])!,
    );
  }

  @override
  $OutboxQueueTable createAlias(String alias) {
    return $OutboxQueueTable(attachedDatabase, alias);
  }
}

class OutboxQueueData extends DataClass implements Insertable<OutboxQueueData> {
  final int id;
  final String operation;
  final String targetTable;
  final String payload;
  final DateTime createdAt;
  final int retries;
  final bool failed;
  const OutboxQueueData(
      {required this.id,
      required this.operation,
      required this.targetTable,
      required this.payload,
      required this.createdAt,
      required this.retries,
      required this.failed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation'] = Variable<String>(operation);
    map['target_table'] = Variable<String>(targetTable);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retries'] = Variable<int>(retries);
    map['failed'] = Variable<bool>(failed);
    return map;
  }

  OutboxQueueCompanion toCompanion(bool nullToAbsent) {
    return OutboxQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      targetTable: Value(targetTable),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retries: Value(retries),
      failed: Value(failed),
    );
  }

  factory OutboxQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxQueueData(
      id: serializer.fromJson<int>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retries: serializer.fromJson<int>(json['retries']),
      failed: serializer.fromJson<bool>(json['failed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer.toJson<String>(operation),
      'targetTable': serializer.toJson<String>(targetTable),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retries': serializer.toJson<int>(retries),
      'failed': serializer.toJson<bool>(failed),
    };
  }

  OutboxQueueData copyWith(
          {int? id,
          String? operation,
          String? targetTable,
          String? payload,
          DateTime? createdAt,
          int? retries,
          bool? failed}) =>
      OutboxQueueData(
        id: id ?? this.id,
        operation: operation ?? this.operation,
        targetTable: targetTable ?? this.targetTable,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        retries: retries ?? this.retries,
        failed: failed ?? this.failed,
      );
  OutboxQueueData copyWithCompanion(OutboxQueueCompanion data) {
    return OutboxQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      targetTable:
          data.targetTable.present ? data.targetTable.value : this.targetTable,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retries: data.retries.present ? data.retries.value : this.retries,
      failed: data.failed.present ? data.failed.value : this.failed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('targetTable: $targetTable, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retries: $retries, ')
          ..write('failed: $failed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, operation, targetTable, payload, createdAt, retries, failed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.targetTable == this.targetTable &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retries == this.retries &&
          other.failed == this.failed);
}

class OutboxQueueCompanion extends UpdateCompanion<OutboxQueueData> {
  final Value<int> id;
  final Value<String> operation;
  final Value<String> targetTable;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> retries;
  final Value<bool> failed;
  const OutboxQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retries = const Value.absent(),
    this.failed = const Value.absent(),
  });
  OutboxQueueCompanion.insert({
    this.id = const Value.absent(),
    required String operation,
    required String targetTable,
    required String payload,
    this.createdAt = const Value.absent(),
    this.retries = const Value.absent(),
    this.failed = const Value.absent(),
  })  : operation = Value(operation),
        targetTable = Value(targetTable),
        payload = Value(payload);
  static Insertable<OutboxQueueData> custom({
    Expression<int>? id,
    Expression<String>? operation,
    Expression<String>? targetTable,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retries,
    Expression<bool>? failed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (targetTable != null) 'target_table': targetTable,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retries != null) 'retries': retries,
      if (failed != null) 'failed': failed,
    });
  }

  OutboxQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? operation,
      Value<String>? targetTable,
      Value<String>? payload,
      Value<DateTime>? createdAt,
      Value<int>? retries,
      Value<bool>? failed}) {
    return OutboxQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      targetTable: targetTable ?? this.targetTable,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retries: retries ?? this.retries,
      failed: failed ?? this.failed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retries.present) {
      map['retries'] = Variable<int>(retries.value);
    }
    if (failed.present) {
      map['failed'] = Variable<bool>(failed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('targetTable: $targetTable, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retries: $retries, ')
          ..write('failed: $failed')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BuildingsLocalTable buildingsLocal = $BuildingsLocalTable(this);
  late final $UnitsLocalTable unitsLocal = $UnitsLocalTable(this);
  late final $TenantsLocalTable tenantsLocal = $TenantsLocalTable(this);
  late final $MaintenanceLocalTable maintenanceLocal =
      $MaintenanceLocalTable(this);
  late final $OutboxQueueTable outboxQueue = $OutboxQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [buildingsLocal, unitsLocal, tenantsLocal, maintenanceLocal, outboxQueue];
}

typedef $$BuildingsLocalTableCreateCompanionBuilder = BuildingsLocalCompanion
    Function({
  required String id,
  required String landlordId,
  required String name,
  Value<String> propertyType,
  Value<DateTime> createdAt,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$BuildingsLocalTableUpdateCompanionBuilder = BuildingsLocalCompanion
    Function({
  Value<String> id,
  Value<String> landlordId,
  Value<String> name,
  Value<String> propertyType,
  Value<DateTime> createdAt,
  Value<bool> synced,
  Value<int> rowid,
});

class $$BuildingsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $BuildingsLocalTable> {
  $$BuildingsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get landlordId => $composableBuilder(
      column: $table.landlordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get propertyType => $composableBuilder(
      column: $table.propertyType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$BuildingsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $BuildingsLocalTable> {
  $$BuildingsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get landlordId => $composableBuilder(
      column: $table.landlordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get propertyType => $composableBuilder(
      column: $table.propertyType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$BuildingsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $BuildingsLocalTable> {
  $$BuildingsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get landlordId => $composableBuilder(
      column: $table.landlordId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get propertyType => $composableBuilder(
      column: $table.propertyType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$BuildingsLocalTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BuildingsLocalTable,
    BuildingsLocalData,
    $$BuildingsLocalTableFilterComposer,
    $$BuildingsLocalTableOrderingComposer,
    $$BuildingsLocalTableAnnotationComposer,
    $$BuildingsLocalTableCreateCompanionBuilder,
    $$BuildingsLocalTableUpdateCompanionBuilder,
    (
      BuildingsLocalData,
      BaseReferences<_$AppDatabase, $BuildingsLocalTable, BuildingsLocalData>
    ),
    BuildingsLocalData,
    PrefetchHooks Function()> {
  $$BuildingsLocalTableTableManager(
      _$AppDatabase db, $BuildingsLocalTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BuildingsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BuildingsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BuildingsLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> landlordId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> propertyType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BuildingsLocalCompanion(
            id: id,
            landlordId: landlordId,
            name: name,
            propertyType: propertyType,
            createdAt: createdAt,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String landlordId,
            required String name,
            Value<String> propertyType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BuildingsLocalCompanion.insert(
            id: id,
            landlordId: landlordId,
            name: name,
            propertyType: propertyType,
            createdAt: createdAt,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BuildingsLocalTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BuildingsLocalTable,
    BuildingsLocalData,
    $$BuildingsLocalTableFilterComposer,
    $$BuildingsLocalTableOrderingComposer,
    $$BuildingsLocalTableAnnotationComposer,
    $$BuildingsLocalTableCreateCompanionBuilder,
    $$BuildingsLocalTableUpdateCompanionBuilder,
    (
      BuildingsLocalData,
      BaseReferences<_$AppDatabase, $BuildingsLocalTable, BuildingsLocalData>
    ),
    BuildingsLocalData,
    PrefetchHooks Function()>;
typedef $$UnitsLocalTableCreateCompanionBuilder = UnitsLocalCompanion Function({
  required String id,
  required String buildingId,
  required String name,
  Value<String> unitType,
  Value<String> roomType,
  Value<int> capacity,
  Value<double> rentPerBed,
  Value<double> rentTotal,
  Value<bool> isOccupied,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$UnitsLocalTableUpdateCompanionBuilder = UnitsLocalCompanion Function({
  Value<String> id,
  Value<String> buildingId,
  Value<String> name,
  Value<String> unitType,
  Value<String> roomType,
  Value<int> capacity,
  Value<double> rentPerBed,
  Value<double> rentTotal,
  Value<bool> isOccupied,
  Value<bool> synced,
  Value<int> rowid,
});

class $$UnitsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $UnitsLocalTable> {
  $$UnitsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buildingId => $composableBuilder(
      column: $table.buildingId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitType => $composableBuilder(
      column: $table.unitType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roomType => $composableBuilder(
      column: $table.roomType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rentPerBed => $composableBuilder(
      column: $table.rentPerBed, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rentTotal => $composableBuilder(
      column: $table.rentTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOccupied => $composableBuilder(
      column: $table.isOccupied, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$UnitsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsLocalTable> {
  $$UnitsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buildingId => $composableBuilder(
      column: $table.buildingId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitType => $composableBuilder(
      column: $table.unitType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roomType => $composableBuilder(
      column: $table.roomType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rentPerBed => $composableBuilder(
      column: $table.rentPerBed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rentTotal => $composableBuilder(
      column: $table.rentTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOccupied => $composableBuilder(
      column: $table.isOccupied, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$UnitsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsLocalTable> {
  $$UnitsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get buildingId => $composableBuilder(
      column: $table.buildingId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unitType =>
      $composableBuilder(column: $table.unitType, builder: (column) => column);

  GeneratedColumn<String> get roomType =>
      $composableBuilder(column: $table.roomType, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<double> get rentPerBed => $composableBuilder(
      column: $table.rentPerBed, builder: (column) => column);

  GeneratedColumn<double> get rentTotal =>
      $composableBuilder(column: $table.rentTotal, builder: (column) => column);

  GeneratedColumn<bool> get isOccupied => $composableBuilder(
      column: $table.isOccupied, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$UnitsLocalTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnitsLocalTable,
    UnitsLocalData,
    $$UnitsLocalTableFilterComposer,
    $$UnitsLocalTableOrderingComposer,
    $$UnitsLocalTableAnnotationComposer,
    $$UnitsLocalTableCreateCompanionBuilder,
    $$UnitsLocalTableUpdateCompanionBuilder,
    (
      UnitsLocalData,
      BaseReferences<_$AppDatabase, $UnitsLocalTable, UnitsLocalData>
    ),
    UnitsLocalData,
    PrefetchHooks Function()> {
  $$UnitsLocalTableTableManager(_$AppDatabase db, $UnitsLocalTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> buildingId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> unitType = const Value.absent(),
            Value<String> roomType = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<double> rentPerBed = const Value.absent(),
            Value<double> rentTotal = const Value.absent(),
            Value<bool> isOccupied = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsLocalCompanion(
            id: id,
            buildingId: buildingId,
            name: name,
            unitType: unitType,
            roomType: roomType,
            capacity: capacity,
            rentPerBed: rentPerBed,
            rentTotal: rentTotal,
            isOccupied: isOccupied,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String buildingId,
            required String name,
            Value<String> unitType = const Value.absent(),
            Value<String> roomType = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<double> rentPerBed = const Value.absent(),
            Value<double> rentTotal = const Value.absent(),
            Value<bool> isOccupied = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsLocalCompanion.insert(
            id: id,
            buildingId: buildingId,
            name: name,
            unitType: unitType,
            roomType: roomType,
            capacity: capacity,
            rentPerBed: rentPerBed,
            rentTotal: rentTotal,
            isOccupied: isOccupied,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnitsLocalTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnitsLocalTable,
    UnitsLocalData,
    $$UnitsLocalTableFilterComposer,
    $$UnitsLocalTableOrderingComposer,
    $$UnitsLocalTableAnnotationComposer,
    $$UnitsLocalTableCreateCompanionBuilder,
    $$UnitsLocalTableUpdateCompanionBuilder,
    (
      UnitsLocalData,
      BaseReferences<_$AppDatabase, $UnitsLocalTable, UnitsLocalData>
    ),
    UnitsLocalData,
    PrefetchHooks Function()>;
typedef $$TenantsLocalTableCreateCompanionBuilder = TenantsLocalCompanion
    Function({
  required String id,
  required String buildingId,
  required String unitId,
  required String name,
  Value<String> phone,
  Value<String?> email,
  Value<String> bedLabel,
  Value<bool> isHostelTenant,
  Value<double> deposit,
  Value<String> status,
  Value<bool> isActive,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$TenantsLocalTableUpdateCompanionBuilder = TenantsLocalCompanion
    Function({
  Value<String> id,
  Value<String> buildingId,
  Value<String> unitId,
  Value<String> name,
  Value<String> phone,
  Value<String?> email,
  Value<String> bedLabel,
  Value<bool> isHostelTenant,
  Value<double> deposit,
  Value<String> status,
  Value<bool> isActive,
  Value<bool> synced,
  Value<int> rowid,
});

class $$TenantsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $TenantsLocalTable> {
  $$TenantsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buildingId => $composableBuilder(
      column: $table.buildingId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bedLabel => $composableBuilder(
      column: $table.bedLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHostelTenant => $composableBuilder(
      column: $table.isHostelTenant,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get deposit => $composableBuilder(
      column: $table.deposit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$TenantsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantsLocalTable> {
  $$TenantsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buildingId => $composableBuilder(
      column: $table.buildingId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bedLabel => $composableBuilder(
      column: $table.bedLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHostelTenant => $composableBuilder(
      column: $table.isHostelTenant,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get deposit => $composableBuilder(
      column: $table.deposit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$TenantsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantsLocalTable> {
  $$TenantsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get buildingId => $composableBuilder(
      column: $table.buildingId, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get bedLabel =>
      $composableBuilder(column: $table.bedLabel, builder: (column) => column);

  GeneratedColumn<bool> get isHostelTenant => $composableBuilder(
      column: $table.isHostelTenant, builder: (column) => column);

  GeneratedColumn<double> get deposit =>
      $composableBuilder(column: $table.deposit, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$TenantsLocalTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TenantsLocalTable,
    TenantsLocalData,
    $$TenantsLocalTableFilterComposer,
    $$TenantsLocalTableOrderingComposer,
    $$TenantsLocalTableAnnotationComposer,
    $$TenantsLocalTableCreateCompanionBuilder,
    $$TenantsLocalTableUpdateCompanionBuilder,
    (
      TenantsLocalData,
      BaseReferences<_$AppDatabase, $TenantsLocalTable, TenantsLocalData>
    ),
    TenantsLocalData,
    PrefetchHooks Function()> {
  $$TenantsLocalTableTableManager(_$AppDatabase db, $TenantsLocalTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TenantsLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> buildingId = const Value.absent(),
            Value<String> unitId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String> bedLabel = const Value.absent(),
            Value<bool> isHostelTenant = const Value.absent(),
            Value<double> deposit = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TenantsLocalCompanion(
            id: id,
            buildingId: buildingId,
            unitId: unitId,
            name: name,
            phone: phone,
            email: email,
            bedLabel: bedLabel,
            isHostelTenant: isHostelTenant,
            deposit: deposit,
            status: status,
            isActive: isActive,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String buildingId,
            required String unitId,
            required String name,
            Value<String> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String> bedLabel = const Value.absent(),
            Value<bool> isHostelTenant = const Value.absent(),
            Value<double> deposit = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TenantsLocalCompanion.insert(
            id: id,
            buildingId: buildingId,
            unitId: unitId,
            name: name,
            phone: phone,
            email: email,
            bedLabel: bedLabel,
            isHostelTenant: isHostelTenant,
            deposit: deposit,
            status: status,
            isActive: isActive,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TenantsLocalTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TenantsLocalTable,
    TenantsLocalData,
    $$TenantsLocalTableFilterComposer,
    $$TenantsLocalTableOrderingComposer,
    $$TenantsLocalTableAnnotationComposer,
    $$TenantsLocalTableCreateCompanionBuilder,
    $$TenantsLocalTableUpdateCompanionBuilder,
    (
      TenantsLocalData,
      BaseReferences<_$AppDatabase, $TenantsLocalTable, TenantsLocalData>
    ),
    TenantsLocalData,
    PrefetchHooks Function()>;
typedef $$MaintenanceLocalTableCreateCompanionBuilder
    = MaintenanceLocalCompanion Function({
  required String id,
  required String buildingId,
  required String title,
  required String type,
  Value<String> status,
  required double amount,
  required DateTime date,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$MaintenanceLocalTableUpdateCompanionBuilder
    = MaintenanceLocalCompanion Function({
  Value<String> id,
  Value<String> buildingId,
  Value<String> title,
  Value<String> type,
  Value<String> status,
  Value<double> amount,
  Value<DateTime> date,
  Value<bool> synced,
  Value<int> rowid,
});

class $$MaintenanceLocalTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceLocalTable> {
  $$MaintenanceLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buildingId => $composableBuilder(
      column: $table.buildingId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$MaintenanceLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceLocalTable> {
  $$MaintenanceLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buildingId => $composableBuilder(
      column: $table.buildingId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$MaintenanceLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceLocalTable> {
  $$MaintenanceLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get buildingId => $composableBuilder(
      column: $table.buildingId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$MaintenanceLocalTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceLocalTable,
    MaintenanceLocalData,
    $$MaintenanceLocalTableFilterComposer,
    $$MaintenanceLocalTableOrderingComposer,
    $$MaintenanceLocalTableAnnotationComposer,
    $$MaintenanceLocalTableCreateCompanionBuilder,
    $$MaintenanceLocalTableUpdateCompanionBuilder,
    (
      MaintenanceLocalData,
      BaseReferences<_$AppDatabase, $MaintenanceLocalTable,
          MaintenanceLocalData>
    ),
    MaintenanceLocalData,
    PrefetchHooks Function()> {
  $$MaintenanceLocalTableTableManager(
      _$AppDatabase db, $MaintenanceLocalTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> buildingId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceLocalCompanion(
            id: id,
            buildingId: buildingId,
            title: title,
            type: type,
            status: status,
            amount: amount,
            date: date,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String buildingId,
            required String title,
            required String type,
            Value<String> status = const Value.absent(),
            required double amount,
            required DateTime date,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceLocalCompanion.insert(
            id: id,
            buildingId: buildingId,
            title: title,
            type: type,
            status: status,
            amount: amount,
            date: date,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MaintenanceLocalTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaintenanceLocalTable,
    MaintenanceLocalData,
    $$MaintenanceLocalTableFilterComposer,
    $$MaintenanceLocalTableOrderingComposer,
    $$MaintenanceLocalTableAnnotationComposer,
    $$MaintenanceLocalTableCreateCompanionBuilder,
    $$MaintenanceLocalTableUpdateCompanionBuilder,
    (
      MaintenanceLocalData,
      BaseReferences<_$AppDatabase, $MaintenanceLocalTable,
          MaintenanceLocalData>
    ),
    MaintenanceLocalData,
    PrefetchHooks Function()>;
typedef $$OutboxQueueTableCreateCompanionBuilder = OutboxQueueCompanion
    Function({
  Value<int> id,
  required String operation,
  required String targetTable,
  required String payload,
  Value<DateTime> createdAt,
  Value<int> retries,
  Value<bool> failed,
});
typedef $$OutboxQueueTableUpdateCompanionBuilder = OutboxQueueCompanion
    Function({
  Value<int> id,
  Value<String> operation,
  Value<String> targetTable,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> retries,
  Value<bool> failed,
});

class $$OutboxQueueTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxQueueTable> {
  $$OutboxQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retries => $composableBuilder(
      column: $table.retries, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get failed => $composableBuilder(
      column: $table.failed, builder: (column) => ColumnFilters(column));
}

class $$OutboxQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxQueueTable> {
  $$OutboxQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retries => $composableBuilder(
      column: $table.retries, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get failed => $composableBuilder(
      column: $table.failed, builder: (column) => ColumnOrderings(column));
}

class $$OutboxQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxQueueTable> {
  $$OutboxQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retries =>
      $composableBuilder(column: $table.retries, builder: (column) => column);

  GeneratedColumn<bool> get failed =>
      $composableBuilder(column: $table.failed, builder: (column) => column);
}

class $$OutboxQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OutboxQueueTable,
    OutboxQueueData,
    $$OutboxQueueTableFilterComposer,
    $$OutboxQueueTableOrderingComposer,
    $$OutboxQueueTableAnnotationComposer,
    $$OutboxQueueTableCreateCompanionBuilder,
    $$OutboxQueueTableUpdateCompanionBuilder,
    (
      OutboxQueueData,
      BaseReferences<_$AppDatabase, $OutboxQueueTable, OutboxQueueData>
    ),
    OutboxQueueData,
    PrefetchHooks Function()> {
  $$OutboxQueueTableTableManager(_$AppDatabase db, $OutboxQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> targetTable = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retries = const Value.absent(),
            Value<bool> failed = const Value.absent(),
          }) =>
              OutboxQueueCompanion(
            id: id,
            operation: operation,
            targetTable: targetTable,
            payload: payload,
            createdAt: createdAt,
            retries: retries,
            failed: failed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String operation,
            required String targetTable,
            required String payload,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retries = const Value.absent(),
            Value<bool> failed = const Value.absent(),
          }) =>
              OutboxQueueCompanion.insert(
            id: id,
            operation: operation,
            targetTable: targetTable,
            payload: payload,
            createdAt: createdAt,
            retries: retries,
            failed: failed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OutboxQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OutboxQueueTable,
    OutboxQueueData,
    $$OutboxQueueTableFilterComposer,
    $$OutboxQueueTableOrderingComposer,
    $$OutboxQueueTableAnnotationComposer,
    $$OutboxQueueTableCreateCompanionBuilder,
    $$OutboxQueueTableUpdateCompanionBuilder,
    (
      OutboxQueueData,
      BaseReferences<_$AppDatabase, $OutboxQueueTable, OutboxQueueData>
    ),
    OutboxQueueData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BuildingsLocalTableTableManager get buildingsLocal =>
      $$BuildingsLocalTableTableManager(_db, _db.buildingsLocal);
  $$UnitsLocalTableTableManager get unitsLocal =>
      $$UnitsLocalTableTableManager(_db, _db.unitsLocal);
  $$TenantsLocalTableTableManager get tenantsLocal =>
      $$TenantsLocalTableTableManager(_db, _db.tenantsLocal);
  $$MaintenanceLocalTableTableManager get maintenanceLocal =>
      $$MaintenanceLocalTableTableManager(_db, _db.maintenanceLocal);
  $$OutboxQueueTableTableManager get outboxQueue =>
      $$OutboxQueueTableTableManager(_db, _db.outboxQueue);
}
