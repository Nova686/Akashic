// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'akashic_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceKeyMeta = const VerificationMeta(
    'sourceKey',
  );
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
    'source_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionPartsMeta = const VerificationMeta(
    'conditionParts',
  );
  @override
  late final GeneratedColumn<String> conditionParts = GeneratedColumn<String>(
    'condition_parts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentId,
    name,
    colorValue,
    type,
    sourceKey,
    conditionParts,
    position,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('source_key')) {
      context.handle(
        _sourceKeyMeta,
        sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta),
      );
    }
    if (data.containsKey('condition_parts')) {
      context.handle(
        _conditionPartsMeta,
        conditionParts.isAcceptableOrUnknown(
          data['condition_parts']!,
          _conditionPartsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conditionPartsMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      sourceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_key'],
      ),
      conditionParts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_parts'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String? parentId;
  final String name;
  final int colorValue;
  final String type;
  final String? sourceKey;
  final String conditionParts;
  final int position;
  final DateTime createdAt;
  const CategoryRow({
    required this.id,
    this.parentId,
    required this.name,
    required this.colorValue,
    required this.type,
    this.sourceKey,
    required this.conditionParts,
    required this.position,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['color_value'] = Variable<int>(colorValue);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || sourceKey != null) {
      map['source_key'] = Variable<String>(sourceKey);
    }
    map['condition_parts'] = Variable<String>(conditionParts);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      colorValue: Value(colorValue),
      type: Value(type),
      sourceKey: sourceKey == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceKey),
      conditionParts: Value(conditionParts),
      position: Value(position),
      createdAt: Value(createdAt),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      type: serializer.fromJson<String>(json['type']),
      sourceKey: serializer.fromJson<String?>(json['sourceKey']),
      conditionParts: serializer.fromJson<String>(json['conditionParts']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int>(colorValue),
      'type': serializer.toJson<String>(type),
      'sourceKey': serializer.toJson<String?>(sourceKey),
      'conditionParts': serializer.toJson<String>(conditionParts),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoryRow copyWith({
    String? id,
    Value<String?> parentId = const Value.absent(),
    String? name,
    int? colorValue,
    String? type,
    Value<String?> sourceKey = const Value.absent(),
    String? conditionParts,
    int? position,
    DateTime? createdAt,
  }) => CategoryRow(
    id: id ?? this.id,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    colorValue: colorValue ?? this.colorValue,
    type: type ?? this.type,
    sourceKey: sourceKey.present ? sourceKey.value : this.sourceKey,
    conditionParts: conditionParts ?? this.conditionParts,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      type: data.type.present ? data.type.value : this.type,
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      conditionParts: data.conditionParts.present
          ? data.conditionParts.value
          : this.conditionParts,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('type: $type, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('conditionParts: $conditionParts, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentId,
    name,
    colorValue,
    type,
    sourceKey,
    conditionParts,
    position,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.type == this.type &&
          other.sourceKey == this.sourceKey &&
          other.conditionParts == this.conditionParts &&
          other.position == this.position &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<int> colorValue;
  final Value<String> type;
  final Value<String?> sourceKey;
  final Value<String> conditionParts;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.type = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.conditionParts = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    this.parentId = const Value.absent(),
    required String name,
    required int colorValue,
    required String type,
    this.sourceKey = const Value.absent(),
    required String conditionParts,
    required int position,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorValue = Value(colorValue),
       type = Value(type),
       conditionParts = Value(conditionParts),
       position = Value(position);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<String>? type,
    Expression<String>? sourceKey,
    Expression<String>? conditionParts,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (type != null) 'type': type,
      if (sourceKey != null) 'source_key': sourceKey,
      if (conditionParts != null) 'condition_parts': conditionParts,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? parentId,
    Value<String>? name,
    Value<int>? colorValue,
    Value<String>? type,
    Value<String?>? sourceKey,
    Value<String>? conditionParts,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      type: type ?? this.type,
      sourceKey: sourceKey ?? this.sourceKey,
      conditionParts: conditionParts ?? this.conditionParts,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (conditionParts.present) {
      map['condition_parts'] = Variable<String>(conditionParts.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('type: $type, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('conditionParts: $conditionParts, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SeriesTableTable extends SeriesTable
    with TableInfo<$SeriesTableTable, SeriesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _originalLanguageMeta = const VerificationMeta(
    'originalLanguage',
  );
  @override
  late final GeneratedColumn<String> originalLanguage = GeneratedColumn<String>(
    'original_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatorMeta = const VerificationMeta(
    'creator',
  );
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
    'creator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedVolumesMeta = const VerificationMeta(
    'publishedVolumes',
  );
  @override
  late final GeneratedColumn<int> publishedVolumes = GeneratedColumn<int>(
    'published_volumes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceKeyMeta = const VerificationMeta(
    'sourceKey',
  );
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
    'source_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalWorkIdMeta = const VerificationMeta(
    'externalWorkId',
  );
  @override
  late final GeneratedColumn<String> externalWorkId = GeneratedColumn<String>(
    'external_work_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    originalLanguage,
    creator,
    publishedVolumes,
    sourceKey,
    externalWorkId,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'series';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeriesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('original_language')) {
      context.handle(
        _originalLanguageMeta,
        originalLanguage.isAcceptableOrUnknown(
          data['original_language']!,
          _originalLanguageMeta,
        ),
      );
    }
    if (data.containsKey('creator')) {
      context.handle(
        _creatorMeta,
        creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta),
      );
    }
    if (data.containsKey('published_volumes')) {
      context.handle(
        _publishedVolumesMeta,
        publishedVolumes.isAcceptableOrUnknown(
          data['published_volumes']!,
          _publishedVolumesMeta,
        ),
      );
    }
    if (data.containsKey('source_key')) {
      context.handle(
        _sourceKeyMeta,
        sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta),
      );
    }
    if (data.containsKey('external_work_id')) {
      context.handle(
        _externalWorkIdMeta,
        externalWorkId.isAcceptableOrUnknown(
          data['external_work_id']!,
          _externalWorkIdMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SeriesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeriesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      originalLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_language'],
      ),
      creator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator'],
      ),
      publishedVolumes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}published_volumes'],
      ),
      sourceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_key'],
      ),
      externalWorkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_work_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SeriesTableTable createAlias(String alias) {
    return $SeriesTableTable(attachedDatabase, alias);
  }
}

class SeriesRow extends DataClass implements Insertable<SeriesRow> {
  final String id;
  final String categoryId;
  final String? originalLanguage;
  final String? creator;
  final int? publishedVolumes;
  final String? sourceKey;
  final String? externalWorkId;
  final String? status;
  final DateTime createdAt;
  const SeriesRow({
    required this.id,
    required this.categoryId,
    this.originalLanguage,
    this.creator,
    this.publishedVolumes,
    this.sourceKey,
    this.externalWorkId,
    this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || originalLanguage != null) {
      map['original_language'] = Variable<String>(originalLanguage);
    }
    if (!nullToAbsent || creator != null) {
      map['creator'] = Variable<String>(creator);
    }
    if (!nullToAbsent || publishedVolumes != null) {
      map['published_volumes'] = Variable<int>(publishedVolumes);
    }
    if (!nullToAbsent || sourceKey != null) {
      map['source_key'] = Variable<String>(sourceKey);
    }
    if (!nullToAbsent || externalWorkId != null) {
      map['external_work_id'] = Variable<String>(externalWorkId);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SeriesTableCompanion toCompanion(bool nullToAbsent) {
    return SeriesTableCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      originalLanguage: originalLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLanguage),
      creator: creator == null && nullToAbsent
          ? const Value.absent()
          : Value(creator),
      publishedVolumes: publishedVolumes == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedVolumes),
      sourceKey: sourceKey == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceKey),
      externalWorkId: externalWorkId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalWorkId),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory SeriesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeriesRow(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      originalLanguage: serializer.fromJson<String?>(json['originalLanguage']),
      creator: serializer.fromJson<String?>(json['creator']),
      publishedVolumes: serializer.fromJson<int?>(json['publishedVolumes']),
      sourceKey: serializer.fromJson<String?>(json['sourceKey']),
      externalWorkId: serializer.fromJson<String?>(json['externalWorkId']),
      status: serializer.fromJson<String?>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'originalLanguage': serializer.toJson<String?>(originalLanguage),
      'creator': serializer.toJson<String?>(creator),
      'publishedVolumes': serializer.toJson<int?>(publishedVolumes),
      'sourceKey': serializer.toJson<String?>(sourceKey),
      'externalWorkId': serializer.toJson<String?>(externalWorkId),
      'status': serializer.toJson<String?>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SeriesRow copyWith({
    String? id,
    String? categoryId,
    Value<String?> originalLanguage = const Value.absent(),
    Value<String?> creator = const Value.absent(),
    Value<int?> publishedVolumes = const Value.absent(),
    Value<String?> sourceKey = const Value.absent(),
    Value<String?> externalWorkId = const Value.absent(),
    Value<String?> status = const Value.absent(),
    DateTime? createdAt,
  }) => SeriesRow(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    originalLanguage: originalLanguage.present
        ? originalLanguage.value
        : this.originalLanguage,
    creator: creator.present ? creator.value : this.creator,
    publishedVolumes: publishedVolumes.present
        ? publishedVolumes.value
        : this.publishedVolumes,
    sourceKey: sourceKey.present ? sourceKey.value : this.sourceKey,
    externalWorkId: externalWorkId.present
        ? externalWorkId.value
        : this.externalWorkId,
    status: status.present ? status.value : this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  SeriesRow copyWithCompanion(SeriesTableCompanion data) {
    return SeriesRow(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      originalLanguage: data.originalLanguage.present
          ? data.originalLanguage.value
          : this.originalLanguage,
      creator: data.creator.present ? data.creator.value : this.creator,
      publishedVolumes: data.publishedVolumes.present
          ? data.publishedVolumes.value
          : this.publishedVolumes,
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      externalWorkId: data.externalWorkId.present
          ? data.externalWorkId.value
          : this.externalWorkId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeriesRow(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('creator: $creator, ')
          ..write('publishedVolumes: $publishedVolumes, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('externalWorkId: $externalWorkId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    originalLanguage,
    creator,
    publishedVolumes,
    sourceKey,
    externalWorkId,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeriesRow &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.originalLanguage == this.originalLanguage &&
          other.creator == this.creator &&
          other.publishedVolumes == this.publishedVolumes &&
          other.sourceKey == this.sourceKey &&
          other.externalWorkId == this.externalWorkId &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class SeriesTableCompanion extends UpdateCompanion<SeriesRow> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String?> originalLanguage;
  final Value<String?> creator;
  final Value<int?> publishedVolumes;
  final Value<String?> sourceKey;
  final Value<String?> externalWorkId;
  final Value<String?> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SeriesTableCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.creator = const Value.absent(),
    this.publishedVolumes = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.externalWorkId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeriesTableCompanion.insert({
    required String id,
    required String categoryId,
    this.originalLanguage = const Value.absent(),
    this.creator = const Value.absent(),
    this.publishedVolumes = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.externalWorkId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryId = Value(categoryId);
  static Insertable<SeriesRow> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? originalLanguage,
    Expression<String>? creator,
    Expression<int>? publishedVolumes,
    Expression<String>? sourceKey,
    Expression<String>? externalWorkId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (originalLanguage != null) 'original_language': originalLanguage,
      if (creator != null) 'creator': creator,
      if (publishedVolumes != null) 'published_volumes': publishedVolumes,
      if (sourceKey != null) 'source_key': sourceKey,
      if (externalWorkId != null) 'external_work_id': externalWorkId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<String?>? originalLanguage,
    Value<String?>? creator,
    Value<int?>? publishedVolumes,
    Value<String?>? sourceKey,
    Value<String?>? externalWorkId,
    Value<String?>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SeriesTableCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      creator: creator ?? this.creator,
      publishedVolumes: publishedVolumes ?? this.publishedVolumes,
      sourceKey: sourceKey ?? this.sourceKey,
      externalWorkId: externalWorkId ?? this.externalWorkId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (originalLanguage.present) {
      map['original_language'] = Variable<String>(originalLanguage.value);
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (publishedVolumes.present) {
      map['published_volumes'] = Variable<int>(publishedVolumes.value);
    }
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (externalWorkId.present) {
      map['external_work_id'] = Variable<String>(externalWorkId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeriesTableCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('creator: $creator, ')
          ..write('publishedVolumes: $publishedVolumes, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('externalWorkId: $externalWorkId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SeriesTitlesTable extends SeriesTitles
    with TableInfo<$SeriesTitlesTable, SeriesTitleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeriesTitlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<String> seriesId = GeneratedColumn<String>(
    'series_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [seriesId, languageCode, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'series_titles';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeriesTitleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seriesId, languageCode};
  @override
  SeriesTitleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeriesTitleRow(
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $SeriesTitlesTable createAlias(String alias) {
    return $SeriesTitlesTable(attachedDatabase, alias);
  }
}

class SeriesTitleRow extends DataClass implements Insertable<SeriesTitleRow> {
  final String seriesId;
  final String languageCode;
  final String title;
  const SeriesTitleRow({
    required this.seriesId,
    required this.languageCode,
    required this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['series_id'] = Variable<String>(seriesId);
    map['language_code'] = Variable<String>(languageCode);
    map['title'] = Variable<String>(title);
    return map;
  }

  SeriesTitlesCompanion toCompanion(bool nullToAbsent) {
    return SeriesTitlesCompanion(
      seriesId: Value(seriesId),
      languageCode: Value(languageCode),
      title: Value(title),
    );
  }

  factory SeriesTitleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeriesTitleRow(
      seriesId: serializer.fromJson<String>(json['seriesId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seriesId': serializer.toJson<String>(seriesId),
      'languageCode': serializer.toJson<String>(languageCode),
      'title': serializer.toJson<String>(title),
    };
  }

  SeriesTitleRow copyWith({
    String? seriesId,
    String? languageCode,
    String? title,
  }) => SeriesTitleRow(
    seriesId: seriesId ?? this.seriesId,
    languageCode: languageCode ?? this.languageCode,
    title: title ?? this.title,
  );
  SeriesTitleRow copyWithCompanion(SeriesTitlesCompanion data) {
    return SeriesTitleRow(
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeriesTitleRow(')
          ..write('seriesId: $seriesId, ')
          ..write('languageCode: $languageCode, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(seriesId, languageCode, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeriesTitleRow &&
          other.seriesId == this.seriesId &&
          other.languageCode == this.languageCode &&
          other.title == this.title);
}

class SeriesTitlesCompanion extends UpdateCompanion<SeriesTitleRow> {
  final Value<String> seriesId;
  final Value<String> languageCode;
  final Value<String> title;
  final Value<int> rowid;
  const SeriesTitlesCompanion({
    this.seriesId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.title = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeriesTitlesCompanion.insert({
    required String seriesId,
    required String languageCode,
    required String title,
    this.rowid = const Value.absent(),
  }) : seriesId = Value(seriesId),
       languageCode = Value(languageCode),
       title = Value(title);
  static Insertable<SeriesTitleRow> custom({
    Expression<String>? seriesId,
    Expression<String>? languageCode,
    Expression<String>? title,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (seriesId != null) 'series_id': seriesId,
      if (languageCode != null) 'language_code': languageCode,
      if (title != null) 'title': title,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeriesTitlesCompanion copyWith({
    Value<String>? seriesId,
    Value<String>? languageCode,
    Value<String>? title,
    Value<int>? rowid,
  }) {
    return SeriesTitlesCompanion(
      seriesId: seriesId ?? this.seriesId,
      languageCode: languageCode ?? this.languageCode,
      title: title ?? this.title,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seriesId.present) {
      map['series_id'] = Variable<String>(seriesId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeriesTitlesCompanion(')
          ..write('seriesId: $seriesId, ')
          ..write('languageCode: $languageCode, ')
          ..write('title: $title, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, ItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<String> seriesId = GeneratedColumn<String>(
    'series_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id)',
    ),
  );
  static const VerificationMeta _volumeNumberMeta = const VerificationMeta(
    'volumeNumber',
  );
  @override
  late final GeneratedColumn<int> volumeNumber = GeneratedColumn<int>(
    'volume_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalLanguageMeta = const VerificationMeta(
    'originalLanguage',
  );
  @override
  late final GeneratedColumn<String> originalLanguage = GeneratedColumn<String>(
    'original_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatorMeta = const VerificationMeta(
    'creator',
  );
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
    'creator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spineColorValueMeta = const VerificationMeta(
    'spineColorValue',
  );
  @override
  late final GeneratedColumn<int> spineColorValue = GeneratedColumn<int>(
    'spine_color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupKeyMeta = const VerificationMeta(
    'groupKey',
  );
  @override
  late final GeneratedColumn<String> groupKey = GeneratedColumn<String>(
    'group_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceKeyMeta = const VerificationMeta(
    'sourceKey',
  );
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
    'source_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalWorkIdMeta = const VerificationMeta(
    'externalWorkId',
  );
  @override
  late final GeneratedColumn<String> externalWorkId = GeneratedColumn<String>(
    'external_work_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardKindMeta = const VerificationMeta(
    'cardKind',
  );
  @override
  late final GeneratedColumn<String> cardKind = GeneratedColumn<String>(
    'card_kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressStatusMeta = const VerificationMeta(
    'progressStatus',
  );
  @override
  late final GeneratedColumn<String> progressStatus = GeneratedColumn<String>(
    'progress_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressChapterMeta = const VerificationMeta(
    'progressChapter',
  );
  @override
  late final GeneratedColumn<String> progressChapter = GeneratedColumn<String>(
    'progress_chapter',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressPageMeta = const VerificationMeta(
    'progressPage',
  );
  @override
  late final GeneratedColumn<int> progressPage = GeneratedColumn<int>(
    'progress_page',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _marketValueCentsMeta = const VerificationMeta(
    'marketValueCents',
  );
  @override
  late final GeneratedColumn<int> marketValueCents = GeneratedColumn<int>(
    'market_value_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _marketValueCurrencyMeta =
      const VerificationMeta('marketValueCurrency');
  @override
  late final GeneratedColumn<String> marketValueCurrency =
      GeneratedColumn<String>(
        'market_value_currency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _marketValuedAtMeta = const VerificationMeta(
    'marketValuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> marketValuedAt =
      GeneratedColumn<DateTime>(
        'market_valued_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _preorderDueOnMeta = const VerificationMeta(
    'preorderDueOn',
  );
  @override
  late final GeneratedColumn<DateTime> preorderDueOn =
      GeneratedColumn<DateTime>(
        'preorder_due_on',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _preorderDepositCentsMeta =
      const VerificationMeta('preorderDepositCents');
  @override
  late final GeneratedColumn<int> preorderDepositCents = GeneratedColumn<int>(
    'preorder_deposit_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    seriesId,
    volumeNumber,
    originalLanguage,
    creator,
    year,
    publisher,
    imagePath,
    spineColorValue,
    rating,
    groupKey,
    sourceKey,
    externalWorkId,
    cardKind,
    progressStatus,
    progressChapter,
    progressPage,
    marketValueCents,
    marketValueCurrency,
    marketValuedAt,
    preorderDueOn,
    preorderDepositCents,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    }
    if (data.containsKey('volume_number')) {
      context.handle(
        _volumeNumberMeta,
        volumeNumber.isAcceptableOrUnknown(
          data['volume_number']!,
          _volumeNumberMeta,
        ),
      );
    }
    if (data.containsKey('original_language')) {
      context.handle(
        _originalLanguageMeta,
        originalLanguage.isAcceptableOrUnknown(
          data['original_language']!,
          _originalLanguageMeta,
        ),
      );
    }
    if (data.containsKey('creator')) {
      context.handle(
        _creatorMeta,
        creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('spine_color_value')) {
      context.handle(
        _spineColorValueMeta,
        spineColorValue.isAcceptableOrUnknown(
          data['spine_color_value']!,
          _spineColorValueMeta,
        ),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('group_key')) {
      context.handle(
        _groupKeyMeta,
        groupKey.isAcceptableOrUnknown(data['group_key']!, _groupKeyMeta),
      );
    }
    if (data.containsKey('source_key')) {
      context.handle(
        _sourceKeyMeta,
        sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta),
      );
    }
    if (data.containsKey('external_work_id')) {
      context.handle(
        _externalWorkIdMeta,
        externalWorkId.isAcceptableOrUnknown(
          data['external_work_id']!,
          _externalWorkIdMeta,
        ),
      );
    }
    if (data.containsKey('card_kind')) {
      context.handle(
        _cardKindMeta,
        cardKind.isAcceptableOrUnknown(data['card_kind']!, _cardKindMeta),
      );
    }
    if (data.containsKey('progress_status')) {
      context.handle(
        _progressStatusMeta,
        progressStatus.isAcceptableOrUnknown(
          data['progress_status']!,
          _progressStatusMeta,
        ),
      );
    }
    if (data.containsKey('progress_chapter')) {
      context.handle(
        _progressChapterMeta,
        progressChapter.isAcceptableOrUnknown(
          data['progress_chapter']!,
          _progressChapterMeta,
        ),
      );
    }
    if (data.containsKey('progress_page')) {
      context.handle(
        _progressPageMeta,
        progressPage.isAcceptableOrUnknown(
          data['progress_page']!,
          _progressPageMeta,
        ),
      );
    }
    if (data.containsKey('market_value_cents')) {
      context.handle(
        _marketValueCentsMeta,
        marketValueCents.isAcceptableOrUnknown(
          data['market_value_cents']!,
          _marketValueCentsMeta,
        ),
      );
    }
    if (data.containsKey('market_value_currency')) {
      context.handle(
        _marketValueCurrencyMeta,
        marketValueCurrency.isAcceptableOrUnknown(
          data['market_value_currency']!,
          _marketValueCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('market_valued_at')) {
      context.handle(
        _marketValuedAtMeta,
        marketValuedAt.isAcceptableOrUnknown(
          data['market_valued_at']!,
          _marketValuedAtMeta,
        ),
      );
    }
    if (data.containsKey('preorder_due_on')) {
      context.handle(
        _preorderDueOnMeta,
        preorderDueOn.isAcceptableOrUnknown(
          data['preorder_due_on']!,
          _preorderDueOnMeta,
        ),
      );
    }
    if (data.containsKey('preorder_deposit_cents')) {
      context.handle(
        _preorderDepositCentsMeta,
        preorderDepositCents.isAcceptableOrUnknown(
          data['preorder_deposit_cents']!,
          _preorderDepositCentsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_id'],
      ),
      volumeNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume_number'],
      ),
      originalLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_language'],
      ),
      creator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      spineColorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spine_color_value'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      groupKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_key'],
      ),
      sourceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_key'],
      ),
      externalWorkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_work_id'],
      ),
      cardKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_kind'],
      ),
      progressStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progress_status'],
      ),
      progressChapter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progress_chapter'],
      ),
      progressPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_page'],
      ),
      marketValueCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}market_value_cents'],
      ),
      marketValueCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}market_value_currency'],
      ),
      marketValuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}market_valued_at'],
      ),
      preorderDueOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}preorder_due_on'],
      ),
      preorderDepositCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preorder_deposit_cents'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class ItemRow extends DataClass implements Insertable<ItemRow> {
  final String id;
  final String categoryId;
  final String? seriesId;
  final int? volumeNumber;
  final String? originalLanguage;
  final String? creator;
  final int? year;
  final String? publisher;
  final String? imagePath;
  final int? spineColorValue;
  final int? rating;
  final String? groupKey;
  final String? sourceKey;
  final String? externalWorkId;
  final String? cardKind;
  final String? progressStatus;
  final String? progressChapter;
  final int? progressPage;
  final int? marketValueCents;
  final String? marketValueCurrency;
  final DateTime? marketValuedAt;
  final DateTime? preorderDueOn;
  final int? preorderDepositCents;
  final DateTime createdAt;
  const ItemRow({
    required this.id,
    required this.categoryId,
    this.seriesId,
    this.volumeNumber,
    this.originalLanguage,
    this.creator,
    this.year,
    this.publisher,
    this.imagePath,
    this.spineColorValue,
    this.rating,
    this.groupKey,
    this.sourceKey,
    this.externalWorkId,
    this.cardKind,
    this.progressStatus,
    this.progressChapter,
    this.progressPage,
    this.marketValueCents,
    this.marketValueCurrency,
    this.marketValuedAt,
    this.preorderDueOn,
    this.preorderDepositCents,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || seriesId != null) {
      map['series_id'] = Variable<String>(seriesId);
    }
    if (!nullToAbsent || volumeNumber != null) {
      map['volume_number'] = Variable<int>(volumeNumber);
    }
    if (!nullToAbsent || originalLanguage != null) {
      map['original_language'] = Variable<String>(originalLanguage);
    }
    if (!nullToAbsent || creator != null) {
      map['creator'] = Variable<String>(creator);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || spineColorValue != null) {
      map['spine_color_value'] = Variable<int>(spineColorValue);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || groupKey != null) {
      map['group_key'] = Variable<String>(groupKey);
    }
    if (!nullToAbsent || sourceKey != null) {
      map['source_key'] = Variable<String>(sourceKey);
    }
    if (!nullToAbsent || externalWorkId != null) {
      map['external_work_id'] = Variable<String>(externalWorkId);
    }
    if (!nullToAbsent || cardKind != null) {
      map['card_kind'] = Variable<String>(cardKind);
    }
    if (!nullToAbsent || progressStatus != null) {
      map['progress_status'] = Variable<String>(progressStatus);
    }
    if (!nullToAbsent || progressChapter != null) {
      map['progress_chapter'] = Variable<String>(progressChapter);
    }
    if (!nullToAbsent || progressPage != null) {
      map['progress_page'] = Variable<int>(progressPage);
    }
    if (!nullToAbsent || marketValueCents != null) {
      map['market_value_cents'] = Variable<int>(marketValueCents);
    }
    if (!nullToAbsent || marketValueCurrency != null) {
      map['market_value_currency'] = Variable<String>(marketValueCurrency);
    }
    if (!nullToAbsent || marketValuedAt != null) {
      map['market_valued_at'] = Variable<DateTime>(marketValuedAt);
    }
    if (!nullToAbsent || preorderDueOn != null) {
      map['preorder_due_on'] = Variable<DateTime>(preorderDueOn);
    }
    if (!nullToAbsent || preorderDepositCents != null) {
      map['preorder_deposit_cents'] = Variable<int>(preorderDepositCents);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      seriesId: seriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesId),
      volumeNumber: volumeNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(volumeNumber),
      originalLanguage: originalLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLanguage),
      creator: creator == null && nullToAbsent
          ? const Value.absent()
          : Value(creator),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      spineColorValue: spineColorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(spineColorValue),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      groupKey: groupKey == null && nullToAbsent
          ? const Value.absent()
          : Value(groupKey),
      sourceKey: sourceKey == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceKey),
      externalWorkId: externalWorkId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalWorkId),
      cardKind: cardKind == null && nullToAbsent
          ? const Value.absent()
          : Value(cardKind),
      progressStatus: progressStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(progressStatus),
      progressChapter: progressChapter == null && nullToAbsent
          ? const Value.absent()
          : Value(progressChapter),
      progressPage: progressPage == null && nullToAbsent
          ? const Value.absent()
          : Value(progressPage),
      marketValueCents: marketValueCents == null && nullToAbsent
          ? const Value.absent()
          : Value(marketValueCents),
      marketValueCurrency: marketValueCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(marketValueCurrency),
      marketValuedAt: marketValuedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(marketValuedAt),
      preorderDueOn: preorderDueOn == null && nullToAbsent
          ? const Value.absent()
          : Value(preorderDueOn),
      preorderDepositCents: preorderDepositCents == null && nullToAbsent
          ? const Value.absent()
          : Value(preorderDepositCents),
      createdAt: Value(createdAt),
    );
  }

  factory ItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemRow(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      seriesId: serializer.fromJson<String?>(json['seriesId']),
      volumeNumber: serializer.fromJson<int?>(json['volumeNumber']),
      originalLanguage: serializer.fromJson<String?>(json['originalLanguage']),
      creator: serializer.fromJson<String?>(json['creator']),
      year: serializer.fromJson<int?>(json['year']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      spineColorValue: serializer.fromJson<int?>(json['spineColorValue']),
      rating: serializer.fromJson<int?>(json['rating']),
      groupKey: serializer.fromJson<String?>(json['groupKey']),
      sourceKey: serializer.fromJson<String?>(json['sourceKey']),
      externalWorkId: serializer.fromJson<String?>(json['externalWorkId']),
      cardKind: serializer.fromJson<String?>(json['cardKind']),
      progressStatus: serializer.fromJson<String?>(json['progressStatus']),
      progressChapter: serializer.fromJson<String?>(json['progressChapter']),
      progressPage: serializer.fromJson<int?>(json['progressPage']),
      marketValueCents: serializer.fromJson<int?>(json['marketValueCents']),
      marketValueCurrency: serializer.fromJson<String?>(
        json['marketValueCurrency'],
      ),
      marketValuedAt: serializer.fromJson<DateTime?>(json['marketValuedAt']),
      preorderDueOn: serializer.fromJson<DateTime?>(json['preorderDueOn']),
      preorderDepositCents: serializer.fromJson<int?>(
        json['preorderDepositCents'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'seriesId': serializer.toJson<String?>(seriesId),
      'volumeNumber': serializer.toJson<int?>(volumeNumber),
      'originalLanguage': serializer.toJson<String?>(originalLanguage),
      'creator': serializer.toJson<String?>(creator),
      'year': serializer.toJson<int?>(year),
      'publisher': serializer.toJson<String?>(publisher),
      'imagePath': serializer.toJson<String?>(imagePath),
      'spineColorValue': serializer.toJson<int?>(spineColorValue),
      'rating': serializer.toJson<int?>(rating),
      'groupKey': serializer.toJson<String?>(groupKey),
      'sourceKey': serializer.toJson<String?>(sourceKey),
      'externalWorkId': serializer.toJson<String?>(externalWorkId),
      'cardKind': serializer.toJson<String?>(cardKind),
      'progressStatus': serializer.toJson<String?>(progressStatus),
      'progressChapter': serializer.toJson<String?>(progressChapter),
      'progressPage': serializer.toJson<int?>(progressPage),
      'marketValueCents': serializer.toJson<int?>(marketValueCents),
      'marketValueCurrency': serializer.toJson<String?>(marketValueCurrency),
      'marketValuedAt': serializer.toJson<DateTime?>(marketValuedAt),
      'preorderDueOn': serializer.toJson<DateTime?>(preorderDueOn),
      'preorderDepositCents': serializer.toJson<int?>(preorderDepositCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ItemRow copyWith({
    String? id,
    String? categoryId,
    Value<String?> seriesId = const Value.absent(),
    Value<int?> volumeNumber = const Value.absent(),
    Value<String?> originalLanguage = const Value.absent(),
    Value<String?> creator = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<int?> spineColorValue = const Value.absent(),
    Value<int?> rating = const Value.absent(),
    Value<String?> groupKey = const Value.absent(),
    Value<String?> sourceKey = const Value.absent(),
    Value<String?> externalWorkId = const Value.absent(),
    Value<String?> cardKind = const Value.absent(),
    Value<String?> progressStatus = const Value.absent(),
    Value<String?> progressChapter = const Value.absent(),
    Value<int?> progressPage = const Value.absent(),
    Value<int?> marketValueCents = const Value.absent(),
    Value<String?> marketValueCurrency = const Value.absent(),
    Value<DateTime?> marketValuedAt = const Value.absent(),
    Value<DateTime?> preorderDueOn = const Value.absent(),
    Value<int?> preorderDepositCents = const Value.absent(),
    DateTime? createdAt,
  }) => ItemRow(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    seriesId: seriesId.present ? seriesId.value : this.seriesId,
    volumeNumber: volumeNumber.present ? volumeNumber.value : this.volumeNumber,
    originalLanguage: originalLanguage.present
        ? originalLanguage.value
        : this.originalLanguage,
    creator: creator.present ? creator.value : this.creator,
    year: year.present ? year.value : this.year,
    publisher: publisher.present ? publisher.value : this.publisher,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    spineColorValue: spineColorValue.present
        ? spineColorValue.value
        : this.spineColorValue,
    rating: rating.present ? rating.value : this.rating,
    groupKey: groupKey.present ? groupKey.value : this.groupKey,
    sourceKey: sourceKey.present ? sourceKey.value : this.sourceKey,
    externalWorkId: externalWorkId.present
        ? externalWorkId.value
        : this.externalWorkId,
    cardKind: cardKind.present ? cardKind.value : this.cardKind,
    progressStatus: progressStatus.present
        ? progressStatus.value
        : this.progressStatus,
    progressChapter: progressChapter.present
        ? progressChapter.value
        : this.progressChapter,
    progressPage: progressPage.present ? progressPage.value : this.progressPage,
    marketValueCents: marketValueCents.present
        ? marketValueCents.value
        : this.marketValueCents,
    marketValueCurrency: marketValueCurrency.present
        ? marketValueCurrency.value
        : this.marketValueCurrency,
    marketValuedAt: marketValuedAt.present
        ? marketValuedAt.value
        : this.marketValuedAt,
    preorderDueOn: preorderDueOn.present
        ? preorderDueOn.value
        : this.preorderDueOn,
    preorderDepositCents: preorderDepositCents.present
        ? preorderDepositCents.value
        : this.preorderDepositCents,
    createdAt: createdAt ?? this.createdAt,
  );
  ItemRow copyWithCompanion(ItemsCompanion data) {
    return ItemRow(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      volumeNumber: data.volumeNumber.present
          ? data.volumeNumber.value
          : this.volumeNumber,
      originalLanguage: data.originalLanguage.present
          ? data.originalLanguage.value
          : this.originalLanguage,
      creator: data.creator.present ? data.creator.value : this.creator,
      year: data.year.present ? data.year.value : this.year,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      spineColorValue: data.spineColorValue.present
          ? data.spineColorValue.value
          : this.spineColorValue,
      rating: data.rating.present ? data.rating.value : this.rating,
      groupKey: data.groupKey.present ? data.groupKey.value : this.groupKey,
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      externalWorkId: data.externalWorkId.present
          ? data.externalWorkId.value
          : this.externalWorkId,
      cardKind: data.cardKind.present ? data.cardKind.value : this.cardKind,
      progressStatus: data.progressStatus.present
          ? data.progressStatus.value
          : this.progressStatus,
      progressChapter: data.progressChapter.present
          ? data.progressChapter.value
          : this.progressChapter,
      progressPage: data.progressPage.present
          ? data.progressPage.value
          : this.progressPage,
      marketValueCents: data.marketValueCents.present
          ? data.marketValueCents.value
          : this.marketValueCents,
      marketValueCurrency: data.marketValueCurrency.present
          ? data.marketValueCurrency.value
          : this.marketValueCurrency,
      marketValuedAt: data.marketValuedAt.present
          ? data.marketValuedAt.value
          : this.marketValuedAt,
      preorderDueOn: data.preorderDueOn.present
          ? data.preorderDueOn.value
          : this.preorderDueOn,
      preorderDepositCents: data.preorderDepositCents.present
          ? data.preorderDepositCents.value
          : this.preorderDepositCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemRow(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('seriesId: $seriesId, ')
          ..write('volumeNumber: $volumeNumber, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('creator: $creator, ')
          ..write('year: $year, ')
          ..write('publisher: $publisher, ')
          ..write('imagePath: $imagePath, ')
          ..write('spineColorValue: $spineColorValue, ')
          ..write('rating: $rating, ')
          ..write('groupKey: $groupKey, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('externalWorkId: $externalWorkId, ')
          ..write('cardKind: $cardKind, ')
          ..write('progressStatus: $progressStatus, ')
          ..write('progressChapter: $progressChapter, ')
          ..write('progressPage: $progressPage, ')
          ..write('marketValueCents: $marketValueCents, ')
          ..write('marketValueCurrency: $marketValueCurrency, ')
          ..write('marketValuedAt: $marketValuedAt, ')
          ..write('preorderDueOn: $preorderDueOn, ')
          ..write('preorderDepositCents: $preorderDepositCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    categoryId,
    seriesId,
    volumeNumber,
    originalLanguage,
    creator,
    year,
    publisher,
    imagePath,
    spineColorValue,
    rating,
    groupKey,
    sourceKey,
    externalWorkId,
    cardKind,
    progressStatus,
    progressChapter,
    progressPage,
    marketValueCents,
    marketValueCurrency,
    marketValuedAt,
    preorderDueOn,
    preorderDepositCents,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemRow &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.seriesId == this.seriesId &&
          other.volumeNumber == this.volumeNumber &&
          other.originalLanguage == this.originalLanguage &&
          other.creator == this.creator &&
          other.year == this.year &&
          other.publisher == this.publisher &&
          other.imagePath == this.imagePath &&
          other.spineColorValue == this.spineColorValue &&
          other.rating == this.rating &&
          other.groupKey == this.groupKey &&
          other.sourceKey == this.sourceKey &&
          other.externalWorkId == this.externalWorkId &&
          other.cardKind == this.cardKind &&
          other.progressStatus == this.progressStatus &&
          other.progressChapter == this.progressChapter &&
          other.progressPage == this.progressPage &&
          other.marketValueCents == this.marketValueCents &&
          other.marketValueCurrency == this.marketValueCurrency &&
          other.marketValuedAt == this.marketValuedAt &&
          other.preorderDueOn == this.preorderDueOn &&
          other.preorderDepositCents == this.preorderDepositCents &&
          other.createdAt == this.createdAt);
}

class ItemsCompanion extends UpdateCompanion<ItemRow> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String?> seriesId;
  final Value<int?> volumeNumber;
  final Value<String?> originalLanguage;
  final Value<String?> creator;
  final Value<int?> year;
  final Value<String?> publisher;
  final Value<String?> imagePath;
  final Value<int?> spineColorValue;
  final Value<int?> rating;
  final Value<String?> groupKey;
  final Value<String?> sourceKey;
  final Value<String?> externalWorkId;
  final Value<String?> cardKind;
  final Value<String?> progressStatus;
  final Value<String?> progressChapter;
  final Value<int?> progressPage;
  final Value<int?> marketValueCents;
  final Value<String?> marketValueCurrency;
  final Value<DateTime?> marketValuedAt;
  final Value<DateTime?> preorderDueOn;
  final Value<int?> preorderDepositCents;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.volumeNumber = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.creator = const Value.absent(),
    this.year = const Value.absent(),
    this.publisher = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.spineColorValue = const Value.absent(),
    this.rating = const Value.absent(),
    this.groupKey = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.externalWorkId = const Value.absent(),
    this.cardKind = const Value.absent(),
    this.progressStatus = const Value.absent(),
    this.progressChapter = const Value.absent(),
    this.progressPage = const Value.absent(),
    this.marketValueCents = const Value.absent(),
    this.marketValueCurrency = const Value.absent(),
    this.marketValuedAt = const Value.absent(),
    this.preorderDueOn = const Value.absent(),
    this.preorderDepositCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String categoryId,
    this.seriesId = const Value.absent(),
    this.volumeNumber = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.creator = const Value.absent(),
    this.year = const Value.absent(),
    this.publisher = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.spineColorValue = const Value.absent(),
    this.rating = const Value.absent(),
    this.groupKey = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.externalWorkId = const Value.absent(),
    this.cardKind = const Value.absent(),
    this.progressStatus = const Value.absent(),
    this.progressChapter = const Value.absent(),
    this.progressPage = const Value.absent(),
    this.marketValueCents = const Value.absent(),
    this.marketValueCurrency = const Value.absent(),
    this.marketValuedAt = const Value.absent(),
    this.preorderDueOn = const Value.absent(),
    this.preorderDepositCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryId = Value(categoryId);
  static Insertable<ItemRow> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? seriesId,
    Expression<int>? volumeNumber,
    Expression<String>? originalLanguage,
    Expression<String>? creator,
    Expression<int>? year,
    Expression<String>? publisher,
    Expression<String>? imagePath,
    Expression<int>? spineColorValue,
    Expression<int>? rating,
    Expression<String>? groupKey,
    Expression<String>? sourceKey,
    Expression<String>? externalWorkId,
    Expression<String>? cardKind,
    Expression<String>? progressStatus,
    Expression<String>? progressChapter,
    Expression<int>? progressPage,
    Expression<int>? marketValueCents,
    Expression<String>? marketValueCurrency,
    Expression<DateTime>? marketValuedAt,
    Expression<DateTime>? preorderDueOn,
    Expression<int>? preorderDepositCents,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (seriesId != null) 'series_id': seriesId,
      if (volumeNumber != null) 'volume_number': volumeNumber,
      if (originalLanguage != null) 'original_language': originalLanguage,
      if (creator != null) 'creator': creator,
      if (year != null) 'year': year,
      if (publisher != null) 'publisher': publisher,
      if (imagePath != null) 'image_path': imagePath,
      if (spineColorValue != null) 'spine_color_value': spineColorValue,
      if (rating != null) 'rating': rating,
      if (groupKey != null) 'group_key': groupKey,
      if (sourceKey != null) 'source_key': sourceKey,
      if (externalWorkId != null) 'external_work_id': externalWorkId,
      if (cardKind != null) 'card_kind': cardKind,
      if (progressStatus != null) 'progress_status': progressStatus,
      if (progressChapter != null) 'progress_chapter': progressChapter,
      if (progressPage != null) 'progress_page': progressPage,
      if (marketValueCents != null) 'market_value_cents': marketValueCents,
      if (marketValueCurrency != null)
        'market_value_currency': marketValueCurrency,
      if (marketValuedAt != null) 'market_valued_at': marketValuedAt,
      if (preorderDueOn != null) 'preorder_due_on': preorderDueOn,
      if (preorderDepositCents != null)
        'preorder_deposit_cents': preorderDepositCents,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<String?>? seriesId,
    Value<int?>? volumeNumber,
    Value<String?>? originalLanguage,
    Value<String?>? creator,
    Value<int?>? year,
    Value<String?>? publisher,
    Value<String?>? imagePath,
    Value<int?>? spineColorValue,
    Value<int?>? rating,
    Value<String?>? groupKey,
    Value<String?>? sourceKey,
    Value<String?>? externalWorkId,
    Value<String?>? cardKind,
    Value<String?>? progressStatus,
    Value<String?>? progressChapter,
    Value<int?>? progressPage,
    Value<int?>? marketValueCents,
    Value<String?>? marketValueCurrency,
    Value<DateTime?>? marketValuedAt,
    Value<DateTime?>? preorderDueOn,
    Value<int?>? preorderDepositCents,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      seriesId: seriesId ?? this.seriesId,
      volumeNumber: volumeNumber ?? this.volumeNumber,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      creator: creator ?? this.creator,
      year: year ?? this.year,
      publisher: publisher ?? this.publisher,
      imagePath: imagePath ?? this.imagePath,
      spineColorValue: spineColorValue ?? this.spineColorValue,
      rating: rating ?? this.rating,
      groupKey: groupKey ?? this.groupKey,
      sourceKey: sourceKey ?? this.sourceKey,
      externalWorkId: externalWorkId ?? this.externalWorkId,
      cardKind: cardKind ?? this.cardKind,
      progressStatus: progressStatus ?? this.progressStatus,
      progressChapter: progressChapter ?? this.progressChapter,
      progressPage: progressPage ?? this.progressPage,
      marketValueCents: marketValueCents ?? this.marketValueCents,
      marketValueCurrency: marketValueCurrency ?? this.marketValueCurrency,
      marketValuedAt: marketValuedAt ?? this.marketValuedAt,
      preorderDueOn: preorderDueOn ?? this.preorderDueOn,
      preorderDepositCents: preorderDepositCents ?? this.preorderDepositCents,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (seriesId.present) {
      map['series_id'] = Variable<String>(seriesId.value);
    }
    if (volumeNumber.present) {
      map['volume_number'] = Variable<int>(volumeNumber.value);
    }
    if (originalLanguage.present) {
      map['original_language'] = Variable<String>(originalLanguage.value);
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (spineColorValue.present) {
      map['spine_color_value'] = Variable<int>(spineColorValue.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (groupKey.present) {
      map['group_key'] = Variable<String>(groupKey.value);
    }
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (externalWorkId.present) {
      map['external_work_id'] = Variable<String>(externalWorkId.value);
    }
    if (cardKind.present) {
      map['card_kind'] = Variable<String>(cardKind.value);
    }
    if (progressStatus.present) {
      map['progress_status'] = Variable<String>(progressStatus.value);
    }
    if (progressChapter.present) {
      map['progress_chapter'] = Variable<String>(progressChapter.value);
    }
    if (progressPage.present) {
      map['progress_page'] = Variable<int>(progressPage.value);
    }
    if (marketValueCents.present) {
      map['market_value_cents'] = Variable<int>(marketValueCents.value);
    }
    if (marketValueCurrency.present) {
      map['market_value_currency'] = Variable<String>(
        marketValueCurrency.value,
      );
    }
    if (marketValuedAt.present) {
      map['market_valued_at'] = Variable<DateTime>(marketValuedAt.value);
    }
    if (preorderDueOn.present) {
      map['preorder_due_on'] = Variable<DateTime>(preorderDueOn.value);
    }
    if (preorderDepositCents.present) {
      map['preorder_deposit_cents'] = Variable<int>(preorderDepositCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('seriesId: $seriesId, ')
          ..write('volumeNumber: $volumeNumber, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('creator: $creator, ')
          ..write('year: $year, ')
          ..write('publisher: $publisher, ')
          ..write('imagePath: $imagePath, ')
          ..write('spineColorValue: $spineColorValue, ')
          ..write('rating: $rating, ')
          ..write('groupKey: $groupKey, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('externalWorkId: $externalWorkId, ')
          ..write('cardKind: $cardKind, ')
          ..write('progressStatus: $progressStatus, ')
          ..write('progressChapter: $progressChapter, ')
          ..write('progressPage: $progressPage, ')
          ..write('marketValueCents: $marketValueCents, ')
          ..write('marketValueCurrency: $marketValueCurrency, ')
          ..write('marketValuedAt: $marketValuedAt, ')
          ..write('preorderDueOn: $preorderDueOn, ')
          ..write('preorderDepositCents: $preorderDepositCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemTitlesTable extends ItemTitles
    with TableInfo<$ItemTitlesTable, ItemTitleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemTitlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, languageCode, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_titles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemTitleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, languageCode};
  @override
  ItemTitleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemTitleRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $ItemTitlesTable createAlias(String alias) {
    return $ItemTitlesTable(attachedDatabase, alias);
  }
}

class ItemTitleRow extends DataClass implements Insertable<ItemTitleRow> {
  final String itemId;
  final String languageCode;
  final String title;
  const ItemTitleRow({
    required this.itemId,
    required this.languageCode,
    required this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['language_code'] = Variable<String>(languageCode);
    map['title'] = Variable<String>(title);
    return map;
  }

  ItemTitlesCompanion toCompanion(bool nullToAbsent) {
    return ItemTitlesCompanion(
      itemId: Value(itemId),
      languageCode: Value(languageCode),
      title: Value(title),
    );
  }

  factory ItemTitleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemTitleRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'languageCode': serializer.toJson<String>(languageCode),
      'title': serializer.toJson<String>(title),
    };
  }

  ItemTitleRow copyWith({
    String? itemId,
    String? languageCode,
    String? title,
  }) => ItemTitleRow(
    itemId: itemId ?? this.itemId,
    languageCode: languageCode ?? this.languageCode,
    title: title ?? this.title,
  );
  ItemTitleRow copyWithCompanion(ItemTitlesCompanion data) {
    return ItemTitleRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemTitleRow(')
          ..write('itemId: $itemId, ')
          ..write('languageCode: $languageCode, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, languageCode, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemTitleRow &&
          other.itemId == this.itemId &&
          other.languageCode == this.languageCode &&
          other.title == this.title);
}

class ItemTitlesCompanion extends UpdateCompanion<ItemTitleRow> {
  final Value<String> itemId;
  final Value<String> languageCode;
  final Value<String> title;
  final Value<int> rowid;
  const ItemTitlesCompanion({
    this.itemId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.title = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemTitlesCompanion.insert({
    required String itemId,
    required String languageCode,
    required String title,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       languageCode = Value(languageCode),
       title = Value(title);
  static Insertable<ItemTitleRow> custom({
    Expression<String>? itemId,
    Expression<String>? languageCode,
    Expression<String>? title,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (languageCode != null) 'language_code': languageCode,
      if (title != null) 'title': title,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemTitlesCompanion copyWith({
    Value<String>? itemId,
    Value<String>? languageCode,
    Value<String>? title,
    Value<int>? rowid,
  }) {
    return ItemTitlesCompanion(
      itemId: itemId ?? this.itemId,
      languageCode: languageCode ?? this.languageCode,
      title: title ?? this.title,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemTitlesCompanion(')
          ..write('itemId: $itemId, ')
          ..write('languageCode: $languageCode, ')
          ..write('title: $title, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CopiesTable extends Copies with TableInfo<$CopiesTable, CopyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CopiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _editionMeta = const VerificationMeta(
    'edition',
  );
  @override
  late final GeneratedColumn<String> edition = GeneratedColumn<String>(
    'edition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricePaidCentsMeta = const VerificationMeta(
    'pricePaidCents',
  );
  @override
  late final GeneratedColumn<int> pricePaidCents = GeneratedColumn<int>(
    'price_paid_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalEditionIdMeta = const VerificationMeta(
    'externalEditionId',
  );
  @override
  late final GeneratedColumn<String> externalEditionId =
      GeneratedColumn<String>(
        'external_edition_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _loanedToMeta = const VerificationMeta(
    'loanedTo',
  );
  @override
  late final GeneratedColumn<String> loanedTo = GeneratedColumn<String>(
    'loaned_to',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loanedSinceMeta = const VerificationMeta(
    'loanedSince',
  );
  @override
  late final GeneratedColumn<DateTime> loanedSince = GeneratedColumn<DateTime>(
    'loaned_since',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loanDueOnMeta = const VerificationMeta(
    'loanDueOn',
  );
  @override
  late final GeneratedColumn<DateTime> loanDueOn = GeneratedColumn<DateTime>(
    'loan_due_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loanRemindsAtDueMeta = const VerificationMeta(
    'loanRemindsAtDue',
  );
  @override
  late final GeneratedColumn<bool> loanRemindsAtDue = GeneratedColumn<bool>(
    'loan_reminds_at_due',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("loan_reminds_at_due" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _loanFollowsUpMeta = const VerificationMeta(
    'loanFollowsUp',
  );
  @override
  late final GeneratedColumn<bool> loanFollowsUp = GeneratedColumn<bool>(
    'loan_follows_up',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("loan_follows_up" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isOpenedMeta = const VerificationMeta(
    'isOpened',
  );
  @override
  late final GeneratedColumn<bool> isOpened = GeneratedColumn<bool>(
    'is_opened',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_opened" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _purchasedOnMeta = const VerificationMeta(
    'purchasedOn',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedOn = GeneratedColumn<DateTime>(
    'purchased_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseChannelMeta = const VerificationMeta(
    'purchaseChannel',
  );
  @override
  late final GeneratedColumn<String> purchaseChannel = GeneratedColumn<String>(
    'purchase_channel',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    edition,
    pricePaidCents,
    location,
    barcode,
    externalEditionId,
    loanedTo,
    loanedSince,
    loanDueOn,
    loanRemindsAtDue,
    loanFollowsUp,
    isOpened,
    purchasedOn,
    purchaseChannel,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'copies';
  @override
  VerificationContext validateIntegrity(
    Insertable<CopyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('edition')) {
      context.handle(
        _editionMeta,
        edition.isAcceptableOrUnknown(data['edition']!, _editionMeta),
      );
    }
    if (data.containsKey('price_paid_cents')) {
      context.handle(
        _pricePaidCentsMeta,
        pricePaidCents.isAcceptableOrUnknown(
          data['price_paid_cents']!,
          _pricePaidCentsMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('external_edition_id')) {
      context.handle(
        _externalEditionIdMeta,
        externalEditionId.isAcceptableOrUnknown(
          data['external_edition_id']!,
          _externalEditionIdMeta,
        ),
      );
    }
    if (data.containsKey('loaned_to')) {
      context.handle(
        _loanedToMeta,
        loanedTo.isAcceptableOrUnknown(data['loaned_to']!, _loanedToMeta),
      );
    }
    if (data.containsKey('loaned_since')) {
      context.handle(
        _loanedSinceMeta,
        loanedSince.isAcceptableOrUnknown(
          data['loaned_since']!,
          _loanedSinceMeta,
        ),
      );
    }
    if (data.containsKey('loan_due_on')) {
      context.handle(
        _loanDueOnMeta,
        loanDueOn.isAcceptableOrUnknown(data['loan_due_on']!, _loanDueOnMeta),
      );
    }
    if (data.containsKey('loan_reminds_at_due')) {
      context.handle(
        _loanRemindsAtDueMeta,
        loanRemindsAtDue.isAcceptableOrUnknown(
          data['loan_reminds_at_due']!,
          _loanRemindsAtDueMeta,
        ),
      );
    }
    if (data.containsKey('loan_follows_up')) {
      context.handle(
        _loanFollowsUpMeta,
        loanFollowsUp.isAcceptableOrUnknown(
          data['loan_follows_up']!,
          _loanFollowsUpMeta,
        ),
      );
    }
    if (data.containsKey('is_opened')) {
      context.handle(
        _isOpenedMeta,
        isOpened.isAcceptableOrUnknown(data['is_opened']!, _isOpenedMeta),
      );
    }
    if (data.containsKey('purchased_on')) {
      context.handle(
        _purchasedOnMeta,
        purchasedOn.isAcceptableOrUnknown(
          data['purchased_on']!,
          _purchasedOnMeta,
        ),
      );
    }
    if (data.containsKey('purchase_channel')) {
      context.handle(
        _purchaseChannelMeta,
        purchaseChannel.isAcceptableOrUnknown(
          data['purchase_channel']!,
          _purchaseChannelMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CopyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CopyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      edition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition'],
      ),
      pricePaidCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_paid_cents'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      externalEditionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_edition_id'],
      ),
      loanedTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loaned_to'],
      ),
      loanedSince: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}loaned_since'],
      ),
      loanDueOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}loan_due_on'],
      ),
      loanRemindsAtDue: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}loan_reminds_at_due'],
      )!,
      loanFollowsUp: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}loan_follows_up'],
      )!,
      isOpened: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_opened'],
      )!,
      purchasedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_on'],
      ),
      purchaseChannel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_channel'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CopiesTable createAlias(String alias) {
    return $CopiesTable(attachedDatabase, alias);
  }
}

class CopyRow extends DataClass implements Insertable<CopyRow> {
  final String id;
  final String itemId;
  final String? edition;
  final int? pricePaidCents;
  final String? location;
  final String? barcode;
  final String? externalEditionId;
  final String? loanedTo;
  final DateTime? loanedSince;
  final DateTime? loanDueOn;
  final bool loanRemindsAtDue;
  final bool loanFollowsUp;
  final bool isOpened;
  final DateTime? purchasedOn;
  final String? purchaseChannel;
  final DateTime createdAt;
  const CopyRow({
    required this.id,
    required this.itemId,
    this.edition,
    this.pricePaidCents,
    this.location,
    this.barcode,
    this.externalEditionId,
    this.loanedTo,
    this.loanedSince,
    this.loanDueOn,
    required this.loanRemindsAtDue,
    required this.loanFollowsUp,
    required this.isOpened,
    this.purchasedOn,
    this.purchaseChannel,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    if (!nullToAbsent || edition != null) {
      map['edition'] = Variable<String>(edition);
    }
    if (!nullToAbsent || pricePaidCents != null) {
      map['price_paid_cents'] = Variable<int>(pricePaidCents);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || externalEditionId != null) {
      map['external_edition_id'] = Variable<String>(externalEditionId);
    }
    if (!nullToAbsent || loanedTo != null) {
      map['loaned_to'] = Variable<String>(loanedTo);
    }
    if (!nullToAbsent || loanedSince != null) {
      map['loaned_since'] = Variable<DateTime>(loanedSince);
    }
    if (!nullToAbsent || loanDueOn != null) {
      map['loan_due_on'] = Variable<DateTime>(loanDueOn);
    }
    map['loan_reminds_at_due'] = Variable<bool>(loanRemindsAtDue);
    map['loan_follows_up'] = Variable<bool>(loanFollowsUp);
    map['is_opened'] = Variable<bool>(isOpened);
    if (!nullToAbsent || purchasedOn != null) {
      map['purchased_on'] = Variable<DateTime>(purchasedOn);
    }
    if (!nullToAbsent || purchaseChannel != null) {
      map['purchase_channel'] = Variable<String>(purchaseChannel);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CopiesCompanion toCompanion(bool nullToAbsent) {
    return CopiesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      edition: edition == null && nullToAbsent
          ? const Value.absent()
          : Value(edition),
      pricePaidCents: pricePaidCents == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePaidCents),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      externalEditionId: externalEditionId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEditionId),
      loanedTo: loanedTo == null && nullToAbsent
          ? const Value.absent()
          : Value(loanedTo),
      loanedSince: loanedSince == null && nullToAbsent
          ? const Value.absent()
          : Value(loanedSince),
      loanDueOn: loanDueOn == null && nullToAbsent
          ? const Value.absent()
          : Value(loanDueOn),
      loanRemindsAtDue: Value(loanRemindsAtDue),
      loanFollowsUp: Value(loanFollowsUp),
      isOpened: Value(isOpened),
      purchasedOn: purchasedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasedOn),
      purchaseChannel: purchaseChannel == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseChannel),
      createdAt: Value(createdAt),
    );
  }

  factory CopyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CopyRow(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      edition: serializer.fromJson<String?>(json['edition']),
      pricePaidCents: serializer.fromJson<int?>(json['pricePaidCents']),
      location: serializer.fromJson<String?>(json['location']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      externalEditionId: serializer.fromJson<String?>(
        json['externalEditionId'],
      ),
      loanedTo: serializer.fromJson<String?>(json['loanedTo']),
      loanedSince: serializer.fromJson<DateTime?>(json['loanedSince']),
      loanDueOn: serializer.fromJson<DateTime?>(json['loanDueOn']),
      loanRemindsAtDue: serializer.fromJson<bool>(json['loanRemindsAtDue']),
      loanFollowsUp: serializer.fromJson<bool>(json['loanFollowsUp']),
      isOpened: serializer.fromJson<bool>(json['isOpened']),
      purchasedOn: serializer.fromJson<DateTime?>(json['purchasedOn']),
      purchaseChannel: serializer.fromJson<String?>(json['purchaseChannel']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'edition': serializer.toJson<String?>(edition),
      'pricePaidCents': serializer.toJson<int?>(pricePaidCents),
      'location': serializer.toJson<String?>(location),
      'barcode': serializer.toJson<String?>(barcode),
      'externalEditionId': serializer.toJson<String?>(externalEditionId),
      'loanedTo': serializer.toJson<String?>(loanedTo),
      'loanedSince': serializer.toJson<DateTime?>(loanedSince),
      'loanDueOn': serializer.toJson<DateTime?>(loanDueOn),
      'loanRemindsAtDue': serializer.toJson<bool>(loanRemindsAtDue),
      'loanFollowsUp': serializer.toJson<bool>(loanFollowsUp),
      'isOpened': serializer.toJson<bool>(isOpened),
      'purchasedOn': serializer.toJson<DateTime?>(purchasedOn),
      'purchaseChannel': serializer.toJson<String?>(purchaseChannel),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CopyRow copyWith({
    String? id,
    String? itemId,
    Value<String?> edition = const Value.absent(),
    Value<int?> pricePaidCents = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> externalEditionId = const Value.absent(),
    Value<String?> loanedTo = const Value.absent(),
    Value<DateTime?> loanedSince = const Value.absent(),
    Value<DateTime?> loanDueOn = const Value.absent(),
    bool? loanRemindsAtDue,
    bool? loanFollowsUp,
    bool? isOpened,
    Value<DateTime?> purchasedOn = const Value.absent(),
    Value<String?> purchaseChannel = const Value.absent(),
    DateTime? createdAt,
  }) => CopyRow(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    edition: edition.present ? edition.value : this.edition,
    pricePaidCents: pricePaidCents.present
        ? pricePaidCents.value
        : this.pricePaidCents,
    location: location.present ? location.value : this.location,
    barcode: barcode.present ? barcode.value : this.barcode,
    externalEditionId: externalEditionId.present
        ? externalEditionId.value
        : this.externalEditionId,
    loanedTo: loanedTo.present ? loanedTo.value : this.loanedTo,
    loanedSince: loanedSince.present ? loanedSince.value : this.loanedSince,
    loanDueOn: loanDueOn.present ? loanDueOn.value : this.loanDueOn,
    loanRemindsAtDue: loanRemindsAtDue ?? this.loanRemindsAtDue,
    loanFollowsUp: loanFollowsUp ?? this.loanFollowsUp,
    isOpened: isOpened ?? this.isOpened,
    purchasedOn: purchasedOn.present ? purchasedOn.value : this.purchasedOn,
    purchaseChannel: purchaseChannel.present
        ? purchaseChannel.value
        : this.purchaseChannel,
    createdAt: createdAt ?? this.createdAt,
  );
  CopyRow copyWithCompanion(CopiesCompanion data) {
    return CopyRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      edition: data.edition.present ? data.edition.value : this.edition,
      pricePaidCents: data.pricePaidCents.present
          ? data.pricePaidCents.value
          : this.pricePaidCents,
      location: data.location.present ? data.location.value : this.location,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      externalEditionId: data.externalEditionId.present
          ? data.externalEditionId.value
          : this.externalEditionId,
      loanedTo: data.loanedTo.present ? data.loanedTo.value : this.loanedTo,
      loanedSince: data.loanedSince.present
          ? data.loanedSince.value
          : this.loanedSince,
      loanDueOn: data.loanDueOn.present ? data.loanDueOn.value : this.loanDueOn,
      loanRemindsAtDue: data.loanRemindsAtDue.present
          ? data.loanRemindsAtDue.value
          : this.loanRemindsAtDue,
      loanFollowsUp: data.loanFollowsUp.present
          ? data.loanFollowsUp.value
          : this.loanFollowsUp,
      isOpened: data.isOpened.present ? data.isOpened.value : this.isOpened,
      purchasedOn: data.purchasedOn.present
          ? data.purchasedOn.value
          : this.purchasedOn,
      purchaseChannel: data.purchaseChannel.present
          ? data.purchaseChannel.value
          : this.purchaseChannel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CopyRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('edition: $edition, ')
          ..write('pricePaidCents: $pricePaidCents, ')
          ..write('location: $location, ')
          ..write('barcode: $barcode, ')
          ..write('externalEditionId: $externalEditionId, ')
          ..write('loanedTo: $loanedTo, ')
          ..write('loanedSince: $loanedSince, ')
          ..write('loanDueOn: $loanDueOn, ')
          ..write('loanRemindsAtDue: $loanRemindsAtDue, ')
          ..write('loanFollowsUp: $loanFollowsUp, ')
          ..write('isOpened: $isOpened, ')
          ..write('purchasedOn: $purchasedOn, ')
          ..write('purchaseChannel: $purchaseChannel, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    edition,
    pricePaidCents,
    location,
    barcode,
    externalEditionId,
    loanedTo,
    loanedSince,
    loanDueOn,
    loanRemindsAtDue,
    loanFollowsUp,
    isOpened,
    purchasedOn,
    purchaseChannel,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CopyRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.edition == this.edition &&
          other.pricePaidCents == this.pricePaidCents &&
          other.location == this.location &&
          other.barcode == this.barcode &&
          other.externalEditionId == this.externalEditionId &&
          other.loanedTo == this.loanedTo &&
          other.loanedSince == this.loanedSince &&
          other.loanDueOn == this.loanDueOn &&
          other.loanRemindsAtDue == this.loanRemindsAtDue &&
          other.loanFollowsUp == this.loanFollowsUp &&
          other.isOpened == this.isOpened &&
          other.purchasedOn == this.purchasedOn &&
          other.purchaseChannel == this.purchaseChannel &&
          other.createdAt == this.createdAt);
}

class CopiesCompanion extends UpdateCompanion<CopyRow> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String?> edition;
  final Value<int?> pricePaidCents;
  final Value<String?> location;
  final Value<String?> barcode;
  final Value<String?> externalEditionId;
  final Value<String?> loanedTo;
  final Value<DateTime?> loanedSince;
  final Value<DateTime?> loanDueOn;
  final Value<bool> loanRemindsAtDue;
  final Value<bool> loanFollowsUp;
  final Value<bool> isOpened;
  final Value<DateTime?> purchasedOn;
  final Value<String?> purchaseChannel;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CopiesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.edition = const Value.absent(),
    this.pricePaidCents = const Value.absent(),
    this.location = const Value.absent(),
    this.barcode = const Value.absent(),
    this.externalEditionId = const Value.absent(),
    this.loanedTo = const Value.absent(),
    this.loanedSince = const Value.absent(),
    this.loanDueOn = const Value.absent(),
    this.loanRemindsAtDue = const Value.absent(),
    this.loanFollowsUp = const Value.absent(),
    this.isOpened = const Value.absent(),
    this.purchasedOn = const Value.absent(),
    this.purchaseChannel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CopiesCompanion.insert({
    required String id,
    required String itemId,
    this.edition = const Value.absent(),
    this.pricePaidCents = const Value.absent(),
    this.location = const Value.absent(),
    this.barcode = const Value.absent(),
    this.externalEditionId = const Value.absent(),
    this.loanedTo = const Value.absent(),
    this.loanedSince = const Value.absent(),
    this.loanDueOn = const Value.absent(),
    this.loanRemindsAtDue = const Value.absent(),
    this.loanFollowsUp = const Value.absent(),
    this.isOpened = const Value.absent(),
    this.purchasedOn = const Value.absent(),
    this.purchaseChannel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemId = Value(itemId);
  static Insertable<CopyRow> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? edition,
    Expression<int>? pricePaidCents,
    Expression<String>? location,
    Expression<String>? barcode,
    Expression<String>? externalEditionId,
    Expression<String>? loanedTo,
    Expression<DateTime>? loanedSince,
    Expression<DateTime>? loanDueOn,
    Expression<bool>? loanRemindsAtDue,
    Expression<bool>? loanFollowsUp,
    Expression<bool>? isOpened,
    Expression<DateTime>? purchasedOn,
    Expression<String>? purchaseChannel,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (edition != null) 'edition': edition,
      if (pricePaidCents != null) 'price_paid_cents': pricePaidCents,
      if (location != null) 'location': location,
      if (barcode != null) 'barcode': barcode,
      if (externalEditionId != null) 'external_edition_id': externalEditionId,
      if (loanedTo != null) 'loaned_to': loanedTo,
      if (loanedSince != null) 'loaned_since': loanedSince,
      if (loanDueOn != null) 'loan_due_on': loanDueOn,
      if (loanRemindsAtDue != null) 'loan_reminds_at_due': loanRemindsAtDue,
      if (loanFollowsUp != null) 'loan_follows_up': loanFollowsUp,
      if (isOpened != null) 'is_opened': isOpened,
      if (purchasedOn != null) 'purchased_on': purchasedOn,
      if (purchaseChannel != null) 'purchase_channel': purchaseChannel,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CopiesCompanion copyWith({
    Value<String>? id,
    Value<String>? itemId,
    Value<String?>? edition,
    Value<int?>? pricePaidCents,
    Value<String?>? location,
    Value<String?>? barcode,
    Value<String?>? externalEditionId,
    Value<String?>? loanedTo,
    Value<DateTime?>? loanedSince,
    Value<DateTime?>? loanDueOn,
    Value<bool>? loanRemindsAtDue,
    Value<bool>? loanFollowsUp,
    Value<bool>? isOpened,
    Value<DateTime?>? purchasedOn,
    Value<String?>? purchaseChannel,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CopiesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      edition: edition ?? this.edition,
      pricePaidCents: pricePaidCents ?? this.pricePaidCents,
      location: location ?? this.location,
      barcode: barcode ?? this.barcode,
      externalEditionId: externalEditionId ?? this.externalEditionId,
      loanedTo: loanedTo ?? this.loanedTo,
      loanedSince: loanedSince ?? this.loanedSince,
      loanDueOn: loanDueOn ?? this.loanDueOn,
      loanRemindsAtDue: loanRemindsAtDue ?? this.loanRemindsAtDue,
      loanFollowsUp: loanFollowsUp ?? this.loanFollowsUp,
      isOpened: isOpened ?? this.isOpened,
      purchasedOn: purchasedOn ?? this.purchasedOn,
      purchaseChannel: purchaseChannel ?? this.purchaseChannel,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (edition.present) {
      map['edition'] = Variable<String>(edition.value);
    }
    if (pricePaidCents.present) {
      map['price_paid_cents'] = Variable<int>(pricePaidCents.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (externalEditionId.present) {
      map['external_edition_id'] = Variable<String>(externalEditionId.value);
    }
    if (loanedTo.present) {
      map['loaned_to'] = Variable<String>(loanedTo.value);
    }
    if (loanedSince.present) {
      map['loaned_since'] = Variable<DateTime>(loanedSince.value);
    }
    if (loanDueOn.present) {
      map['loan_due_on'] = Variable<DateTime>(loanDueOn.value);
    }
    if (loanRemindsAtDue.present) {
      map['loan_reminds_at_due'] = Variable<bool>(loanRemindsAtDue.value);
    }
    if (loanFollowsUp.present) {
      map['loan_follows_up'] = Variable<bool>(loanFollowsUp.value);
    }
    if (isOpened.present) {
      map['is_opened'] = Variable<bool>(isOpened.value);
    }
    if (purchasedOn.present) {
      map['purchased_on'] = Variable<DateTime>(purchasedOn.value);
    }
    if (purchaseChannel.present) {
      map['purchase_channel'] = Variable<String>(purchaseChannel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CopiesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('edition: $edition, ')
          ..write('pricePaidCents: $pricePaidCents, ')
          ..write('location: $location, ')
          ..write('barcode: $barcode, ')
          ..write('externalEditionId: $externalEditionId, ')
          ..write('loanedTo: $loanedTo, ')
          ..write('loanedSince: $loanedSince, ')
          ..write('loanDueOn: $loanDueOn, ')
          ..write('loanRemindsAtDue: $loanRemindsAtDue, ')
          ..write('loanFollowsUp: $loanFollowsUp, ')
          ..write('isOpened: $isOpened, ')
          ..write('purchasedOn: $purchasedOn, ')
          ..write('purchaseChannel: $purchaseChannel, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CopyConditionsTable extends CopyConditions
    with TableInfo<$CopyConditionsTable, CopyConditionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CopyConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _copyIdMeta = const VerificationMeta('copyId');
  @override
  late final GeneratedColumn<String> copyId = GeneratedColumn<String>(
    'copy_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES copies (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _partMeta = const VerificationMeta('part');
  @override
  late final GeneratedColumn<String> part = GeneratedColumn<String>(
    'part',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [copyId, part, condition];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'copy_conditions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CopyConditionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('copy_id')) {
      context.handle(
        _copyIdMeta,
        copyId.isAcceptableOrUnknown(data['copy_id']!, _copyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_copyIdMeta);
    }
    if (data.containsKey('part')) {
      context.handle(
        _partMeta,
        part.isAcceptableOrUnknown(data['part']!, _partMeta),
      );
    } else if (isInserting) {
      context.missing(_partMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    } else if (isInserting) {
      context.missing(_conditionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {copyId, part};
  @override
  CopyConditionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CopyConditionRow(
      copyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copy_id'],
      )!,
      part: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
    );
  }

  @override
  $CopyConditionsTable createAlias(String alias) {
    return $CopyConditionsTable(attachedDatabase, alias);
  }
}

class CopyConditionRow extends DataClass
    implements Insertable<CopyConditionRow> {
  final String copyId;
  final String part;
  final String condition;
  const CopyConditionRow({
    required this.copyId,
    required this.part,
    required this.condition,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['copy_id'] = Variable<String>(copyId);
    map['part'] = Variable<String>(part);
    map['condition'] = Variable<String>(condition);
    return map;
  }

  CopyConditionsCompanion toCompanion(bool nullToAbsent) {
    return CopyConditionsCompanion(
      copyId: Value(copyId),
      part: Value(part),
      condition: Value(condition),
    );
  }

  factory CopyConditionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CopyConditionRow(
      copyId: serializer.fromJson<String>(json['copyId']),
      part: serializer.fromJson<String>(json['part']),
      condition: serializer.fromJson<String>(json['condition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'copyId': serializer.toJson<String>(copyId),
      'part': serializer.toJson<String>(part),
      'condition': serializer.toJson<String>(condition),
    };
  }

  CopyConditionRow copyWith({
    String? copyId,
    String? part,
    String? condition,
  }) => CopyConditionRow(
    copyId: copyId ?? this.copyId,
    part: part ?? this.part,
    condition: condition ?? this.condition,
  );
  CopyConditionRow copyWithCompanion(CopyConditionsCompanion data) {
    return CopyConditionRow(
      copyId: data.copyId.present ? data.copyId.value : this.copyId,
      part: data.part.present ? data.part.value : this.part,
      condition: data.condition.present ? data.condition.value : this.condition,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CopyConditionRow(')
          ..write('copyId: $copyId, ')
          ..write('part: $part, ')
          ..write('condition: $condition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(copyId, part, condition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CopyConditionRow &&
          other.copyId == this.copyId &&
          other.part == this.part &&
          other.condition == this.condition);
}

class CopyConditionsCompanion extends UpdateCompanion<CopyConditionRow> {
  final Value<String> copyId;
  final Value<String> part;
  final Value<String> condition;
  final Value<int> rowid;
  const CopyConditionsCompanion({
    this.copyId = const Value.absent(),
    this.part = const Value.absent(),
    this.condition = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CopyConditionsCompanion.insert({
    required String copyId,
    required String part,
    required String condition,
    this.rowid = const Value.absent(),
  }) : copyId = Value(copyId),
       part = Value(part),
       condition = Value(condition);
  static Insertable<CopyConditionRow> custom({
    Expression<String>? copyId,
    Expression<String>? part,
    Expression<String>? condition,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (copyId != null) 'copy_id': copyId,
      if (part != null) 'part': part,
      if (condition != null) 'condition': condition,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CopyConditionsCompanion copyWith({
    Value<String>? copyId,
    Value<String>? part,
    Value<String>? condition,
    Value<int>? rowid,
  }) {
    return CopyConditionsCompanion(
      copyId: copyId ?? this.copyId,
      part: part ?? this.part,
      condition: condition ?? this.condition,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (copyId.present) {
      map['copy_id'] = Variable<String>(copyId.value);
    }
    if (part.present) {
      map['part'] = Variable<String>(part.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CopyConditionsCompanion(')
          ..write('copyId: $copyId, ')
          ..write('part: $part, ')
          ..write('condition: $condition, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, PreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  PreferenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class PreferenceRow extends DataClass implements Insertable<PreferenceRow> {
  final String key;
  final String value;
  const PreferenceRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(key: Value(key), value: Value(value));
  }

  factory PreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferenceRow copyWith({String? key, String? value}) =>
      PreferenceRow(key: key ?? this.key, value: value ?? this.value);
  PreferenceRow copyWithCompanion(PreferencesCompanion data) {
    return PreferenceRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceRow &&
          other.key == this.key &&
          other.value == this.value);
}

class PreferencesCompanion extends UpdateCompanion<PreferenceRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const PreferencesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferencesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<PreferenceRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferencesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return PreferencesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeckCardsTable extends DeckCards
    with TableInfo<$DeckCardsTable, DeckCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalCardIdMeta = const VerificationMeta(
    'externalCardId',
  );
  @override
  late final GeneratedColumn<String> externalCardId = GeneratedColumn<String>(
    'external_card_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceKeyMeta = const VerificationMeta(
    'sourceKey',
  );
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
    'source_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceCurrencyMeta = const VerificationMeta(
    'priceCurrency',
  );
  @override
  late final GeneratedColumn<String> priceCurrency = GeneratedColumn<String>(
    'price_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricedAtMeta = const VerificationMeta(
    'pricedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pricedAt = GeneratedColumn<DateTime>(
    'priced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeLineMeta = const VerificationMeta(
    'typeLine',
  );
  @override
  late final GeneratedColumn<String> typeLine = GeneratedColumn<String>(
    'type_line',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorIdentityMeta = const VerificationMeta(
    'colorIdentity',
  );
  @override
  late final GeneratedColumn<String> colorIdentity = GeneratedColumn<String>(
    'color_identity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manaValueMeta = const VerificationMeta(
    'manaValue',
  );
  @override
  late final GeneratedColumn<double> manaValue = GeneratedColumn<double>(
    'mana_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCommanderMeta = const VerificationMeta(
    'isCommander',
  );
  @override
  late final GeneratedColumn<bool> isCommander = GeneratedColumn<bool>(
    'is_commander',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_commander" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSecondaryCommanderMeta =
      const VerificationMeta('isSecondaryCommander');
  @override
  late final GeneratedColumn<bool> isSecondaryCommander = GeneratedColumn<bool>(
    'is_secondary_commander',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_secondary_commander" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    name,
    externalCardId,
    quantity,
    imageUrl,
    sourceKey,
    priceCents,
    priceCurrency,
    pricedAt,
    typeLine,
    colorIdentity,
    manaValue,
    isCommander,
    isSecondaryCommander,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeckCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('external_card_id')) {
      context.handle(
        _externalCardIdMeta,
        externalCardId.isAcceptableOrUnknown(
          data['external_card_id']!,
          _externalCardIdMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('source_key')) {
      context.handle(
        _sourceKeyMeta,
        sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta),
      );
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    }
    if (data.containsKey('price_currency')) {
      context.handle(
        _priceCurrencyMeta,
        priceCurrency.isAcceptableOrUnknown(
          data['price_currency']!,
          _priceCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('priced_at')) {
      context.handle(
        _pricedAtMeta,
        pricedAt.isAcceptableOrUnknown(data['priced_at']!, _pricedAtMeta),
      );
    }
    if (data.containsKey('type_line')) {
      context.handle(
        _typeLineMeta,
        typeLine.isAcceptableOrUnknown(data['type_line']!, _typeLineMeta),
      );
    }
    if (data.containsKey('color_identity')) {
      context.handle(
        _colorIdentityMeta,
        colorIdentity.isAcceptableOrUnknown(
          data['color_identity']!,
          _colorIdentityMeta,
        ),
      );
    }
    if (data.containsKey('mana_value')) {
      context.handle(
        _manaValueMeta,
        manaValue.isAcceptableOrUnknown(data['mana_value']!, _manaValueMeta),
      );
    }
    if (data.containsKey('is_commander')) {
      context.handle(
        _isCommanderMeta,
        isCommander.isAcceptableOrUnknown(
          data['is_commander']!,
          _isCommanderMeta,
        ),
      );
    }
    if (data.containsKey('is_secondary_commander')) {
      context.handle(
        _isSecondaryCommanderMeta,
        isSecondaryCommander.isAcceptableOrUnknown(
          data['is_secondary_commander']!,
          _isSecondaryCommanderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeckCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckCardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      externalCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_card_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      sourceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_key'],
      ),
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      ),
      priceCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_currency'],
      ),
      pricedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}priced_at'],
      ),
      typeLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_line'],
      ),
      colorIdentity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_identity'],
      ),
      manaValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mana_value'],
      ),
      isCommander: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_commander'],
      )!,
      isSecondaryCommander: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_secondary_commander'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DeckCardsTable createAlias(String alias) {
    return $DeckCardsTable(attachedDatabase, alias);
  }
}

class DeckCardRow extends DataClass implements Insertable<DeckCardRow> {
  final String id;
  final String itemId;
  final String name;
  final String? externalCardId;
  final int quantity;
  final String? imageUrl;
  final String? sourceKey;
  final int? priceCents;
  final String? priceCurrency;
  final DateTime? pricedAt;
  final String? typeLine;
  final String? colorIdentity;
  final double? manaValue;
  final bool isCommander;
  final bool isSecondaryCommander;
  final DateTime createdAt;
  const DeckCardRow({
    required this.id,
    required this.itemId,
    required this.name,
    this.externalCardId,
    required this.quantity,
    this.imageUrl,
    this.sourceKey,
    this.priceCents,
    this.priceCurrency,
    this.pricedAt,
    this.typeLine,
    this.colorIdentity,
    this.manaValue,
    required this.isCommander,
    required this.isSecondaryCommander,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || externalCardId != null) {
      map['external_card_id'] = Variable<String>(externalCardId);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || sourceKey != null) {
      map['source_key'] = Variable<String>(sourceKey);
    }
    if (!nullToAbsent || priceCents != null) {
      map['price_cents'] = Variable<int>(priceCents);
    }
    if (!nullToAbsent || priceCurrency != null) {
      map['price_currency'] = Variable<String>(priceCurrency);
    }
    if (!nullToAbsent || pricedAt != null) {
      map['priced_at'] = Variable<DateTime>(pricedAt);
    }
    if (!nullToAbsent || typeLine != null) {
      map['type_line'] = Variable<String>(typeLine);
    }
    if (!nullToAbsent || colorIdentity != null) {
      map['color_identity'] = Variable<String>(colorIdentity);
    }
    if (!nullToAbsent || manaValue != null) {
      map['mana_value'] = Variable<double>(manaValue);
    }
    map['is_commander'] = Variable<bool>(isCommander);
    map['is_secondary_commander'] = Variable<bool>(isSecondaryCommander);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DeckCardsCompanion toCompanion(bool nullToAbsent) {
    return DeckCardsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      name: Value(name),
      externalCardId: externalCardId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalCardId),
      quantity: Value(quantity),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      sourceKey: sourceKey == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceKey),
      priceCents: priceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(priceCents),
      priceCurrency: priceCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(priceCurrency),
      pricedAt: pricedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pricedAt),
      typeLine: typeLine == null && nullToAbsent
          ? const Value.absent()
          : Value(typeLine),
      colorIdentity: colorIdentity == null && nullToAbsent
          ? const Value.absent()
          : Value(colorIdentity),
      manaValue: manaValue == null && nullToAbsent
          ? const Value.absent()
          : Value(manaValue),
      isCommander: Value(isCommander),
      isSecondaryCommander: Value(isSecondaryCommander),
      createdAt: Value(createdAt),
    );
  }

  factory DeckCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckCardRow(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      externalCardId: serializer.fromJson<String?>(json['externalCardId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      sourceKey: serializer.fromJson<String?>(json['sourceKey']),
      priceCents: serializer.fromJson<int?>(json['priceCents']),
      priceCurrency: serializer.fromJson<String?>(json['priceCurrency']),
      pricedAt: serializer.fromJson<DateTime?>(json['pricedAt']),
      typeLine: serializer.fromJson<String?>(json['typeLine']),
      colorIdentity: serializer.fromJson<String?>(json['colorIdentity']),
      manaValue: serializer.fromJson<double?>(json['manaValue']),
      isCommander: serializer.fromJson<bool>(json['isCommander']),
      isSecondaryCommander: serializer.fromJson<bool>(
        json['isSecondaryCommander'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'name': serializer.toJson<String>(name),
      'externalCardId': serializer.toJson<String?>(externalCardId),
      'quantity': serializer.toJson<int>(quantity),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'sourceKey': serializer.toJson<String?>(sourceKey),
      'priceCents': serializer.toJson<int?>(priceCents),
      'priceCurrency': serializer.toJson<String?>(priceCurrency),
      'pricedAt': serializer.toJson<DateTime?>(pricedAt),
      'typeLine': serializer.toJson<String?>(typeLine),
      'colorIdentity': serializer.toJson<String?>(colorIdentity),
      'manaValue': serializer.toJson<double?>(manaValue),
      'isCommander': serializer.toJson<bool>(isCommander),
      'isSecondaryCommander': serializer.toJson<bool>(isSecondaryCommander),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DeckCardRow copyWith({
    String? id,
    String? itemId,
    String? name,
    Value<String?> externalCardId = const Value.absent(),
    int? quantity,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> sourceKey = const Value.absent(),
    Value<int?> priceCents = const Value.absent(),
    Value<String?> priceCurrency = const Value.absent(),
    Value<DateTime?> pricedAt = const Value.absent(),
    Value<String?> typeLine = const Value.absent(),
    Value<String?> colorIdentity = const Value.absent(),
    Value<double?> manaValue = const Value.absent(),
    bool? isCommander,
    bool? isSecondaryCommander,
    DateTime? createdAt,
  }) => DeckCardRow(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    name: name ?? this.name,
    externalCardId: externalCardId.present
        ? externalCardId.value
        : this.externalCardId,
    quantity: quantity ?? this.quantity,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    sourceKey: sourceKey.present ? sourceKey.value : this.sourceKey,
    priceCents: priceCents.present ? priceCents.value : this.priceCents,
    priceCurrency: priceCurrency.present
        ? priceCurrency.value
        : this.priceCurrency,
    pricedAt: pricedAt.present ? pricedAt.value : this.pricedAt,
    typeLine: typeLine.present ? typeLine.value : this.typeLine,
    colorIdentity: colorIdentity.present
        ? colorIdentity.value
        : this.colorIdentity,
    manaValue: manaValue.present ? manaValue.value : this.manaValue,
    isCommander: isCommander ?? this.isCommander,
    isSecondaryCommander: isSecondaryCommander ?? this.isSecondaryCommander,
    createdAt: createdAt ?? this.createdAt,
  );
  DeckCardRow copyWithCompanion(DeckCardsCompanion data) {
    return DeckCardRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      externalCardId: data.externalCardId.present
          ? data.externalCardId.value
          : this.externalCardId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      priceCurrency: data.priceCurrency.present
          ? data.priceCurrency.value
          : this.priceCurrency,
      pricedAt: data.pricedAt.present ? data.pricedAt.value : this.pricedAt,
      typeLine: data.typeLine.present ? data.typeLine.value : this.typeLine,
      colorIdentity: data.colorIdentity.present
          ? data.colorIdentity.value
          : this.colorIdentity,
      manaValue: data.manaValue.present ? data.manaValue.value : this.manaValue,
      isCommander: data.isCommander.present
          ? data.isCommander.value
          : this.isCommander,
      isSecondaryCommander: data.isSecondaryCommander.present
          ? data.isSecondaryCommander.value
          : this.isSecondaryCommander,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeckCardRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('externalCardId: $externalCardId, ')
          ..write('quantity: $quantity, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('priceCents: $priceCents, ')
          ..write('priceCurrency: $priceCurrency, ')
          ..write('pricedAt: $pricedAt, ')
          ..write('typeLine: $typeLine, ')
          ..write('colorIdentity: $colorIdentity, ')
          ..write('manaValue: $manaValue, ')
          ..write('isCommander: $isCommander, ')
          ..write('isSecondaryCommander: $isSecondaryCommander, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    name,
    externalCardId,
    quantity,
    imageUrl,
    sourceKey,
    priceCents,
    priceCurrency,
    pricedAt,
    typeLine,
    colorIdentity,
    manaValue,
    isCommander,
    isSecondaryCommander,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckCardRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.externalCardId == this.externalCardId &&
          other.quantity == this.quantity &&
          other.imageUrl == this.imageUrl &&
          other.sourceKey == this.sourceKey &&
          other.priceCents == this.priceCents &&
          other.priceCurrency == this.priceCurrency &&
          other.pricedAt == this.pricedAt &&
          other.typeLine == this.typeLine &&
          other.colorIdentity == this.colorIdentity &&
          other.manaValue == this.manaValue &&
          other.isCommander == this.isCommander &&
          other.isSecondaryCommander == this.isSecondaryCommander &&
          other.createdAt == this.createdAt);
}

class DeckCardsCompanion extends UpdateCompanion<DeckCardRow> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String> name;
  final Value<String?> externalCardId;
  final Value<int> quantity;
  final Value<String?> imageUrl;
  final Value<String?> sourceKey;
  final Value<int?> priceCents;
  final Value<String?> priceCurrency;
  final Value<DateTime?> pricedAt;
  final Value<String?> typeLine;
  final Value<String?> colorIdentity;
  final Value<double?> manaValue;
  final Value<bool> isCommander;
  final Value<bool> isSecondaryCommander;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DeckCardsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.externalCardId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.priceCurrency = const Value.absent(),
    this.pricedAt = const Value.absent(),
    this.typeLine = const Value.absent(),
    this.colorIdentity = const Value.absent(),
    this.manaValue = const Value.absent(),
    this.isCommander = const Value.absent(),
    this.isSecondaryCommander = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeckCardsCompanion.insert({
    required String id,
    required String itemId,
    required String name,
    this.externalCardId = const Value.absent(),
    required int quantity,
    this.imageUrl = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.priceCurrency = const Value.absent(),
    this.pricedAt = const Value.absent(),
    this.typeLine = const Value.absent(),
    this.colorIdentity = const Value.absent(),
    this.manaValue = const Value.absent(),
    this.isCommander = const Value.absent(),
    this.isSecondaryCommander = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemId = Value(itemId),
       name = Value(name),
       quantity = Value(quantity);
  static Insertable<DeckCardRow> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? name,
    Expression<String>? externalCardId,
    Expression<int>? quantity,
    Expression<String>? imageUrl,
    Expression<String>? sourceKey,
    Expression<int>? priceCents,
    Expression<String>? priceCurrency,
    Expression<DateTime>? pricedAt,
    Expression<String>? typeLine,
    Expression<String>? colorIdentity,
    Expression<double>? manaValue,
    Expression<bool>? isCommander,
    Expression<bool>? isSecondaryCommander,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (externalCardId != null) 'external_card_id': externalCardId,
      if (quantity != null) 'quantity': quantity,
      if (imageUrl != null) 'image_url': imageUrl,
      if (sourceKey != null) 'source_key': sourceKey,
      if (priceCents != null) 'price_cents': priceCents,
      if (priceCurrency != null) 'price_currency': priceCurrency,
      if (pricedAt != null) 'priced_at': pricedAt,
      if (typeLine != null) 'type_line': typeLine,
      if (colorIdentity != null) 'color_identity': colorIdentity,
      if (manaValue != null) 'mana_value': manaValue,
      if (isCommander != null) 'is_commander': isCommander,
      if (isSecondaryCommander != null)
        'is_secondary_commander': isSecondaryCommander,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeckCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? itemId,
    Value<String>? name,
    Value<String?>? externalCardId,
    Value<int>? quantity,
    Value<String?>? imageUrl,
    Value<String?>? sourceKey,
    Value<int?>? priceCents,
    Value<String?>? priceCurrency,
    Value<DateTime?>? pricedAt,
    Value<String?>? typeLine,
    Value<String?>? colorIdentity,
    Value<double?>? manaValue,
    Value<bool>? isCommander,
    Value<bool>? isSecondaryCommander,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DeckCardsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      externalCardId: externalCardId ?? this.externalCardId,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      sourceKey: sourceKey ?? this.sourceKey,
      priceCents: priceCents ?? this.priceCents,
      priceCurrency: priceCurrency ?? this.priceCurrency,
      pricedAt: pricedAt ?? this.pricedAt,
      typeLine: typeLine ?? this.typeLine,
      colorIdentity: colorIdentity ?? this.colorIdentity,
      manaValue: manaValue ?? this.manaValue,
      isCommander: isCommander ?? this.isCommander,
      isSecondaryCommander: isSecondaryCommander ?? this.isSecondaryCommander,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (externalCardId.present) {
      map['external_card_id'] = Variable<String>(externalCardId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (priceCurrency.present) {
      map['price_currency'] = Variable<String>(priceCurrency.value);
    }
    if (pricedAt.present) {
      map['priced_at'] = Variable<DateTime>(pricedAt.value);
    }
    if (typeLine.present) {
      map['type_line'] = Variable<String>(typeLine.value);
    }
    if (colorIdentity.present) {
      map['color_identity'] = Variable<String>(colorIdentity.value);
    }
    if (manaValue.present) {
      map['mana_value'] = Variable<double>(manaValue.value);
    }
    if (isCommander.present) {
      map['is_commander'] = Variable<bool>(isCommander.value);
    }
    if (isSecondaryCommander.present) {
      map['is_secondary_commander'] = Variable<bool>(
        isSecondaryCommander.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckCardsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('externalCardId: $externalCardId, ')
          ..write('quantity: $quantity, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('priceCents: $priceCents, ')
          ..write('priceCurrency: $priceCurrency, ')
          ..write('pricedAt: $pricedAt, ')
          ..write('typeLine: $typeLine, ')
          ..write('colorIdentity: $colorIdentity, ')
          ..write('manaValue: $manaValue, ')
          ..write('isCommander: $isCommander, ')
          ..write('isSecondaryCommander: $isSecondaryCommander, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemDetailsTable extends ItemDetails
    with TableInfo<$ItemDetailsTable, ItemDetailsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, payload, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemDetailsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  ItemDetailsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemDetailsRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $ItemDetailsTable createAlias(String alias) {
    return $ItemDetailsTable(attachedDatabase, alias);
  }
}

class ItemDetailsRow extends DataClass implements Insertable<ItemDetailsRow> {
  final String itemId;
  final String payload;
  final DateTime fetchedAt;
  const ItemDetailsRow({
    required this.itemId,
    required this.payload,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['payload'] = Variable<String>(payload);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  ItemDetailsCompanion toCompanion(bool nullToAbsent) {
    return ItemDetailsCompanion(
      itemId: Value(itemId),
      payload: Value(payload),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory ItemDetailsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemDetailsRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      payload: serializer.fromJson<String>(json['payload']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'payload': serializer.toJson<String>(payload),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  ItemDetailsRow copyWith({
    String? itemId,
    String? payload,
    DateTime? fetchedAt,
  }) => ItemDetailsRow(
    itemId: itemId ?? this.itemId,
    payload: payload ?? this.payload,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  ItemDetailsRow copyWithCompanion(ItemDetailsCompanion data) {
    return ItemDetailsRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      payload: data.payload.present ? data.payload.value : this.payload,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemDetailsRow(')
          ..write('itemId: $itemId, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, payload, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemDetailsRow &&
          other.itemId == this.itemId &&
          other.payload == this.payload &&
          other.fetchedAt == this.fetchedAt);
}

class ItemDetailsCompanion extends UpdateCompanion<ItemDetailsRow> {
  final Value<String> itemId;
  final Value<String> payload;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const ItemDetailsCompanion({
    this.itemId = const Value.absent(),
    this.payload = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemDetailsCompanion.insert({
    required String itemId,
    required String payload,
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       payload = Value(payload);
  static Insertable<ItemDetailsRow> custom({
    Expression<String>? itemId,
    Expression<String>? payload,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (payload != null) 'payload': payload,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemDetailsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? payload,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return ItemDetailsCompanion(
      itemId: itemId ?? this.itemId,
      payload: payload ?? this.payload,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemDetailsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WishesTable extends Wishes with TableInfo<$WishesTable, WishRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryTypeMeta = const VerificationMeta(
    'categoryType',
  );
  @override
  late final GeneratedColumn<String> categoryType = GeneratedColumn<String>(
    'category_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creatorMeta = const VerificationMeta(
    'creator',
  );
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
    'creator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceKeyMeta = const VerificationMeta(
    'sourceKey',
  );
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
    'source_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalWorkIdMeta = const VerificationMeta(
    'externalWorkId',
  );
  @override
  late final GeneratedColumn<String> externalWorkId = GeneratedColumn<String>(
    'external_work_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<String> seriesId = GeneratedColumn<String>(
    'series_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _volumeNumberMeta = const VerificationMeta(
    'volumeNumber',
  );
  @override
  late final GeneratedColumn<int> volumeNumber = GeneratedColumn<int>(
    'volume_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxPriceCentsMeta = const VerificationMeta(
    'maxPriceCents',
  );
  @override
  late final GeneratedColumn<int> maxPriceCents = GeneratedColumn<int>(
    'max_price_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryType,
    categoryId,
    title,
    creator,
    imageUrl,
    sourceKey,
    externalWorkId,
    barcode,
    seriesId,
    volumeNumber,
    origin,
    priority,
    maxPriceCents,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wishes';
  @override
  VerificationContext validateIntegrity(
    Insertable<WishRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_type')) {
      context.handle(
        _categoryTypeMeta,
        categoryType.isAcceptableOrUnknown(
          data['category_type']!,
          _categoryTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryTypeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('creator')) {
      context.handle(
        _creatorMeta,
        creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('source_key')) {
      context.handle(
        _sourceKeyMeta,
        sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta),
      );
    }
    if (data.containsKey('external_work_id')) {
      context.handle(
        _externalWorkIdMeta,
        externalWorkId.isAcceptableOrUnknown(
          data['external_work_id']!,
          _externalWorkIdMeta,
        ),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    }
    if (data.containsKey('volume_number')) {
      context.handle(
        _volumeNumberMeta,
        volumeNumber.isAcceptableOrUnknown(
          data['volume_number']!,
          _volumeNumberMeta,
        ),
      );
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('max_price_cents')) {
      context.handle(
        _maxPriceCentsMeta,
        maxPriceCents.isAcceptableOrUnknown(
          data['max_price_cents']!,
          _maxPriceCentsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WishRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_type'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      creator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      sourceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_key'],
      ),
      externalWorkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_work_id'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_id'],
      ),
      volumeNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume_number'],
      ),
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      ),
      maxPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_price_cents'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WishesTable createAlias(String alias) {
    return $WishesTable(attachedDatabase, alias);
  }
}

class WishRow extends DataClass implements Insertable<WishRow> {
  final String id;
  final String categoryType;
  final String? categoryId;
  final String title;
  final String? creator;
  final String? imageUrl;
  final String? sourceKey;
  final String? externalWorkId;
  final String? barcode;
  final String? seriesId;
  final int? volumeNumber;
  final String origin;
  final String? priority;
  final int? maxPriceCents;
  final DateTime createdAt;
  const WishRow({
    required this.id,
    required this.categoryType,
    this.categoryId,
    required this.title,
    this.creator,
    this.imageUrl,
    this.sourceKey,
    this.externalWorkId,
    this.barcode,
    this.seriesId,
    this.volumeNumber,
    required this.origin,
    this.priority,
    this.maxPriceCents,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_type'] = Variable<String>(categoryType);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || creator != null) {
      map['creator'] = Variable<String>(creator);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || sourceKey != null) {
      map['source_key'] = Variable<String>(sourceKey);
    }
    if (!nullToAbsent || externalWorkId != null) {
      map['external_work_id'] = Variable<String>(externalWorkId);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || seriesId != null) {
      map['series_id'] = Variable<String>(seriesId);
    }
    if (!nullToAbsent || volumeNumber != null) {
      map['volume_number'] = Variable<int>(volumeNumber);
    }
    map['origin'] = Variable<String>(origin);
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<String>(priority);
    }
    if (!nullToAbsent || maxPriceCents != null) {
      map['max_price_cents'] = Variable<int>(maxPriceCents);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WishesCompanion toCompanion(bool nullToAbsent) {
    return WishesCompanion(
      id: Value(id),
      categoryType: Value(categoryType),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      title: Value(title),
      creator: creator == null && nullToAbsent
          ? const Value.absent()
          : Value(creator),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      sourceKey: sourceKey == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceKey),
      externalWorkId: externalWorkId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalWorkId),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      seriesId: seriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesId),
      volumeNumber: volumeNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(volumeNumber),
      origin: Value(origin),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      maxPriceCents: maxPriceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPriceCents),
      createdAt: Value(createdAt),
    );
  }

  factory WishRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishRow(
      id: serializer.fromJson<String>(json['id']),
      categoryType: serializer.fromJson<String>(json['categoryType']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      title: serializer.fromJson<String>(json['title']),
      creator: serializer.fromJson<String?>(json['creator']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      sourceKey: serializer.fromJson<String?>(json['sourceKey']),
      externalWorkId: serializer.fromJson<String?>(json['externalWorkId']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      seriesId: serializer.fromJson<String?>(json['seriesId']),
      volumeNumber: serializer.fromJson<int?>(json['volumeNumber']),
      origin: serializer.fromJson<String>(json['origin']),
      priority: serializer.fromJson<String?>(json['priority']),
      maxPriceCents: serializer.fromJson<int?>(json['maxPriceCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryType': serializer.toJson<String>(categoryType),
      'categoryId': serializer.toJson<String?>(categoryId),
      'title': serializer.toJson<String>(title),
      'creator': serializer.toJson<String?>(creator),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'sourceKey': serializer.toJson<String?>(sourceKey),
      'externalWorkId': serializer.toJson<String?>(externalWorkId),
      'barcode': serializer.toJson<String?>(barcode),
      'seriesId': serializer.toJson<String?>(seriesId),
      'volumeNumber': serializer.toJson<int?>(volumeNumber),
      'origin': serializer.toJson<String>(origin),
      'priority': serializer.toJson<String?>(priority),
      'maxPriceCents': serializer.toJson<int?>(maxPriceCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WishRow copyWith({
    String? id,
    String? categoryType,
    Value<String?> categoryId = const Value.absent(),
    String? title,
    Value<String?> creator = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> sourceKey = const Value.absent(),
    Value<String?> externalWorkId = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> seriesId = const Value.absent(),
    Value<int?> volumeNumber = const Value.absent(),
    String? origin,
    Value<String?> priority = const Value.absent(),
    Value<int?> maxPriceCents = const Value.absent(),
    DateTime? createdAt,
  }) => WishRow(
    id: id ?? this.id,
    categoryType: categoryType ?? this.categoryType,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    title: title ?? this.title,
    creator: creator.present ? creator.value : this.creator,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    sourceKey: sourceKey.present ? sourceKey.value : this.sourceKey,
    externalWorkId: externalWorkId.present
        ? externalWorkId.value
        : this.externalWorkId,
    barcode: barcode.present ? barcode.value : this.barcode,
    seriesId: seriesId.present ? seriesId.value : this.seriesId,
    volumeNumber: volumeNumber.present ? volumeNumber.value : this.volumeNumber,
    origin: origin ?? this.origin,
    priority: priority.present ? priority.value : this.priority,
    maxPriceCents: maxPriceCents.present
        ? maxPriceCents.value
        : this.maxPriceCents,
    createdAt: createdAt ?? this.createdAt,
  );
  WishRow copyWithCompanion(WishesCompanion data) {
    return WishRow(
      id: data.id.present ? data.id.value : this.id,
      categoryType: data.categoryType.present
          ? data.categoryType.value
          : this.categoryType,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      title: data.title.present ? data.title.value : this.title,
      creator: data.creator.present ? data.creator.value : this.creator,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      externalWorkId: data.externalWorkId.present
          ? data.externalWorkId.value
          : this.externalWorkId,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      volumeNumber: data.volumeNumber.present
          ? data.volumeNumber.value
          : this.volumeNumber,
      origin: data.origin.present ? data.origin.value : this.origin,
      priority: data.priority.present ? data.priority.value : this.priority,
      maxPriceCents: data.maxPriceCents.present
          ? data.maxPriceCents.value
          : this.maxPriceCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishRow(')
          ..write('id: $id, ')
          ..write('categoryType: $categoryType, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('creator: $creator, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('externalWorkId: $externalWorkId, ')
          ..write('barcode: $barcode, ')
          ..write('seriesId: $seriesId, ')
          ..write('volumeNumber: $volumeNumber, ')
          ..write('origin: $origin, ')
          ..write('priority: $priority, ')
          ..write('maxPriceCents: $maxPriceCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryType,
    categoryId,
    title,
    creator,
    imageUrl,
    sourceKey,
    externalWorkId,
    barcode,
    seriesId,
    volumeNumber,
    origin,
    priority,
    maxPriceCents,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishRow &&
          other.id == this.id &&
          other.categoryType == this.categoryType &&
          other.categoryId == this.categoryId &&
          other.title == this.title &&
          other.creator == this.creator &&
          other.imageUrl == this.imageUrl &&
          other.sourceKey == this.sourceKey &&
          other.externalWorkId == this.externalWorkId &&
          other.barcode == this.barcode &&
          other.seriesId == this.seriesId &&
          other.volumeNumber == this.volumeNumber &&
          other.origin == this.origin &&
          other.priority == this.priority &&
          other.maxPriceCents == this.maxPriceCents &&
          other.createdAt == this.createdAt);
}

class WishesCompanion extends UpdateCompanion<WishRow> {
  final Value<String> id;
  final Value<String> categoryType;
  final Value<String?> categoryId;
  final Value<String> title;
  final Value<String?> creator;
  final Value<String?> imageUrl;
  final Value<String?> sourceKey;
  final Value<String?> externalWorkId;
  final Value<String?> barcode;
  final Value<String?> seriesId;
  final Value<int?> volumeNumber;
  final Value<String> origin;
  final Value<String?> priority;
  final Value<int?> maxPriceCents;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WishesCompanion({
    this.id = const Value.absent(),
    this.categoryType = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.creator = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.externalWorkId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.volumeNumber = const Value.absent(),
    this.origin = const Value.absent(),
    this.priority = const Value.absent(),
    this.maxPriceCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WishesCompanion.insert({
    required String id,
    required String categoryType,
    this.categoryId = const Value.absent(),
    required String title,
    this.creator = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.externalWorkId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.volumeNumber = const Value.absent(),
    required String origin,
    this.priority = const Value.absent(),
    this.maxPriceCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryType = Value(categoryType),
       title = Value(title),
       origin = Value(origin);
  static Insertable<WishRow> custom({
    Expression<String>? id,
    Expression<String>? categoryType,
    Expression<String>? categoryId,
    Expression<String>? title,
    Expression<String>? creator,
    Expression<String>? imageUrl,
    Expression<String>? sourceKey,
    Expression<String>? externalWorkId,
    Expression<String>? barcode,
    Expression<String>? seriesId,
    Expression<int>? volumeNumber,
    Expression<String>? origin,
    Expression<String>? priority,
    Expression<int>? maxPriceCents,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryType != null) 'category_type': categoryType,
      if (categoryId != null) 'category_id': categoryId,
      if (title != null) 'title': title,
      if (creator != null) 'creator': creator,
      if (imageUrl != null) 'image_url': imageUrl,
      if (sourceKey != null) 'source_key': sourceKey,
      if (externalWorkId != null) 'external_work_id': externalWorkId,
      if (barcode != null) 'barcode': barcode,
      if (seriesId != null) 'series_id': seriesId,
      if (volumeNumber != null) 'volume_number': volumeNumber,
      if (origin != null) 'origin': origin,
      if (priority != null) 'priority': priority,
      if (maxPriceCents != null) 'max_price_cents': maxPriceCents,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WishesCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryType,
    Value<String?>? categoryId,
    Value<String>? title,
    Value<String?>? creator,
    Value<String?>? imageUrl,
    Value<String?>? sourceKey,
    Value<String?>? externalWorkId,
    Value<String?>? barcode,
    Value<String?>? seriesId,
    Value<int?>? volumeNumber,
    Value<String>? origin,
    Value<String?>? priority,
    Value<int?>? maxPriceCents,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WishesCompanion(
      id: id ?? this.id,
      categoryType: categoryType ?? this.categoryType,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      creator: creator ?? this.creator,
      imageUrl: imageUrl ?? this.imageUrl,
      sourceKey: sourceKey ?? this.sourceKey,
      externalWorkId: externalWorkId ?? this.externalWorkId,
      barcode: barcode ?? this.barcode,
      seriesId: seriesId ?? this.seriesId,
      volumeNumber: volumeNumber ?? this.volumeNumber,
      origin: origin ?? this.origin,
      priority: priority ?? this.priority,
      maxPriceCents: maxPriceCents ?? this.maxPriceCents,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryType.present) {
      map['category_type'] = Variable<String>(categoryType.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (externalWorkId.present) {
      map['external_work_id'] = Variable<String>(externalWorkId.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (seriesId.present) {
      map['series_id'] = Variable<String>(seriesId.value);
    }
    if (volumeNumber.present) {
      map['volume_number'] = Variable<int>(volumeNumber.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (maxPriceCents.present) {
      map['max_price_cents'] = Variable<int>(maxPriceCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WishesCompanion(')
          ..write('id: $id, ')
          ..write('categoryType: $categoryType, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('creator: $creator, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('externalWorkId: $externalWorkId, ')
          ..write('barcode: $barcode, ')
          ..write('seriesId: $seriesId, ')
          ..write('volumeNumber: $volumeNumber, ')
          ..write('origin: $origin, ')
          ..write('priority: $priority, ')
          ..write('maxPriceCents: $maxPriceCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DismissedSuggestionsTable extends DismissedSuggestions
    with TableInfo<$DismissedSuggestionsTable, DismissedSuggestionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DismissedSuggestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourceKeyMeta = const VerificationMeta(
    'sourceKey',
  );
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
    'source_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalWorkIdMeta = const VerificationMeta(
    'externalWorkId',
  );
  @override
  late final GeneratedColumn<String> externalWorkId = GeneratedColumn<String>(
    'external_work_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [sourceKey, externalWorkId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dismissed_suggestions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DismissedSuggestionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source_key')) {
      context.handle(
        _sourceKeyMeta,
        sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKeyMeta);
    }
    if (data.containsKey('external_work_id')) {
      context.handle(
        _externalWorkIdMeta,
        externalWorkId.isAcceptableOrUnknown(
          data['external_work_id']!,
          _externalWorkIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_externalWorkIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sourceKey, externalWorkId};
  @override
  DismissedSuggestionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DismissedSuggestionRow(
      sourceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_key'],
      )!,
      externalWorkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_work_id'],
      )!,
    );
  }

  @override
  $DismissedSuggestionsTable createAlias(String alias) {
    return $DismissedSuggestionsTable(attachedDatabase, alias);
  }
}

class DismissedSuggestionRow extends DataClass
    implements Insertable<DismissedSuggestionRow> {
  final String sourceKey;
  final String externalWorkId;
  const DismissedSuggestionRow({
    required this.sourceKey,
    required this.externalWorkId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source_key'] = Variable<String>(sourceKey);
    map['external_work_id'] = Variable<String>(externalWorkId);
    return map;
  }

  DismissedSuggestionsCompanion toCompanion(bool nullToAbsent) {
    return DismissedSuggestionsCompanion(
      sourceKey: Value(sourceKey),
      externalWorkId: Value(externalWorkId),
    );
  }

  factory DismissedSuggestionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DismissedSuggestionRow(
      sourceKey: serializer.fromJson<String>(json['sourceKey']),
      externalWorkId: serializer.fromJson<String>(json['externalWorkId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sourceKey': serializer.toJson<String>(sourceKey),
      'externalWorkId': serializer.toJson<String>(externalWorkId),
    };
  }

  DismissedSuggestionRow copyWith({
    String? sourceKey,
    String? externalWorkId,
  }) => DismissedSuggestionRow(
    sourceKey: sourceKey ?? this.sourceKey,
    externalWorkId: externalWorkId ?? this.externalWorkId,
  );
  DismissedSuggestionRow copyWithCompanion(DismissedSuggestionsCompanion data) {
    return DismissedSuggestionRow(
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      externalWorkId: data.externalWorkId.present
          ? data.externalWorkId.value
          : this.externalWorkId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DismissedSuggestionRow(')
          ..write('sourceKey: $sourceKey, ')
          ..write('externalWorkId: $externalWorkId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sourceKey, externalWorkId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DismissedSuggestionRow &&
          other.sourceKey == this.sourceKey &&
          other.externalWorkId == this.externalWorkId);
}

class DismissedSuggestionsCompanion
    extends UpdateCompanion<DismissedSuggestionRow> {
  final Value<String> sourceKey;
  final Value<String> externalWorkId;
  final Value<int> rowid;
  const DismissedSuggestionsCompanion({
    this.sourceKey = const Value.absent(),
    this.externalWorkId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DismissedSuggestionsCompanion.insert({
    required String sourceKey,
    required String externalWorkId,
    this.rowid = const Value.absent(),
  }) : sourceKey = Value(sourceKey),
       externalWorkId = Value(externalWorkId);
  static Insertable<DismissedSuggestionRow> custom({
    Expression<String>? sourceKey,
    Expression<String>? externalWorkId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sourceKey != null) 'source_key': sourceKey,
      if (externalWorkId != null) 'external_work_id': externalWorkId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DismissedSuggestionsCompanion copyWith({
    Value<String>? sourceKey,
    Value<String>? externalWorkId,
    Value<int>? rowid,
  }) {
    return DismissedSuggestionsCompanion(
      sourceKey: sourceKey ?? this.sourceKey,
      externalWorkId: externalWorkId ?? this.externalWorkId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (externalWorkId.present) {
      map['external_work_id'] = Variable<String>(externalWorkId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DismissedSuggestionsCompanion(')
          ..write('sourceKey: $sourceKey, ')
          ..write('externalWorkId: $externalWorkId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiscoveryCacheTable extends DiscoveryCache
    with TableInfo<$DiscoveryCacheTable, DiscoveryCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscoveryCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, payload, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discovery_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiscoveryCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiscoveryCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiscoveryCacheRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $DiscoveryCacheTable createAlias(String alias) {
    return $DiscoveryCacheTable(attachedDatabase, alias);
  }
}

class DiscoveryCacheRow extends DataClass
    implements Insertable<DiscoveryCacheRow> {
  final String id;
  final String payload;
  final DateTime fetchedAt;
  const DiscoveryCacheRow({
    required this.id,
    required this.payload,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload'] = Variable<String>(payload);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  DiscoveryCacheCompanion toCompanion(bool nullToAbsent) {
    return DiscoveryCacheCompanion(
      id: Value(id),
      payload: Value(payload),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory DiscoveryCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiscoveryCacheRow(
      id: serializer.fromJson<String>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payload': serializer.toJson<String>(payload),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  DiscoveryCacheRow copyWith({
    String? id,
    String? payload,
    DateTime? fetchedAt,
  }) => DiscoveryCacheRow(
    id: id ?? this.id,
    payload: payload ?? this.payload,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  DiscoveryCacheRow copyWithCompanion(DiscoveryCacheCompanion data) {
    return DiscoveryCacheRow(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiscoveryCacheRow(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payload, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscoveryCacheRow &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.fetchedAt == this.fetchedAt);
}

class DiscoveryCacheCompanion extends UpdateCompanion<DiscoveryCacheRow> {
  final Value<String> id;
  final Value<String> payload;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const DiscoveryCacheCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiscoveryCacheCompanion.insert({
    required String id,
    required String payload,
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payload = Value(payload);
  static Insertable<DiscoveryCacheRow> custom({
    Expression<String>? id,
    Expression<String>? payload,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiscoveryCacheCompanion copyWith({
    Value<String>? id,
    Value<String>? payload,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return DiscoveryCacheCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscoveryCacheCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanFollowsTable extends ScanFollows
    with TableInfo<$ScanFollowsTable, ScanFollowRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanFollowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<String> seriesId = GeneratedColumn<String>(
    'series_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _siteUrlMeta = const VerificationMeta(
    'siteUrl',
  );
  @override
  late final GeneratedColumn<String> siteUrl = GeneratedColumn<String>(
    'site_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _teamNameMeta = const VerificationMeta(
    'teamName',
  );
  @override
  late final GeneratedColumn<String> teamName = GeneratedColumn<String>(
    'team_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mangaUpdatesSeriesIdMeta =
      const VerificationMeta('mangaUpdatesSeriesId');
  @override
  late final GeneratedColumn<String> mangaUpdatesSeriesId =
      GeneratedColumn<String>(
        'manga_updates_series_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _alertsEnabledMeta = const VerificationMeta(
    'alertsEnabled',
  );
  @override
  late final GeneratedColumn<bool> alertsEnabled = GeneratedColumn<bool>(
    'alerts_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alerts_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _onlyFollowedTeamMeta = const VerificationMeta(
    'onlyFollowedTeam',
  );
  @override
  late final GeneratedColumn<bool> onlyFollowedTeam = GeneratedColumn<bool>(
    'only_followed_team',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("only_followed_team" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastCheckedAtMeta = const VerificationMeta(
    'lastCheckedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCheckedAt =
      GeneratedColumn<DateTime>(
        'last_checked_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    seriesId,
    siteUrl,
    teamName,
    mangaUpdatesSeriesId,
    alertsEnabled,
    onlyFollowedTeam,
    lastCheckedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_follows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanFollowRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesIdMeta);
    }
    if (data.containsKey('site_url')) {
      context.handle(
        _siteUrlMeta,
        siteUrl.isAcceptableOrUnknown(data['site_url']!, _siteUrlMeta),
      );
    }
    if (data.containsKey('team_name')) {
      context.handle(
        _teamNameMeta,
        teamName.isAcceptableOrUnknown(data['team_name']!, _teamNameMeta),
      );
    }
    if (data.containsKey('manga_updates_series_id')) {
      context.handle(
        _mangaUpdatesSeriesIdMeta,
        mangaUpdatesSeriesId.isAcceptableOrUnknown(
          data['manga_updates_series_id']!,
          _mangaUpdatesSeriesIdMeta,
        ),
      );
    }
    if (data.containsKey('alerts_enabled')) {
      context.handle(
        _alertsEnabledMeta,
        alertsEnabled.isAcceptableOrUnknown(
          data['alerts_enabled']!,
          _alertsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('only_followed_team')) {
      context.handle(
        _onlyFollowedTeamMeta,
        onlyFollowedTeam.isAcceptableOrUnknown(
          data['only_followed_team']!,
          _onlyFollowedTeamMeta,
        ),
      );
    }
    if (data.containsKey('last_checked_at')) {
      context.handle(
        _lastCheckedAtMeta,
        lastCheckedAt.isAcceptableOrUnknown(
          data['last_checked_at']!,
          _lastCheckedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seriesId};
  @override
  ScanFollowRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanFollowRow(
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_id'],
      )!,
      siteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_url'],
      ),
      teamName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_name'],
      ),
      mangaUpdatesSeriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manga_updates_series_id'],
      ),
      alertsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alerts_enabled'],
      )!,
      onlyFollowedTeam: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}only_followed_team'],
      )!,
      lastCheckedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_checked_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ScanFollowsTable createAlias(String alias) {
    return $ScanFollowsTable(attachedDatabase, alias);
  }
}

class ScanFollowRow extends DataClass implements Insertable<ScanFollowRow> {
  final String seriesId;
  final String? siteUrl;
  final String? teamName;
  final String? mangaUpdatesSeriesId;
  final bool alertsEnabled;
  final bool onlyFollowedTeam;
  final DateTime? lastCheckedAt;
  final DateTime createdAt;
  const ScanFollowRow({
    required this.seriesId,
    this.siteUrl,
    this.teamName,
    this.mangaUpdatesSeriesId,
    required this.alertsEnabled,
    required this.onlyFollowedTeam,
    this.lastCheckedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['series_id'] = Variable<String>(seriesId);
    if (!nullToAbsent || siteUrl != null) {
      map['site_url'] = Variable<String>(siteUrl);
    }
    if (!nullToAbsent || teamName != null) {
      map['team_name'] = Variable<String>(teamName);
    }
    if (!nullToAbsent || mangaUpdatesSeriesId != null) {
      map['manga_updates_series_id'] = Variable<String>(mangaUpdatesSeriesId);
    }
    map['alerts_enabled'] = Variable<bool>(alertsEnabled);
    map['only_followed_team'] = Variable<bool>(onlyFollowedTeam);
    if (!nullToAbsent || lastCheckedAt != null) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScanFollowsCompanion toCompanion(bool nullToAbsent) {
    return ScanFollowsCompanion(
      seriesId: Value(seriesId),
      siteUrl: siteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(siteUrl),
      teamName: teamName == null && nullToAbsent
          ? const Value.absent()
          : Value(teamName),
      mangaUpdatesSeriesId: mangaUpdatesSeriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(mangaUpdatesSeriesId),
      alertsEnabled: Value(alertsEnabled),
      onlyFollowedTeam: Value(onlyFollowedTeam),
      lastCheckedAt: lastCheckedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckedAt),
      createdAt: Value(createdAt),
    );
  }

  factory ScanFollowRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanFollowRow(
      seriesId: serializer.fromJson<String>(json['seriesId']),
      siteUrl: serializer.fromJson<String?>(json['siteUrl']),
      teamName: serializer.fromJson<String?>(json['teamName']),
      mangaUpdatesSeriesId: serializer.fromJson<String?>(
        json['mangaUpdatesSeriesId'],
      ),
      alertsEnabled: serializer.fromJson<bool>(json['alertsEnabled']),
      onlyFollowedTeam: serializer.fromJson<bool>(json['onlyFollowedTeam']),
      lastCheckedAt: serializer.fromJson<DateTime?>(json['lastCheckedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seriesId': serializer.toJson<String>(seriesId),
      'siteUrl': serializer.toJson<String?>(siteUrl),
      'teamName': serializer.toJson<String?>(teamName),
      'mangaUpdatesSeriesId': serializer.toJson<String?>(mangaUpdatesSeriesId),
      'alertsEnabled': serializer.toJson<bool>(alertsEnabled),
      'onlyFollowedTeam': serializer.toJson<bool>(onlyFollowedTeam),
      'lastCheckedAt': serializer.toJson<DateTime?>(lastCheckedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScanFollowRow copyWith({
    String? seriesId,
    Value<String?> siteUrl = const Value.absent(),
    Value<String?> teamName = const Value.absent(),
    Value<String?> mangaUpdatesSeriesId = const Value.absent(),
    bool? alertsEnabled,
    bool? onlyFollowedTeam,
    Value<DateTime?> lastCheckedAt = const Value.absent(),
    DateTime? createdAt,
  }) => ScanFollowRow(
    seriesId: seriesId ?? this.seriesId,
    siteUrl: siteUrl.present ? siteUrl.value : this.siteUrl,
    teamName: teamName.present ? teamName.value : this.teamName,
    mangaUpdatesSeriesId: mangaUpdatesSeriesId.present
        ? mangaUpdatesSeriesId.value
        : this.mangaUpdatesSeriesId,
    alertsEnabled: alertsEnabled ?? this.alertsEnabled,
    onlyFollowedTeam: onlyFollowedTeam ?? this.onlyFollowedTeam,
    lastCheckedAt: lastCheckedAt.present
        ? lastCheckedAt.value
        : this.lastCheckedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  ScanFollowRow copyWithCompanion(ScanFollowsCompanion data) {
    return ScanFollowRow(
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      siteUrl: data.siteUrl.present ? data.siteUrl.value : this.siteUrl,
      teamName: data.teamName.present ? data.teamName.value : this.teamName,
      mangaUpdatesSeriesId: data.mangaUpdatesSeriesId.present
          ? data.mangaUpdatesSeriesId.value
          : this.mangaUpdatesSeriesId,
      alertsEnabled: data.alertsEnabled.present
          ? data.alertsEnabled.value
          : this.alertsEnabled,
      onlyFollowedTeam: data.onlyFollowedTeam.present
          ? data.onlyFollowedTeam.value
          : this.onlyFollowedTeam,
      lastCheckedAt: data.lastCheckedAt.present
          ? data.lastCheckedAt.value
          : this.lastCheckedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanFollowRow(')
          ..write('seriesId: $seriesId, ')
          ..write('siteUrl: $siteUrl, ')
          ..write('teamName: $teamName, ')
          ..write('mangaUpdatesSeriesId: $mangaUpdatesSeriesId, ')
          ..write('alertsEnabled: $alertsEnabled, ')
          ..write('onlyFollowedTeam: $onlyFollowedTeam, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seriesId,
    siteUrl,
    teamName,
    mangaUpdatesSeriesId,
    alertsEnabled,
    onlyFollowedTeam,
    lastCheckedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanFollowRow &&
          other.seriesId == this.seriesId &&
          other.siteUrl == this.siteUrl &&
          other.teamName == this.teamName &&
          other.mangaUpdatesSeriesId == this.mangaUpdatesSeriesId &&
          other.alertsEnabled == this.alertsEnabled &&
          other.onlyFollowedTeam == this.onlyFollowedTeam &&
          other.lastCheckedAt == this.lastCheckedAt &&
          other.createdAt == this.createdAt);
}

class ScanFollowsCompanion extends UpdateCompanion<ScanFollowRow> {
  final Value<String> seriesId;
  final Value<String?> siteUrl;
  final Value<String?> teamName;
  final Value<String?> mangaUpdatesSeriesId;
  final Value<bool> alertsEnabled;
  final Value<bool> onlyFollowedTeam;
  final Value<DateTime?> lastCheckedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ScanFollowsCompanion({
    this.seriesId = const Value.absent(),
    this.siteUrl = const Value.absent(),
    this.teamName = const Value.absent(),
    this.mangaUpdatesSeriesId = const Value.absent(),
    this.alertsEnabled = const Value.absent(),
    this.onlyFollowedTeam = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScanFollowsCompanion.insert({
    required String seriesId,
    this.siteUrl = const Value.absent(),
    this.teamName = const Value.absent(),
    this.mangaUpdatesSeriesId = const Value.absent(),
    this.alertsEnabled = const Value.absent(),
    this.onlyFollowedTeam = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : seriesId = Value(seriesId);
  static Insertable<ScanFollowRow> custom({
    Expression<String>? seriesId,
    Expression<String>? siteUrl,
    Expression<String>? teamName,
    Expression<String>? mangaUpdatesSeriesId,
    Expression<bool>? alertsEnabled,
    Expression<bool>? onlyFollowedTeam,
    Expression<DateTime>? lastCheckedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (seriesId != null) 'series_id': seriesId,
      if (siteUrl != null) 'site_url': siteUrl,
      if (teamName != null) 'team_name': teamName,
      if (mangaUpdatesSeriesId != null)
        'manga_updates_series_id': mangaUpdatesSeriesId,
      if (alertsEnabled != null) 'alerts_enabled': alertsEnabled,
      if (onlyFollowedTeam != null) 'only_followed_team': onlyFollowedTeam,
      if (lastCheckedAt != null) 'last_checked_at': lastCheckedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScanFollowsCompanion copyWith({
    Value<String>? seriesId,
    Value<String?>? siteUrl,
    Value<String?>? teamName,
    Value<String?>? mangaUpdatesSeriesId,
    Value<bool>? alertsEnabled,
    Value<bool>? onlyFollowedTeam,
    Value<DateTime?>? lastCheckedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ScanFollowsCompanion(
      seriesId: seriesId ?? this.seriesId,
      siteUrl: siteUrl ?? this.siteUrl,
      teamName: teamName ?? this.teamName,
      mangaUpdatesSeriesId: mangaUpdatesSeriesId ?? this.mangaUpdatesSeriesId,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      onlyFollowedTeam: onlyFollowedTeam ?? this.onlyFollowedTeam,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seriesId.present) {
      map['series_id'] = Variable<String>(seriesId.value);
    }
    if (siteUrl.present) {
      map['site_url'] = Variable<String>(siteUrl.value);
    }
    if (teamName.present) {
      map['team_name'] = Variable<String>(teamName.value);
    }
    if (mangaUpdatesSeriesId.present) {
      map['manga_updates_series_id'] = Variable<String>(
        mangaUpdatesSeriesId.value,
      );
    }
    if (alertsEnabled.present) {
      map['alerts_enabled'] = Variable<bool>(alertsEnabled.value);
    }
    if (onlyFollowedTeam.present) {
      map['only_followed_team'] = Variable<bool>(onlyFollowedTeam.value);
    }
    if (lastCheckedAt.present) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanFollowsCompanion(')
          ..write('seriesId: $seriesId, ')
          ..write('siteUrl: $siteUrl, ')
          ..write('teamName: $teamName, ')
          ..write('mangaUpdatesSeriesId: $mangaUpdatesSeriesId, ')
          ..write('alertsEnabled: $alertsEnabled, ')
          ..write('onlyFollowedTeam: $onlyFollowedTeam, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadChaptersTable extends ReadChapters
    with TableInfo<$ReadChaptersTable, ReadChapterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<String> seriesId = GeneratedColumn<String>(
    'series_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<double> chapter = GeneratedColumn<double>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [seriesId, chapter];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'read_chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadChapterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seriesId, chapter};
  @override
  ReadChapterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadChapterRow(
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_id'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chapter'],
      )!,
    );
  }

  @override
  $ReadChaptersTable createAlias(String alias) {
    return $ReadChaptersTable(attachedDatabase, alias);
  }
}

class ReadChapterRow extends DataClass implements Insertable<ReadChapterRow> {
  final String seriesId;
  final double chapter;
  const ReadChapterRow({required this.seriesId, required this.chapter});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['series_id'] = Variable<String>(seriesId);
    map['chapter'] = Variable<double>(chapter);
    return map;
  }

  ReadChaptersCompanion toCompanion(bool nullToAbsent) {
    return ReadChaptersCompanion(
      seriesId: Value(seriesId),
      chapter: Value(chapter),
    );
  }

  factory ReadChapterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadChapterRow(
      seriesId: serializer.fromJson<String>(json['seriesId']),
      chapter: serializer.fromJson<double>(json['chapter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seriesId': serializer.toJson<String>(seriesId),
      'chapter': serializer.toJson<double>(chapter),
    };
  }

  ReadChapterRow copyWith({String? seriesId, double? chapter}) =>
      ReadChapterRow(
        seriesId: seriesId ?? this.seriesId,
        chapter: chapter ?? this.chapter,
      );
  ReadChapterRow copyWithCompanion(ReadChaptersCompanion data) {
    return ReadChapterRow(
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadChapterRow(')
          ..write('seriesId: $seriesId, ')
          ..write('chapter: $chapter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(seriesId, chapter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadChapterRow &&
          other.seriesId == this.seriesId &&
          other.chapter == this.chapter);
}

class ReadChaptersCompanion extends UpdateCompanion<ReadChapterRow> {
  final Value<String> seriesId;
  final Value<double> chapter;
  final Value<int> rowid;
  const ReadChaptersCompanion({
    this.seriesId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadChaptersCompanion.insert({
    required String seriesId,
    required double chapter,
    this.rowid = const Value.absent(),
  }) : seriesId = Value(seriesId),
       chapter = Value(chapter);
  static Insertable<ReadChapterRow> custom({
    Expression<String>? seriesId,
    Expression<double>? chapter,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (seriesId != null) 'series_id': seriesId,
      if (chapter != null) 'chapter': chapter,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadChaptersCompanion copyWith({
    Value<String>? seriesId,
    Value<double>? chapter,
    Value<int>? rowid,
  }) {
    return ReadChaptersCompanion(
      seriesId: seriesId ?? this.seriesId,
      chapter: chapter ?? this.chapter,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seriesId.present) {
      map['series_id'] = Variable<String>(seriesId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<double>(chapter.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadChaptersCompanion(')
          ..write('seriesId: $seriesId, ')
          ..write('chapter: $chapter, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanReleasesTable extends ScanReleases
    with TableInfo<$ScanReleasesTable, ScanReleaseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanReleasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<String> seriesId = GeneratedColumn<String>(
    'series_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<double> chapter = GeneratedColumn<double>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamNameMeta = const VerificationMeta(
    'teamName',
  );
  @override
  late final GeneratedColumn<String> teamName = GeneratedColumn<String>(
    'team_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releasedOnMeta = const VerificationMeta(
    'releasedOn',
  );
  @override
  late final GeneratedColumn<DateTime> releasedOn = GeneratedColumn<DateTime>(
    'released_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifiedMeta = const VerificationMeta(
    'notified',
  );
  @override
  late final GeneratedColumn<bool> notified = GeneratedColumn<bool>(
    'notified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    seriesId,
    chapter,
    teamName,
    releasedOn,
    notified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_releases';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanReleaseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('team_name')) {
      context.handle(
        _teamNameMeta,
        teamName.isAcceptableOrUnknown(data['team_name']!, _teamNameMeta),
      );
    } else if (isInserting) {
      context.missing(_teamNameMeta);
    }
    if (data.containsKey('released_on')) {
      context.handle(
        _releasedOnMeta,
        releasedOn.isAcceptableOrUnknown(data['released_on']!, _releasedOnMeta),
      );
    }
    if (data.containsKey('notified')) {
      context.handle(
        _notifiedMeta,
        notified.isAcceptableOrUnknown(data['notified']!, _notifiedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seriesId, chapter, teamName};
  @override
  ScanReleaseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanReleaseRow(
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_id'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chapter'],
      )!,
      teamName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_name'],
      )!,
      releasedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}released_on'],
      ),
      notified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notified'],
      )!,
    );
  }

  @override
  $ScanReleasesTable createAlias(String alias) {
    return $ScanReleasesTable(attachedDatabase, alias);
  }
}

class ScanReleaseRow extends DataClass implements Insertable<ScanReleaseRow> {
  final String seriesId;
  final double chapter;
  final String teamName;
  final DateTime? releasedOn;
  final bool notified;
  const ScanReleaseRow({
    required this.seriesId,
    required this.chapter,
    required this.teamName,
    this.releasedOn,
    required this.notified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['series_id'] = Variable<String>(seriesId);
    map['chapter'] = Variable<double>(chapter);
    map['team_name'] = Variable<String>(teamName);
    if (!nullToAbsent || releasedOn != null) {
      map['released_on'] = Variable<DateTime>(releasedOn);
    }
    map['notified'] = Variable<bool>(notified);
    return map;
  }

  ScanReleasesCompanion toCompanion(bool nullToAbsent) {
    return ScanReleasesCompanion(
      seriesId: Value(seriesId),
      chapter: Value(chapter),
      teamName: Value(teamName),
      releasedOn: releasedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(releasedOn),
      notified: Value(notified),
    );
  }

  factory ScanReleaseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanReleaseRow(
      seriesId: serializer.fromJson<String>(json['seriesId']),
      chapter: serializer.fromJson<double>(json['chapter']),
      teamName: serializer.fromJson<String>(json['teamName']),
      releasedOn: serializer.fromJson<DateTime?>(json['releasedOn']),
      notified: serializer.fromJson<bool>(json['notified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seriesId': serializer.toJson<String>(seriesId),
      'chapter': serializer.toJson<double>(chapter),
      'teamName': serializer.toJson<String>(teamName),
      'releasedOn': serializer.toJson<DateTime?>(releasedOn),
      'notified': serializer.toJson<bool>(notified),
    };
  }

  ScanReleaseRow copyWith({
    String? seriesId,
    double? chapter,
    String? teamName,
    Value<DateTime?> releasedOn = const Value.absent(),
    bool? notified,
  }) => ScanReleaseRow(
    seriesId: seriesId ?? this.seriesId,
    chapter: chapter ?? this.chapter,
    teamName: teamName ?? this.teamName,
    releasedOn: releasedOn.present ? releasedOn.value : this.releasedOn,
    notified: notified ?? this.notified,
  );
  ScanReleaseRow copyWithCompanion(ScanReleasesCompanion data) {
    return ScanReleaseRow(
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      teamName: data.teamName.present ? data.teamName.value : this.teamName,
      releasedOn: data.releasedOn.present
          ? data.releasedOn.value
          : this.releasedOn,
      notified: data.notified.present ? data.notified.value : this.notified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanReleaseRow(')
          ..write('seriesId: $seriesId, ')
          ..write('chapter: $chapter, ')
          ..write('teamName: $teamName, ')
          ..write('releasedOn: $releasedOn, ')
          ..write('notified: $notified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(seriesId, chapter, teamName, releasedOn, notified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanReleaseRow &&
          other.seriesId == this.seriesId &&
          other.chapter == this.chapter &&
          other.teamName == this.teamName &&
          other.releasedOn == this.releasedOn &&
          other.notified == this.notified);
}

class ScanReleasesCompanion extends UpdateCompanion<ScanReleaseRow> {
  final Value<String> seriesId;
  final Value<double> chapter;
  final Value<String> teamName;
  final Value<DateTime?> releasedOn;
  final Value<bool> notified;
  final Value<int> rowid;
  const ScanReleasesCompanion({
    this.seriesId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.teamName = const Value.absent(),
    this.releasedOn = const Value.absent(),
    this.notified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScanReleasesCompanion.insert({
    required String seriesId,
    required double chapter,
    required String teamName,
    this.releasedOn = const Value.absent(),
    this.notified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : seriesId = Value(seriesId),
       chapter = Value(chapter),
       teamName = Value(teamName);
  static Insertable<ScanReleaseRow> custom({
    Expression<String>? seriesId,
    Expression<double>? chapter,
    Expression<String>? teamName,
    Expression<DateTime>? releasedOn,
    Expression<bool>? notified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (seriesId != null) 'series_id': seriesId,
      if (chapter != null) 'chapter': chapter,
      if (teamName != null) 'team_name': teamName,
      if (releasedOn != null) 'released_on': releasedOn,
      if (notified != null) 'notified': notified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScanReleasesCompanion copyWith({
    Value<String>? seriesId,
    Value<double>? chapter,
    Value<String>? teamName,
    Value<DateTime?>? releasedOn,
    Value<bool>? notified,
    Value<int>? rowid,
  }) {
    return ScanReleasesCompanion(
      seriesId: seriesId ?? this.seriesId,
      chapter: chapter ?? this.chapter,
      teamName: teamName ?? this.teamName,
      releasedOn: releasedOn ?? this.releasedOn,
      notified: notified ?? this.notified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seriesId.present) {
      map['series_id'] = Variable<String>(seriesId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<double>(chapter.value);
    }
    if (teamName.present) {
      map['team_name'] = Variable<String>(teamName.value);
    }
    if (releasedOn.present) {
      map['released_on'] = Variable<DateTime>(releasedOn.value);
    }
    if (notified.present) {
      map['notified'] = Variable<bool>(notified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanReleasesCompanion(')
          ..write('seriesId: $seriesId, ')
          ..write('chapter: $chapter, ')
          ..write('teamName: $teamName, ')
          ..write('releasedOn: $releasedOn, ')
          ..write('notified: $notified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceBlocksTable extends SourceBlocks
    with TableInfo<$SourceBlocksTable, SourceBlockRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _apiFamilyMeta = const VerificationMeta(
    'apiFamily',
  );
  @override
  late final GeneratedColumn<String> apiFamily = GeneratedColumn<String>(
    'api_family',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockedAtMeta = const VerificationMeta(
    'blockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> blockedAt = GeneratedColumn<DateTime>(
    'blocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryAtMeta = const VerificationMeta(
    'retryAt',
  );
  @override
  late final GeneratedColumn<DateTime> retryAt = GeneratedColumn<DateTime>(
    'retry_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [apiFamily, blockedAt, retryAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceBlockRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('api_family')) {
      context.handle(
        _apiFamilyMeta,
        apiFamily.isAcceptableOrUnknown(data['api_family']!, _apiFamilyMeta),
      );
    } else if (isInserting) {
      context.missing(_apiFamilyMeta);
    }
    if (data.containsKey('blocked_at')) {
      context.handle(
        _blockedAtMeta,
        blockedAt.isAcceptableOrUnknown(data['blocked_at']!, _blockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_blockedAtMeta);
    }
    if (data.containsKey('retry_at')) {
      context.handle(
        _retryAtMeta,
        retryAt.isAcceptableOrUnknown(data['retry_at']!, _retryAtMeta),
      );
    } else if (isInserting) {
      context.missing(_retryAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {apiFamily};
  @override
  SourceBlockRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceBlockRow(
      apiFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}api_family'],
      )!,
      blockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}blocked_at'],
      )!,
      retryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}retry_at'],
      )!,
    );
  }

  @override
  $SourceBlocksTable createAlias(String alias) {
    return $SourceBlocksTable(attachedDatabase, alias);
  }
}

class SourceBlockRow extends DataClass implements Insertable<SourceBlockRow> {
  final String apiFamily;
  final DateTime blockedAt;
  final DateTime retryAt;
  const SourceBlockRow({
    required this.apiFamily,
    required this.blockedAt,
    required this.retryAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['api_family'] = Variable<String>(apiFamily);
    map['blocked_at'] = Variable<DateTime>(blockedAt);
    map['retry_at'] = Variable<DateTime>(retryAt);
    return map;
  }

  SourceBlocksCompanion toCompanion(bool nullToAbsent) {
    return SourceBlocksCompanion(
      apiFamily: Value(apiFamily),
      blockedAt: Value(blockedAt),
      retryAt: Value(retryAt),
    );
  }

  factory SourceBlockRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceBlockRow(
      apiFamily: serializer.fromJson<String>(json['apiFamily']),
      blockedAt: serializer.fromJson<DateTime>(json['blockedAt']),
      retryAt: serializer.fromJson<DateTime>(json['retryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'apiFamily': serializer.toJson<String>(apiFamily),
      'blockedAt': serializer.toJson<DateTime>(blockedAt),
      'retryAt': serializer.toJson<DateTime>(retryAt),
    };
  }

  SourceBlockRow copyWith({
    String? apiFamily,
    DateTime? blockedAt,
    DateTime? retryAt,
  }) => SourceBlockRow(
    apiFamily: apiFamily ?? this.apiFamily,
    blockedAt: blockedAt ?? this.blockedAt,
    retryAt: retryAt ?? this.retryAt,
  );
  SourceBlockRow copyWithCompanion(SourceBlocksCompanion data) {
    return SourceBlockRow(
      apiFamily: data.apiFamily.present ? data.apiFamily.value : this.apiFamily,
      blockedAt: data.blockedAt.present ? data.blockedAt.value : this.blockedAt,
      retryAt: data.retryAt.present ? data.retryAt.value : this.retryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceBlockRow(')
          ..write('apiFamily: $apiFamily, ')
          ..write('blockedAt: $blockedAt, ')
          ..write('retryAt: $retryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(apiFamily, blockedAt, retryAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceBlockRow &&
          other.apiFamily == this.apiFamily &&
          other.blockedAt == this.blockedAt &&
          other.retryAt == this.retryAt);
}

class SourceBlocksCompanion extends UpdateCompanion<SourceBlockRow> {
  final Value<String> apiFamily;
  final Value<DateTime> blockedAt;
  final Value<DateTime> retryAt;
  final Value<int> rowid;
  const SourceBlocksCompanion({
    this.apiFamily = const Value.absent(),
    this.blockedAt = const Value.absent(),
    this.retryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceBlocksCompanion.insert({
    required String apiFamily,
    required DateTime blockedAt,
    required DateTime retryAt,
    this.rowid = const Value.absent(),
  }) : apiFamily = Value(apiFamily),
       blockedAt = Value(blockedAt),
       retryAt = Value(retryAt);
  static Insertable<SourceBlockRow> custom({
    Expression<String>? apiFamily,
    Expression<DateTime>? blockedAt,
    Expression<DateTime>? retryAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (apiFamily != null) 'api_family': apiFamily,
      if (blockedAt != null) 'blocked_at': blockedAt,
      if (retryAt != null) 'retry_at': retryAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceBlocksCompanion copyWith({
    Value<String>? apiFamily,
    Value<DateTime>? blockedAt,
    Value<DateTime>? retryAt,
    Value<int>? rowid,
  }) {
    return SourceBlocksCompanion(
      apiFamily: apiFamily ?? this.apiFamily,
      blockedAt: blockedAt ?? this.blockedAt,
      retryAt: retryAt ?? this.retryAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (apiFamily.present) {
      map['api_family'] = Variable<String>(apiFamily.value);
    }
    if (blockedAt.present) {
      map['blocked_at'] = Variable<DateTime>(blockedAt.value);
    }
    if (retryAt.present) {
      map['retry_at'] = Variable<DateTime>(retryAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceBlocksCompanion(')
          ..write('apiFamily: $apiFamily, ')
          ..write('blockedAt: $blockedAt, ')
          ..write('retryAt: $retryAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemPhotosTable extends ItemPhotos
    with TableInfo<$ItemPhotosTable, ItemPhotoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _copyIdMeta = const VerificationMeta('copyId');
  @override
  late final GeneratedColumn<String> copyId = GeneratedColumn<String>(
    'copy_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES copies (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    copyId,
    path,
    position,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemPhotoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('copy_id')) {
      context.handle(
        _copyIdMeta,
        copyId.isAcceptableOrUnknown(data['copy_id']!, _copyIdMeta),
      );
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemPhotoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemPhotoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      copyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copy_id'],
      ),
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ItemPhotosTable createAlias(String alias) {
    return $ItemPhotosTable(attachedDatabase, alias);
  }
}

class ItemPhotoRow extends DataClass implements Insertable<ItemPhotoRow> {
  final String id;
  final String itemId;
  final String? copyId;
  final String path;
  final int position;
  final DateTime createdAt;
  const ItemPhotoRow({
    required this.id,
    required this.itemId,
    this.copyId,
    required this.path,
    required this.position,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    if (!nullToAbsent || copyId != null) {
      map['copy_id'] = Variable<String>(copyId);
    }
    map['path'] = Variable<String>(path);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ItemPhotosCompanion toCompanion(bool nullToAbsent) {
    return ItemPhotosCompanion(
      id: Value(id),
      itemId: Value(itemId),
      copyId: copyId == null && nullToAbsent
          ? const Value.absent()
          : Value(copyId),
      path: Value(path),
      position: Value(position),
      createdAt: Value(createdAt),
    );
  }

  factory ItemPhotoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemPhotoRow(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      copyId: serializer.fromJson<String?>(json['copyId']),
      path: serializer.fromJson<String>(json['path']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'copyId': serializer.toJson<String?>(copyId),
      'path': serializer.toJson<String>(path),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ItemPhotoRow copyWith({
    String? id,
    String? itemId,
    Value<String?> copyId = const Value.absent(),
    String? path,
    int? position,
    DateTime? createdAt,
  }) => ItemPhotoRow(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    copyId: copyId.present ? copyId.value : this.copyId,
    path: path ?? this.path,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
  );
  ItemPhotoRow copyWithCompanion(ItemPhotosCompanion data) {
    return ItemPhotoRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      copyId: data.copyId.present ? data.copyId.value : this.copyId,
      path: data.path.present ? data.path.value : this.path,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemPhotoRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('copyId: $copyId, ')
          ..write('path: $path, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, itemId, copyId, path, position, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemPhotoRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.copyId == this.copyId &&
          other.path == this.path &&
          other.position == this.position &&
          other.createdAt == this.createdAt);
}

class ItemPhotosCompanion extends UpdateCompanion<ItemPhotoRow> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String?> copyId;
  final Value<String> path;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ItemPhotosCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.copyId = const Value.absent(),
    this.path = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemPhotosCompanion.insert({
    required String id,
    required String itemId,
    this.copyId = const Value.absent(),
    required String path,
    required int position,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemId = Value(itemId),
       path = Value(path),
       position = Value(position);
  static Insertable<ItemPhotoRow> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? copyId,
    Expression<String>? path,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (copyId != null) 'copy_id': copyId,
      if (path != null) 'path': path,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? itemId,
    Value<String?>? copyId,
    Value<String>? path,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ItemPhotosCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      copyId: copyId ?? this.copyId,
      path: path ?? this.path,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (copyId.present) {
      map['copy_id'] = Variable<String>(copyId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemPhotosCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('copyId: $copyId, ')
          ..write('path: $path, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SteamGameStatsTable extends SteamGameStats
    with TableInfo<$SteamGameStatsTable, SteamGameStatsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SteamGameStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
    'app_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playtimeMinutesMeta = const VerificationMeta(
    'playtimeMinutes',
  );
  @override
  late final GeneratedColumn<int> playtimeMinutes = GeneratedColumn<int>(
    'playtime_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _recentMinutesMeta = const VerificationMeta(
    'recentMinutes',
  );
  @override
  late final GeneratedColumn<int> recentMinutes = GeneratedColumn<int>(
    'recent_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _achievementsUnlockedMeta =
      const VerificationMeta('achievementsUnlocked');
  @override
  late final GeneratedColumn<int> achievementsUnlocked = GeneratedColumn<int>(
    'achievements_unlocked',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _achievementsTotalMeta = const VerificationMeta(
    'achievementsTotal',
  );
  @override
  late final GeneratedColumn<int> achievementsTotal = GeneratedColumn<int>(
    'achievements_total',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _achievementsCheckedAtMeta =
      const VerificationMeta('achievementsCheckedAt');
  @override
  late final GeneratedColumn<DateTime> achievementsCheckedAt =
      GeneratedColumn<DateTime>(
        'achievements_checked_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deckStatusMeta = const VerificationMeta(
    'deckStatus',
  );
  @override
  late final GeneratedColumn<String> deckStatus = GeneratedColumn<String>(
    'deck_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deckCheckedAtMeta = const VerificationMeta(
    'deckCheckedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deckCheckedAt =
      GeneratedColumn<DateTime>(
        'deck_checked_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _autoProgressStatusMeta =
      const VerificationMeta('autoProgressStatus');
  @override
  late final GeneratedColumn<String> autoProgressStatus =
      GeneratedColumn<String>(
        'auto_progress_status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceCurrencyMeta = const VerificationMeta(
    'priceCurrency',
  );
  @override
  late final GeneratedColumn<String> priceCurrency = GeneratedColumn<String>(
    'price_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricedAtMeta = const VerificationMeta(
    'pricedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pricedAt = GeneratedColumn<DateTime>(
    'priced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    appId,
    playtimeMinutes,
    recentMinutes,
    lastPlayedAt,
    achievementsUnlocked,
    achievementsTotal,
    achievementsCheckedAt,
    deckStatus,
    deckCheckedAt,
    autoProgressStatus,
    priceCents,
    priceCurrency,
    pricedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'steam_game_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<SteamGameStatsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
        _appIdMeta,
        appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta),
      );
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('playtime_minutes')) {
      context.handle(
        _playtimeMinutesMeta,
        playtimeMinutes.isAcceptableOrUnknown(
          data['playtime_minutes']!,
          _playtimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('recent_minutes')) {
      context.handle(
        _recentMinutesMeta,
        recentMinutes.isAcceptableOrUnknown(
          data['recent_minutes']!,
          _recentMinutesMeta,
        ),
      );
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    }
    if (data.containsKey('achievements_unlocked')) {
      context.handle(
        _achievementsUnlockedMeta,
        achievementsUnlocked.isAcceptableOrUnknown(
          data['achievements_unlocked']!,
          _achievementsUnlockedMeta,
        ),
      );
    }
    if (data.containsKey('achievements_total')) {
      context.handle(
        _achievementsTotalMeta,
        achievementsTotal.isAcceptableOrUnknown(
          data['achievements_total']!,
          _achievementsTotalMeta,
        ),
      );
    }
    if (data.containsKey('achievements_checked_at')) {
      context.handle(
        _achievementsCheckedAtMeta,
        achievementsCheckedAt.isAcceptableOrUnknown(
          data['achievements_checked_at']!,
          _achievementsCheckedAtMeta,
        ),
      );
    }
    if (data.containsKey('deck_status')) {
      context.handle(
        _deckStatusMeta,
        deckStatus.isAcceptableOrUnknown(data['deck_status']!, _deckStatusMeta),
      );
    }
    if (data.containsKey('deck_checked_at')) {
      context.handle(
        _deckCheckedAtMeta,
        deckCheckedAt.isAcceptableOrUnknown(
          data['deck_checked_at']!,
          _deckCheckedAtMeta,
        ),
      );
    }
    if (data.containsKey('auto_progress_status')) {
      context.handle(
        _autoProgressStatusMeta,
        autoProgressStatus.isAcceptableOrUnknown(
          data['auto_progress_status']!,
          _autoProgressStatusMeta,
        ),
      );
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    }
    if (data.containsKey('price_currency')) {
      context.handle(
        _priceCurrencyMeta,
        priceCurrency.isAcceptableOrUnknown(
          data['price_currency']!,
          _priceCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('priced_at')) {
      context.handle(
        _pricedAtMeta,
        pricedAt.isAcceptableOrUnknown(data['priced_at']!, _pricedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  SteamGameStatsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SteamGameStatsRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      appId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_id'],
      )!,
      playtimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}playtime_minutes'],
      )!,
      recentMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recent_minutes'],
      )!,
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_at'],
      ),
      achievementsUnlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}achievements_unlocked'],
      ),
      achievementsTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}achievements_total'],
      ),
      achievementsCheckedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achievements_checked_at'],
      ),
      deckStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_status'],
      ),
      deckCheckedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deck_checked_at'],
      ),
      autoProgressStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auto_progress_status'],
      ),
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      ),
      priceCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_currency'],
      ),
      pricedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}priced_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $SteamGameStatsTable createAlias(String alias) {
    return $SteamGameStatsTable(attachedDatabase, alias);
  }
}

class SteamGameStatsRow extends DataClass
    implements Insertable<SteamGameStatsRow> {
  final String itemId;
  final String appId;
  final int playtimeMinutes;
  final int recentMinutes;
  final DateTime? lastPlayedAt;
  final int? achievementsUnlocked;
  final int? achievementsTotal;
  final DateTime? achievementsCheckedAt;
  final String? deckStatus;
  final DateTime? deckCheckedAt;
  final String? autoProgressStatus;
  final int? priceCents;
  final String? priceCurrency;
  final DateTime? pricedAt;
  final DateTime syncedAt;
  const SteamGameStatsRow({
    required this.itemId,
    required this.appId,
    required this.playtimeMinutes,
    required this.recentMinutes,
    this.lastPlayedAt,
    this.achievementsUnlocked,
    this.achievementsTotal,
    this.achievementsCheckedAt,
    this.deckStatus,
    this.deckCheckedAt,
    this.autoProgressStatus,
    this.priceCents,
    this.priceCurrency,
    this.pricedAt,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['app_id'] = Variable<String>(appId);
    map['playtime_minutes'] = Variable<int>(playtimeMinutes);
    map['recent_minutes'] = Variable<int>(recentMinutes);
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    }
    if (!nullToAbsent || achievementsUnlocked != null) {
      map['achievements_unlocked'] = Variable<int>(achievementsUnlocked);
    }
    if (!nullToAbsent || achievementsTotal != null) {
      map['achievements_total'] = Variable<int>(achievementsTotal);
    }
    if (!nullToAbsent || achievementsCheckedAt != null) {
      map['achievements_checked_at'] = Variable<DateTime>(
        achievementsCheckedAt,
      );
    }
    if (!nullToAbsent || deckStatus != null) {
      map['deck_status'] = Variable<String>(deckStatus);
    }
    if (!nullToAbsent || deckCheckedAt != null) {
      map['deck_checked_at'] = Variable<DateTime>(deckCheckedAt);
    }
    if (!nullToAbsent || autoProgressStatus != null) {
      map['auto_progress_status'] = Variable<String>(autoProgressStatus);
    }
    if (!nullToAbsent || priceCents != null) {
      map['price_cents'] = Variable<int>(priceCents);
    }
    if (!nullToAbsent || priceCurrency != null) {
      map['price_currency'] = Variable<String>(priceCurrency);
    }
    if (!nullToAbsent || pricedAt != null) {
      map['priced_at'] = Variable<DateTime>(pricedAt);
    }
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  SteamGameStatsCompanion toCompanion(bool nullToAbsent) {
    return SteamGameStatsCompanion(
      itemId: Value(itemId),
      appId: Value(appId),
      playtimeMinutes: Value(playtimeMinutes),
      recentMinutes: Value(recentMinutes),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedAt),
      achievementsUnlocked: achievementsUnlocked == null && nullToAbsent
          ? const Value.absent()
          : Value(achievementsUnlocked),
      achievementsTotal: achievementsTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(achievementsTotal),
      achievementsCheckedAt: achievementsCheckedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(achievementsCheckedAt),
      deckStatus: deckStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(deckStatus),
      deckCheckedAt: deckCheckedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deckCheckedAt),
      autoProgressStatus: autoProgressStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(autoProgressStatus),
      priceCents: priceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(priceCents),
      priceCurrency: priceCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(priceCurrency),
      pricedAt: pricedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pricedAt),
      syncedAt: Value(syncedAt),
    );
  }

  factory SteamGameStatsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SteamGameStatsRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      appId: serializer.fromJson<String>(json['appId']),
      playtimeMinutes: serializer.fromJson<int>(json['playtimeMinutes']),
      recentMinutes: serializer.fromJson<int>(json['recentMinutes']),
      lastPlayedAt: serializer.fromJson<DateTime?>(json['lastPlayedAt']),
      achievementsUnlocked: serializer.fromJson<int?>(
        json['achievementsUnlocked'],
      ),
      achievementsTotal: serializer.fromJson<int?>(json['achievementsTotal']),
      achievementsCheckedAt: serializer.fromJson<DateTime?>(
        json['achievementsCheckedAt'],
      ),
      deckStatus: serializer.fromJson<String?>(json['deckStatus']),
      deckCheckedAt: serializer.fromJson<DateTime?>(json['deckCheckedAt']),
      autoProgressStatus: serializer.fromJson<String?>(
        json['autoProgressStatus'],
      ),
      priceCents: serializer.fromJson<int?>(json['priceCents']),
      priceCurrency: serializer.fromJson<String?>(json['priceCurrency']),
      pricedAt: serializer.fromJson<DateTime?>(json['pricedAt']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'appId': serializer.toJson<String>(appId),
      'playtimeMinutes': serializer.toJson<int>(playtimeMinutes),
      'recentMinutes': serializer.toJson<int>(recentMinutes),
      'lastPlayedAt': serializer.toJson<DateTime?>(lastPlayedAt),
      'achievementsUnlocked': serializer.toJson<int?>(achievementsUnlocked),
      'achievementsTotal': serializer.toJson<int?>(achievementsTotal),
      'achievementsCheckedAt': serializer.toJson<DateTime?>(
        achievementsCheckedAt,
      ),
      'deckStatus': serializer.toJson<String?>(deckStatus),
      'deckCheckedAt': serializer.toJson<DateTime?>(deckCheckedAt),
      'autoProgressStatus': serializer.toJson<String?>(autoProgressStatus),
      'priceCents': serializer.toJson<int?>(priceCents),
      'priceCurrency': serializer.toJson<String?>(priceCurrency),
      'pricedAt': serializer.toJson<DateTime?>(pricedAt),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  SteamGameStatsRow copyWith({
    String? itemId,
    String? appId,
    int? playtimeMinutes,
    int? recentMinutes,
    Value<DateTime?> lastPlayedAt = const Value.absent(),
    Value<int?> achievementsUnlocked = const Value.absent(),
    Value<int?> achievementsTotal = const Value.absent(),
    Value<DateTime?> achievementsCheckedAt = const Value.absent(),
    Value<String?> deckStatus = const Value.absent(),
    Value<DateTime?> deckCheckedAt = const Value.absent(),
    Value<String?> autoProgressStatus = const Value.absent(),
    Value<int?> priceCents = const Value.absent(),
    Value<String?> priceCurrency = const Value.absent(),
    Value<DateTime?> pricedAt = const Value.absent(),
    DateTime? syncedAt,
  }) => SteamGameStatsRow(
    itemId: itemId ?? this.itemId,
    appId: appId ?? this.appId,
    playtimeMinutes: playtimeMinutes ?? this.playtimeMinutes,
    recentMinutes: recentMinutes ?? this.recentMinutes,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
    achievementsUnlocked: achievementsUnlocked.present
        ? achievementsUnlocked.value
        : this.achievementsUnlocked,
    achievementsTotal: achievementsTotal.present
        ? achievementsTotal.value
        : this.achievementsTotal,
    achievementsCheckedAt: achievementsCheckedAt.present
        ? achievementsCheckedAt.value
        : this.achievementsCheckedAt,
    deckStatus: deckStatus.present ? deckStatus.value : this.deckStatus,
    deckCheckedAt: deckCheckedAt.present
        ? deckCheckedAt.value
        : this.deckCheckedAt,
    autoProgressStatus: autoProgressStatus.present
        ? autoProgressStatus.value
        : this.autoProgressStatus,
    priceCents: priceCents.present ? priceCents.value : this.priceCents,
    priceCurrency: priceCurrency.present
        ? priceCurrency.value
        : this.priceCurrency,
    pricedAt: pricedAt.present ? pricedAt.value : this.pricedAt,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  SteamGameStatsRow copyWithCompanion(SteamGameStatsCompanion data) {
    return SteamGameStatsRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      appId: data.appId.present ? data.appId.value : this.appId,
      playtimeMinutes: data.playtimeMinutes.present
          ? data.playtimeMinutes.value
          : this.playtimeMinutes,
      recentMinutes: data.recentMinutes.present
          ? data.recentMinutes.value
          : this.recentMinutes,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
      achievementsUnlocked: data.achievementsUnlocked.present
          ? data.achievementsUnlocked.value
          : this.achievementsUnlocked,
      achievementsTotal: data.achievementsTotal.present
          ? data.achievementsTotal.value
          : this.achievementsTotal,
      achievementsCheckedAt: data.achievementsCheckedAt.present
          ? data.achievementsCheckedAt.value
          : this.achievementsCheckedAt,
      deckStatus: data.deckStatus.present
          ? data.deckStatus.value
          : this.deckStatus,
      deckCheckedAt: data.deckCheckedAt.present
          ? data.deckCheckedAt.value
          : this.deckCheckedAt,
      autoProgressStatus: data.autoProgressStatus.present
          ? data.autoProgressStatus.value
          : this.autoProgressStatus,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      priceCurrency: data.priceCurrency.present
          ? data.priceCurrency.value
          : this.priceCurrency,
      pricedAt: data.pricedAt.present ? data.pricedAt.value : this.pricedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SteamGameStatsRow(')
          ..write('itemId: $itemId, ')
          ..write('appId: $appId, ')
          ..write('playtimeMinutes: $playtimeMinutes, ')
          ..write('recentMinutes: $recentMinutes, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('achievementsUnlocked: $achievementsUnlocked, ')
          ..write('achievementsTotal: $achievementsTotal, ')
          ..write('achievementsCheckedAt: $achievementsCheckedAt, ')
          ..write('deckStatus: $deckStatus, ')
          ..write('deckCheckedAt: $deckCheckedAt, ')
          ..write('autoProgressStatus: $autoProgressStatus, ')
          ..write('priceCents: $priceCents, ')
          ..write('priceCurrency: $priceCurrency, ')
          ..write('pricedAt: $pricedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    appId,
    playtimeMinutes,
    recentMinutes,
    lastPlayedAt,
    achievementsUnlocked,
    achievementsTotal,
    achievementsCheckedAt,
    deckStatus,
    deckCheckedAt,
    autoProgressStatus,
    priceCents,
    priceCurrency,
    pricedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SteamGameStatsRow &&
          other.itemId == this.itemId &&
          other.appId == this.appId &&
          other.playtimeMinutes == this.playtimeMinutes &&
          other.recentMinutes == this.recentMinutes &&
          other.lastPlayedAt == this.lastPlayedAt &&
          other.achievementsUnlocked == this.achievementsUnlocked &&
          other.achievementsTotal == this.achievementsTotal &&
          other.achievementsCheckedAt == this.achievementsCheckedAt &&
          other.deckStatus == this.deckStatus &&
          other.deckCheckedAt == this.deckCheckedAt &&
          other.autoProgressStatus == this.autoProgressStatus &&
          other.priceCents == this.priceCents &&
          other.priceCurrency == this.priceCurrency &&
          other.pricedAt == this.pricedAt &&
          other.syncedAt == this.syncedAt);
}

class SteamGameStatsCompanion extends UpdateCompanion<SteamGameStatsRow> {
  final Value<String> itemId;
  final Value<String> appId;
  final Value<int> playtimeMinutes;
  final Value<int> recentMinutes;
  final Value<DateTime?> lastPlayedAt;
  final Value<int?> achievementsUnlocked;
  final Value<int?> achievementsTotal;
  final Value<DateTime?> achievementsCheckedAt;
  final Value<String?> deckStatus;
  final Value<DateTime?> deckCheckedAt;
  final Value<String?> autoProgressStatus;
  final Value<int?> priceCents;
  final Value<String?> priceCurrency;
  final Value<DateTime?> pricedAt;
  final Value<DateTime> syncedAt;
  final Value<int> rowid;
  const SteamGameStatsCompanion({
    this.itemId = const Value.absent(),
    this.appId = const Value.absent(),
    this.playtimeMinutes = const Value.absent(),
    this.recentMinutes = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.achievementsUnlocked = const Value.absent(),
    this.achievementsTotal = const Value.absent(),
    this.achievementsCheckedAt = const Value.absent(),
    this.deckStatus = const Value.absent(),
    this.deckCheckedAt = const Value.absent(),
    this.autoProgressStatus = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.priceCurrency = const Value.absent(),
    this.pricedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SteamGameStatsCompanion.insert({
    required String itemId,
    required String appId,
    this.playtimeMinutes = const Value.absent(),
    this.recentMinutes = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.achievementsUnlocked = const Value.absent(),
    this.achievementsTotal = const Value.absent(),
    this.achievementsCheckedAt = const Value.absent(),
    this.deckStatus = const Value.absent(),
    this.deckCheckedAt = const Value.absent(),
    this.autoProgressStatus = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.priceCurrency = const Value.absent(),
    this.pricedAt = const Value.absent(),
    required DateTime syncedAt,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       appId = Value(appId),
       syncedAt = Value(syncedAt);
  static Insertable<SteamGameStatsRow> custom({
    Expression<String>? itemId,
    Expression<String>? appId,
    Expression<int>? playtimeMinutes,
    Expression<int>? recentMinutes,
    Expression<DateTime>? lastPlayedAt,
    Expression<int>? achievementsUnlocked,
    Expression<int>? achievementsTotal,
    Expression<DateTime>? achievementsCheckedAt,
    Expression<String>? deckStatus,
    Expression<DateTime>? deckCheckedAt,
    Expression<String>? autoProgressStatus,
    Expression<int>? priceCents,
    Expression<String>? priceCurrency,
    Expression<DateTime>? pricedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (appId != null) 'app_id': appId,
      if (playtimeMinutes != null) 'playtime_minutes': playtimeMinutes,
      if (recentMinutes != null) 'recent_minutes': recentMinutes,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (achievementsUnlocked != null)
        'achievements_unlocked': achievementsUnlocked,
      if (achievementsTotal != null) 'achievements_total': achievementsTotal,
      if (achievementsCheckedAt != null)
        'achievements_checked_at': achievementsCheckedAt,
      if (deckStatus != null) 'deck_status': deckStatus,
      if (deckCheckedAt != null) 'deck_checked_at': deckCheckedAt,
      if (autoProgressStatus != null)
        'auto_progress_status': autoProgressStatus,
      if (priceCents != null) 'price_cents': priceCents,
      if (priceCurrency != null) 'price_currency': priceCurrency,
      if (pricedAt != null) 'priced_at': pricedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SteamGameStatsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? appId,
    Value<int>? playtimeMinutes,
    Value<int>? recentMinutes,
    Value<DateTime?>? lastPlayedAt,
    Value<int?>? achievementsUnlocked,
    Value<int?>? achievementsTotal,
    Value<DateTime?>? achievementsCheckedAt,
    Value<String?>? deckStatus,
    Value<DateTime?>? deckCheckedAt,
    Value<String?>? autoProgressStatus,
    Value<int?>? priceCents,
    Value<String?>? priceCurrency,
    Value<DateTime?>? pricedAt,
    Value<DateTime>? syncedAt,
    Value<int>? rowid,
  }) {
    return SteamGameStatsCompanion(
      itemId: itemId ?? this.itemId,
      appId: appId ?? this.appId,
      playtimeMinutes: playtimeMinutes ?? this.playtimeMinutes,
      recentMinutes: recentMinutes ?? this.recentMinutes,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      achievementsUnlocked: achievementsUnlocked ?? this.achievementsUnlocked,
      achievementsTotal: achievementsTotal ?? this.achievementsTotal,
      achievementsCheckedAt:
          achievementsCheckedAt ?? this.achievementsCheckedAt,
      deckStatus: deckStatus ?? this.deckStatus,
      deckCheckedAt: deckCheckedAt ?? this.deckCheckedAt,
      autoProgressStatus: autoProgressStatus ?? this.autoProgressStatus,
      priceCents: priceCents ?? this.priceCents,
      priceCurrency: priceCurrency ?? this.priceCurrency,
      pricedAt: pricedAt ?? this.pricedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (playtimeMinutes.present) {
      map['playtime_minutes'] = Variable<int>(playtimeMinutes.value);
    }
    if (recentMinutes.present) {
      map['recent_minutes'] = Variable<int>(recentMinutes.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    if (achievementsUnlocked.present) {
      map['achievements_unlocked'] = Variable<int>(achievementsUnlocked.value);
    }
    if (achievementsTotal.present) {
      map['achievements_total'] = Variable<int>(achievementsTotal.value);
    }
    if (achievementsCheckedAt.present) {
      map['achievements_checked_at'] = Variable<DateTime>(
        achievementsCheckedAt.value,
      );
    }
    if (deckStatus.present) {
      map['deck_status'] = Variable<String>(deckStatus.value);
    }
    if (deckCheckedAt.present) {
      map['deck_checked_at'] = Variable<DateTime>(deckCheckedAt.value);
    }
    if (autoProgressStatus.present) {
      map['auto_progress_status'] = Variable<String>(autoProgressStatus.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (priceCurrency.present) {
      map['price_currency'] = Variable<String>(priceCurrency.value);
    }
    if (pricedAt.present) {
      map['priced_at'] = Variable<DateTime>(pricedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SteamGameStatsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('appId: $appId, ')
          ..write('playtimeMinutes: $playtimeMinutes, ')
          ..write('recentMinutes: $recentMinutes, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('achievementsUnlocked: $achievementsUnlocked, ')
          ..write('achievementsTotal: $achievementsTotal, ')
          ..write('achievementsCheckedAt: $achievementsCheckedAt, ')
          ..write('deckStatus: $deckStatus, ')
          ..write('deckCheckedAt: $deckCheckedAt, ')
          ..write('autoProgressStatus: $autoProgressStatus, ')
          ..write('priceCents: $priceCents, ')
          ..write('priceCurrency: $priceCurrency, ')
          ..write('pricedAt: $pricedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, SaleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titlesMeta = const VerificationMeta('titles');
  @override
  late final GeneratedColumn<String> titles = GeneratedColumn<String>(
    'titles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalLanguageMeta = const VerificationMeta(
    'originalLanguage',
  );
  @override
  late final GeneratedColumn<String> originalLanguage = GeneratedColumn<String>(
    'original_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editionMeta = const VerificationMeta(
    'edition',
  );
  @override
  late final GeneratedColumn<String> edition = GeneratedColumn<String>(
    'edition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wasOpenedMeta = const VerificationMeta(
    'wasOpened',
  );
  @override
  late final GeneratedColumn<bool> wasOpened = GeneratedColumn<bool>(
    'was_opened',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("was_opened" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _purchasePriceCentsMeta =
      const VerificationMeta('purchasePriceCents');
  @override
  late final GeneratedColumn<int> purchasePriceCents = GeneratedColumn<int>(
    'purchase_price_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasedOnMeta = const VerificationMeta(
    'purchasedOn',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedOn = GeneratedColumn<DateTime>(
    'purchased_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseChannelMeta = const VerificationMeta(
    'purchaseChannel',
  );
  @override
  late final GeneratedColumn<String> purchaseChannel = GeneratedColumn<String>(
    'purchase_channel',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salePriceCentsMeta = const VerificationMeta(
    'salePriceCents',
  );
  @override
  late final GeneratedColumn<int> salePriceCents = GeneratedColumn<int>(
    'sale_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soldOnMeta = const VerificationMeta('soldOn');
  @override
  late final GeneratedColumn<DateTime> soldOn = GeneratedColumn<DateTime>(
    'sold_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleChannelMeta = const VerificationMeta(
    'saleChannel',
  );
  @override
  late final GeneratedColumn<String> saleChannel = GeneratedColumn<String>(
    'sale_channel',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    categoryId,
    titles,
    originalLanguage,
    edition,
    wasOpened,
    purchasePriceCents,
    purchasedOn,
    purchaseChannel,
    salePriceCents,
    soldOn,
    saleChannel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('titles')) {
      context.handle(
        _titlesMeta,
        titles.isAcceptableOrUnknown(data['titles']!, _titlesMeta),
      );
    } else if (isInserting) {
      context.missing(_titlesMeta);
    }
    if (data.containsKey('original_language')) {
      context.handle(
        _originalLanguageMeta,
        originalLanguage.isAcceptableOrUnknown(
          data['original_language']!,
          _originalLanguageMeta,
        ),
      );
    }
    if (data.containsKey('edition')) {
      context.handle(
        _editionMeta,
        edition.isAcceptableOrUnknown(data['edition']!, _editionMeta),
      );
    }
    if (data.containsKey('was_opened')) {
      context.handle(
        _wasOpenedMeta,
        wasOpened.isAcceptableOrUnknown(data['was_opened']!, _wasOpenedMeta),
      );
    }
    if (data.containsKey('purchase_price_cents')) {
      context.handle(
        _purchasePriceCentsMeta,
        purchasePriceCents.isAcceptableOrUnknown(
          data['purchase_price_cents']!,
          _purchasePriceCentsMeta,
        ),
      );
    }
    if (data.containsKey('purchased_on')) {
      context.handle(
        _purchasedOnMeta,
        purchasedOn.isAcceptableOrUnknown(
          data['purchased_on']!,
          _purchasedOnMeta,
        ),
      );
    }
    if (data.containsKey('purchase_channel')) {
      context.handle(
        _purchaseChannelMeta,
        purchaseChannel.isAcceptableOrUnknown(
          data['purchase_channel']!,
          _purchaseChannelMeta,
        ),
      );
    }
    if (data.containsKey('sale_price_cents')) {
      context.handle(
        _salePriceCentsMeta,
        salePriceCents.isAcceptableOrUnknown(
          data['sale_price_cents']!,
          _salePriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_salePriceCentsMeta);
    }
    if (data.containsKey('sold_on')) {
      context.handle(
        _soldOnMeta,
        soldOn.isAcceptableOrUnknown(data['sold_on']!, _soldOnMeta),
      );
    } else if (isInserting) {
      context.missing(_soldOnMeta);
    }
    if (data.containsKey('sale_channel')) {
      context.handle(
        _saleChannelMeta,
        saleChannel.isAcceptableOrUnknown(
          data['sale_channel']!,
          _saleChannelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      titles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titles'],
      )!,
      originalLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_language'],
      ),
      edition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition'],
      ),
      wasOpened: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}was_opened'],
      )!,
      purchasePriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price_cents'],
      ),
      purchasedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_on'],
      ),
      purchaseChannel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_channel'],
      ),
      salePriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_price_cents'],
      )!,
      soldOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sold_on'],
      )!,
      saleChannel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_channel'],
      ),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class SaleRow extends DataClass implements Insertable<SaleRow> {
  final String id;
  final String itemId;
  final String? categoryId;
  final String titles;
  final String? originalLanguage;
  final String? edition;
  final bool wasOpened;
  final int? purchasePriceCents;
  final DateTime? purchasedOn;
  final String? purchaseChannel;
  final int salePriceCents;
  final DateTime soldOn;
  final String? saleChannel;
  const SaleRow({
    required this.id,
    required this.itemId,
    this.categoryId,
    required this.titles,
    this.originalLanguage,
    this.edition,
    required this.wasOpened,
    this.purchasePriceCents,
    this.purchasedOn,
    this.purchaseChannel,
    required this.salePriceCents,
    required this.soldOn,
    this.saleChannel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['titles'] = Variable<String>(titles);
    if (!nullToAbsent || originalLanguage != null) {
      map['original_language'] = Variable<String>(originalLanguage);
    }
    if (!nullToAbsent || edition != null) {
      map['edition'] = Variable<String>(edition);
    }
    map['was_opened'] = Variable<bool>(wasOpened);
    if (!nullToAbsent || purchasePriceCents != null) {
      map['purchase_price_cents'] = Variable<int>(purchasePriceCents);
    }
    if (!nullToAbsent || purchasedOn != null) {
      map['purchased_on'] = Variable<DateTime>(purchasedOn);
    }
    if (!nullToAbsent || purchaseChannel != null) {
      map['purchase_channel'] = Variable<String>(purchaseChannel);
    }
    map['sale_price_cents'] = Variable<int>(salePriceCents);
    map['sold_on'] = Variable<DateTime>(soldOn);
    if (!nullToAbsent || saleChannel != null) {
      map['sale_channel'] = Variable<String>(saleChannel);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      titles: Value(titles),
      originalLanguage: originalLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLanguage),
      edition: edition == null && nullToAbsent
          ? const Value.absent()
          : Value(edition),
      wasOpened: Value(wasOpened),
      purchasePriceCents: purchasePriceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePriceCents),
      purchasedOn: purchasedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasedOn),
      purchaseChannel: purchaseChannel == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseChannel),
      salePriceCents: Value(salePriceCents),
      soldOn: Value(soldOn),
      saleChannel: saleChannel == null && nullToAbsent
          ? const Value.absent()
          : Value(saleChannel),
    );
  }

  factory SaleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleRow(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      titles: serializer.fromJson<String>(json['titles']),
      originalLanguage: serializer.fromJson<String?>(json['originalLanguage']),
      edition: serializer.fromJson<String?>(json['edition']),
      wasOpened: serializer.fromJson<bool>(json['wasOpened']),
      purchasePriceCents: serializer.fromJson<int?>(json['purchasePriceCents']),
      purchasedOn: serializer.fromJson<DateTime?>(json['purchasedOn']),
      purchaseChannel: serializer.fromJson<String?>(json['purchaseChannel']),
      salePriceCents: serializer.fromJson<int>(json['salePriceCents']),
      soldOn: serializer.fromJson<DateTime>(json['soldOn']),
      saleChannel: serializer.fromJson<String?>(json['saleChannel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'titles': serializer.toJson<String>(titles),
      'originalLanguage': serializer.toJson<String?>(originalLanguage),
      'edition': serializer.toJson<String?>(edition),
      'wasOpened': serializer.toJson<bool>(wasOpened),
      'purchasePriceCents': serializer.toJson<int?>(purchasePriceCents),
      'purchasedOn': serializer.toJson<DateTime?>(purchasedOn),
      'purchaseChannel': serializer.toJson<String?>(purchaseChannel),
      'salePriceCents': serializer.toJson<int>(salePriceCents),
      'soldOn': serializer.toJson<DateTime>(soldOn),
      'saleChannel': serializer.toJson<String?>(saleChannel),
    };
  }

  SaleRow copyWith({
    String? id,
    String? itemId,
    Value<String?> categoryId = const Value.absent(),
    String? titles,
    Value<String?> originalLanguage = const Value.absent(),
    Value<String?> edition = const Value.absent(),
    bool? wasOpened,
    Value<int?> purchasePriceCents = const Value.absent(),
    Value<DateTime?> purchasedOn = const Value.absent(),
    Value<String?> purchaseChannel = const Value.absent(),
    int? salePriceCents,
    DateTime? soldOn,
    Value<String?> saleChannel = const Value.absent(),
  }) => SaleRow(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    titles: titles ?? this.titles,
    originalLanguage: originalLanguage.present
        ? originalLanguage.value
        : this.originalLanguage,
    edition: edition.present ? edition.value : this.edition,
    wasOpened: wasOpened ?? this.wasOpened,
    purchasePriceCents: purchasePriceCents.present
        ? purchasePriceCents.value
        : this.purchasePriceCents,
    purchasedOn: purchasedOn.present ? purchasedOn.value : this.purchasedOn,
    purchaseChannel: purchaseChannel.present
        ? purchaseChannel.value
        : this.purchaseChannel,
    salePriceCents: salePriceCents ?? this.salePriceCents,
    soldOn: soldOn ?? this.soldOn,
    saleChannel: saleChannel.present ? saleChannel.value : this.saleChannel,
  );
  SaleRow copyWithCompanion(SalesCompanion data) {
    return SaleRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      titles: data.titles.present ? data.titles.value : this.titles,
      originalLanguage: data.originalLanguage.present
          ? data.originalLanguage.value
          : this.originalLanguage,
      edition: data.edition.present ? data.edition.value : this.edition,
      wasOpened: data.wasOpened.present ? data.wasOpened.value : this.wasOpened,
      purchasePriceCents: data.purchasePriceCents.present
          ? data.purchasePriceCents.value
          : this.purchasePriceCents,
      purchasedOn: data.purchasedOn.present
          ? data.purchasedOn.value
          : this.purchasedOn,
      purchaseChannel: data.purchaseChannel.present
          ? data.purchaseChannel.value
          : this.purchaseChannel,
      salePriceCents: data.salePriceCents.present
          ? data.salePriceCents.value
          : this.salePriceCents,
      soldOn: data.soldOn.present ? data.soldOn.value : this.soldOn,
      saleChannel: data.saleChannel.present
          ? data.saleChannel.value
          : this.saleChannel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('categoryId: $categoryId, ')
          ..write('titles: $titles, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('edition: $edition, ')
          ..write('wasOpened: $wasOpened, ')
          ..write('purchasePriceCents: $purchasePriceCents, ')
          ..write('purchasedOn: $purchasedOn, ')
          ..write('purchaseChannel: $purchaseChannel, ')
          ..write('salePriceCents: $salePriceCents, ')
          ..write('soldOn: $soldOn, ')
          ..write('saleChannel: $saleChannel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    categoryId,
    titles,
    originalLanguage,
    edition,
    wasOpened,
    purchasePriceCents,
    purchasedOn,
    purchaseChannel,
    salePriceCents,
    soldOn,
    saleChannel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.categoryId == this.categoryId &&
          other.titles == this.titles &&
          other.originalLanguage == this.originalLanguage &&
          other.edition == this.edition &&
          other.wasOpened == this.wasOpened &&
          other.purchasePriceCents == this.purchasePriceCents &&
          other.purchasedOn == this.purchasedOn &&
          other.purchaseChannel == this.purchaseChannel &&
          other.salePriceCents == this.salePriceCents &&
          other.soldOn == this.soldOn &&
          other.saleChannel == this.saleChannel);
}

class SalesCompanion extends UpdateCompanion<SaleRow> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String?> categoryId;
  final Value<String> titles;
  final Value<String?> originalLanguage;
  final Value<String?> edition;
  final Value<bool> wasOpened;
  final Value<int?> purchasePriceCents;
  final Value<DateTime?> purchasedOn;
  final Value<String?> purchaseChannel;
  final Value<int> salePriceCents;
  final Value<DateTime> soldOn;
  final Value<String?> saleChannel;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.titles = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.edition = const Value.absent(),
    this.wasOpened = const Value.absent(),
    this.purchasePriceCents = const Value.absent(),
    this.purchasedOn = const Value.absent(),
    this.purchaseChannel = const Value.absent(),
    this.salePriceCents = const Value.absent(),
    this.soldOn = const Value.absent(),
    this.saleChannel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    required String itemId,
    this.categoryId = const Value.absent(),
    required String titles,
    this.originalLanguage = const Value.absent(),
    this.edition = const Value.absent(),
    this.wasOpened = const Value.absent(),
    this.purchasePriceCents = const Value.absent(),
    this.purchasedOn = const Value.absent(),
    this.purchaseChannel = const Value.absent(),
    required int salePriceCents,
    required DateTime soldOn,
    this.saleChannel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemId = Value(itemId),
       titles = Value(titles),
       salePriceCents = Value(salePriceCents),
       soldOn = Value(soldOn);
  static Insertable<SaleRow> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? categoryId,
    Expression<String>? titles,
    Expression<String>? originalLanguage,
    Expression<String>? edition,
    Expression<bool>? wasOpened,
    Expression<int>? purchasePriceCents,
    Expression<DateTime>? purchasedOn,
    Expression<String>? purchaseChannel,
    Expression<int>? salePriceCents,
    Expression<DateTime>? soldOn,
    Expression<String>? saleChannel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (categoryId != null) 'category_id': categoryId,
      if (titles != null) 'titles': titles,
      if (originalLanguage != null) 'original_language': originalLanguage,
      if (edition != null) 'edition': edition,
      if (wasOpened != null) 'was_opened': wasOpened,
      if (purchasePriceCents != null)
        'purchase_price_cents': purchasePriceCents,
      if (purchasedOn != null) 'purchased_on': purchasedOn,
      if (purchaseChannel != null) 'purchase_channel': purchaseChannel,
      if (salePriceCents != null) 'sale_price_cents': salePriceCents,
      if (soldOn != null) 'sold_on': soldOn,
      if (saleChannel != null) 'sale_channel': saleChannel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? id,
    Value<String>? itemId,
    Value<String?>? categoryId,
    Value<String>? titles,
    Value<String?>? originalLanguage,
    Value<String?>? edition,
    Value<bool>? wasOpened,
    Value<int?>? purchasePriceCents,
    Value<DateTime?>? purchasedOn,
    Value<String?>? purchaseChannel,
    Value<int>? salePriceCents,
    Value<DateTime>? soldOn,
    Value<String?>? saleChannel,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      categoryId: categoryId ?? this.categoryId,
      titles: titles ?? this.titles,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      edition: edition ?? this.edition,
      wasOpened: wasOpened ?? this.wasOpened,
      purchasePriceCents: purchasePriceCents ?? this.purchasePriceCents,
      purchasedOn: purchasedOn ?? this.purchasedOn,
      purchaseChannel: purchaseChannel ?? this.purchaseChannel,
      salePriceCents: salePriceCents ?? this.salePriceCents,
      soldOn: soldOn ?? this.soldOn,
      saleChannel: saleChannel ?? this.saleChannel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (titles.present) {
      map['titles'] = Variable<String>(titles.value);
    }
    if (originalLanguage.present) {
      map['original_language'] = Variable<String>(originalLanguage.value);
    }
    if (edition.present) {
      map['edition'] = Variable<String>(edition.value);
    }
    if (wasOpened.present) {
      map['was_opened'] = Variable<bool>(wasOpened.value);
    }
    if (purchasePriceCents.present) {
      map['purchase_price_cents'] = Variable<int>(purchasePriceCents.value);
    }
    if (purchasedOn.present) {
      map['purchased_on'] = Variable<DateTime>(purchasedOn.value);
    }
    if (purchaseChannel.present) {
      map['purchase_channel'] = Variable<String>(purchaseChannel.value);
    }
    if (salePriceCents.present) {
      map['sale_price_cents'] = Variable<int>(salePriceCents.value);
    }
    if (soldOn.present) {
      map['sold_on'] = Variable<DateTime>(soldOn.value);
    }
    if (saleChannel.present) {
      map['sale_channel'] = Variable<String>(saleChannel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('categoryId: $categoryId, ')
          ..write('titles: $titles, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('edition: $edition, ')
          ..write('wasOpened: $wasOpened, ')
          ..write('purchasePriceCents: $purchasePriceCents, ')
          ..write('purchasedOn: $purchasedOn, ')
          ..write('purchaseChannel: $purchaseChannel, ')
          ..write('salePriceCents: $salePriceCents, ')
          ..write('soldOn: $soldOn, ')
          ..write('saleChannel: $saleChannel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SealedPricesTable extends SealedPrices
    with TableInfo<$SealedPricesTable, SealedPriceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SealedPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lowCentsMeta = const VerificationMeta(
    'lowCents',
  );
  @override
  late final GeneratedColumn<int> lowCents = GeneratedColumn<int>(
    'low_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _averageCentsMeta = const VerificationMeta(
    'averageCents',
  );
  @override
  late final GeneratedColumn<int> averageCents = GeneratedColumn<int>(
    'average_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trendCentsMeta = const VerificationMeta(
    'trendCents',
  );
  @override
  late final GeneratedColumn<int> trendCents = GeneratedColumn<int>(
    'trend_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _average1CentsMeta = const VerificationMeta(
    'average1Cents',
  );
  @override
  late final GeneratedColumn<int> average1Cents = GeneratedColumn<int>(
    'average1_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _average7CentsMeta = const VerificationMeta(
    'average7Cents',
  );
  @override
  late final GeneratedColumn<int> average7Cents = GeneratedColumn<int>(
    'average7_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _average30CentsMeta = const VerificationMeta(
    'average30Cents',
  );
  @override
  late final GeneratedColumn<int> average30Cents = GeneratedColumn<int>(
    'average30_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricedAtMeta = const VerificationMeta(
    'pricedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pricedAt = GeneratedColumn<DateTime>(
    'priced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    productId,
    lowCents,
    averageCents,
    trendCents,
    average1Cents,
    average7Cents,
    average30Cents,
    pricedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sealed_prices';
  @override
  VerificationContext validateIntegrity(
    Insertable<SealedPriceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('low_cents')) {
      context.handle(
        _lowCentsMeta,
        lowCents.isAcceptableOrUnknown(data['low_cents']!, _lowCentsMeta),
      );
    }
    if (data.containsKey('average_cents')) {
      context.handle(
        _averageCentsMeta,
        averageCents.isAcceptableOrUnknown(
          data['average_cents']!,
          _averageCentsMeta,
        ),
      );
    }
    if (data.containsKey('trend_cents')) {
      context.handle(
        _trendCentsMeta,
        trendCents.isAcceptableOrUnknown(data['trend_cents']!, _trendCentsMeta),
      );
    }
    if (data.containsKey('average1_cents')) {
      context.handle(
        _average1CentsMeta,
        average1Cents.isAcceptableOrUnknown(
          data['average1_cents']!,
          _average1CentsMeta,
        ),
      );
    }
    if (data.containsKey('average7_cents')) {
      context.handle(
        _average7CentsMeta,
        average7Cents.isAcceptableOrUnknown(
          data['average7_cents']!,
          _average7CentsMeta,
        ),
      );
    }
    if (data.containsKey('average30_cents')) {
      context.handle(
        _average30CentsMeta,
        average30Cents.isAcceptableOrUnknown(
          data['average30_cents']!,
          _average30CentsMeta,
        ),
      );
    }
    if (data.containsKey('priced_at')) {
      context.handle(
        _pricedAtMeta,
        pricedAt.isAcceptableOrUnknown(data['priced_at']!, _pricedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_pricedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  SealedPriceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SealedPriceRow(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      lowCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_cents'],
      ),
      averageCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_cents'],
      ),
      trendCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trend_cents'],
      ),
      average1Cents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average1_cents'],
      ),
      average7Cents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average7_cents'],
      ),
      average30Cents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average30_cents'],
      ),
      pricedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}priced_at'],
      )!,
    );
  }

  @override
  $SealedPricesTable createAlias(String alias) {
    return $SealedPricesTable(attachedDatabase, alias);
  }
}

class SealedPriceRow extends DataClass implements Insertable<SealedPriceRow> {
  final String productId;
  final int? lowCents;
  final int? averageCents;
  final int? trendCents;
  final int? average1Cents;
  final int? average7Cents;
  final int? average30Cents;
  final DateTime pricedAt;
  const SealedPriceRow({
    required this.productId,
    this.lowCents,
    this.averageCents,
    this.trendCents,
    this.average1Cents,
    this.average7Cents,
    this.average30Cents,
    required this.pricedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || lowCents != null) {
      map['low_cents'] = Variable<int>(lowCents);
    }
    if (!nullToAbsent || averageCents != null) {
      map['average_cents'] = Variable<int>(averageCents);
    }
    if (!nullToAbsent || trendCents != null) {
      map['trend_cents'] = Variable<int>(trendCents);
    }
    if (!nullToAbsent || average1Cents != null) {
      map['average1_cents'] = Variable<int>(average1Cents);
    }
    if (!nullToAbsent || average7Cents != null) {
      map['average7_cents'] = Variable<int>(average7Cents);
    }
    if (!nullToAbsent || average30Cents != null) {
      map['average30_cents'] = Variable<int>(average30Cents);
    }
    map['priced_at'] = Variable<DateTime>(pricedAt);
    return map;
  }

  SealedPricesCompanion toCompanion(bool nullToAbsent) {
    return SealedPricesCompanion(
      productId: Value(productId),
      lowCents: lowCents == null && nullToAbsent
          ? const Value.absent()
          : Value(lowCents),
      averageCents: averageCents == null && nullToAbsent
          ? const Value.absent()
          : Value(averageCents),
      trendCents: trendCents == null && nullToAbsent
          ? const Value.absent()
          : Value(trendCents),
      average1Cents: average1Cents == null && nullToAbsent
          ? const Value.absent()
          : Value(average1Cents),
      average7Cents: average7Cents == null && nullToAbsent
          ? const Value.absent()
          : Value(average7Cents),
      average30Cents: average30Cents == null && nullToAbsent
          ? const Value.absent()
          : Value(average30Cents),
      pricedAt: Value(pricedAt),
    );
  }

  factory SealedPriceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SealedPriceRow(
      productId: serializer.fromJson<String>(json['productId']),
      lowCents: serializer.fromJson<int?>(json['lowCents']),
      averageCents: serializer.fromJson<int?>(json['averageCents']),
      trendCents: serializer.fromJson<int?>(json['trendCents']),
      average1Cents: serializer.fromJson<int?>(json['average1Cents']),
      average7Cents: serializer.fromJson<int?>(json['average7Cents']),
      average30Cents: serializer.fromJson<int?>(json['average30Cents']),
      pricedAt: serializer.fromJson<DateTime>(json['pricedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<String>(productId),
      'lowCents': serializer.toJson<int?>(lowCents),
      'averageCents': serializer.toJson<int?>(averageCents),
      'trendCents': serializer.toJson<int?>(trendCents),
      'average1Cents': serializer.toJson<int?>(average1Cents),
      'average7Cents': serializer.toJson<int?>(average7Cents),
      'average30Cents': serializer.toJson<int?>(average30Cents),
      'pricedAt': serializer.toJson<DateTime>(pricedAt),
    };
  }

  SealedPriceRow copyWith({
    String? productId,
    Value<int?> lowCents = const Value.absent(),
    Value<int?> averageCents = const Value.absent(),
    Value<int?> trendCents = const Value.absent(),
    Value<int?> average1Cents = const Value.absent(),
    Value<int?> average7Cents = const Value.absent(),
    Value<int?> average30Cents = const Value.absent(),
    DateTime? pricedAt,
  }) => SealedPriceRow(
    productId: productId ?? this.productId,
    lowCents: lowCents.present ? lowCents.value : this.lowCents,
    averageCents: averageCents.present ? averageCents.value : this.averageCents,
    trendCents: trendCents.present ? trendCents.value : this.trendCents,
    average1Cents: average1Cents.present
        ? average1Cents.value
        : this.average1Cents,
    average7Cents: average7Cents.present
        ? average7Cents.value
        : this.average7Cents,
    average30Cents: average30Cents.present
        ? average30Cents.value
        : this.average30Cents,
    pricedAt: pricedAt ?? this.pricedAt,
  );
  SealedPriceRow copyWithCompanion(SealedPricesCompanion data) {
    return SealedPriceRow(
      productId: data.productId.present ? data.productId.value : this.productId,
      lowCents: data.lowCents.present ? data.lowCents.value : this.lowCents,
      averageCents: data.averageCents.present
          ? data.averageCents.value
          : this.averageCents,
      trendCents: data.trendCents.present
          ? data.trendCents.value
          : this.trendCents,
      average1Cents: data.average1Cents.present
          ? data.average1Cents.value
          : this.average1Cents,
      average7Cents: data.average7Cents.present
          ? data.average7Cents.value
          : this.average7Cents,
      average30Cents: data.average30Cents.present
          ? data.average30Cents.value
          : this.average30Cents,
      pricedAt: data.pricedAt.present ? data.pricedAt.value : this.pricedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SealedPriceRow(')
          ..write('productId: $productId, ')
          ..write('lowCents: $lowCents, ')
          ..write('averageCents: $averageCents, ')
          ..write('trendCents: $trendCents, ')
          ..write('average1Cents: $average1Cents, ')
          ..write('average7Cents: $average7Cents, ')
          ..write('average30Cents: $average30Cents, ')
          ..write('pricedAt: $pricedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productId,
    lowCents,
    averageCents,
    trendCents,
    average1Cents,
    average7Cents,
    average30Cents,
    pricedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SealedPriceRow &&
          other.productId == this.productId &&
          other.lowCents == this.lowCents &&
          other.averageCents == this.averageCents &&
          other.trendCents == this.trendCents &&
          other.average1Cents == this.average1Cents &&
          other.average7Cents == this.average7Cents &&
          other.average30Cents == this.average30Cents &&
          other.pricedAt == this.pricedAt);
}

class SealedPricesCompanion extends UpdateCompanion<SealedPriceRow> {
  final Value<String> productId;
  final Value<int?> lowCents;
  final Value<int?> averageCents;
  final Value<int?> trendCents;
  final Value<int?> average1Cents;
  final Value<int?> average7Cents;
  final Value<int?> average30Cents;
  final Value<DateTime> pricedAt;
  final Value<int> rowid;
  const SealedPricesCompanion({
    this.productId = const Value.absent(),
    this.lowCents = const Value.absent(),
    this.averageCents = const Value.absent(),
    this.trendCents = const Value.absent(),
    this.average1Cents = const Value.absent(),
    this.average7Cents = const Value.absent(),
    this.average30Cents = const Value.absent(),
    this.pricedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SealedPricesCompanion.insert({
    required String productId,
    this.lowCents = const Value.absent(),
    this.averageCents = const Value.absent(),
    this.trendCents = const Value.absent(),
    this.average1Cents = const Value.absent(),
    this.average7Cents = const Value.absent(),
    this.average30Cents = const Value.absent(),
    required DateTime pricedAt,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       pricedAt = Value(pricedAt);
  static Insertable<SealedPriceRow> custom({
    Expression<String>? productId,
    Expression<int>? lowCents,
    Expression<int>? averageCents,
    Expression<int>? trendCents,
    Expression<int>? average1Cents,
    Expression<int>? average7Cents,
    Expression<int>? average30Cents,
    Expression<DateTime>? pricedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (lowCents != null) 'low_cents': lowCents,
      if (averageCents != null) 'average_cents': averageCents,
      if (trendCents != null) 'trend_cents': trendCents,
      if (average1Cents != null) 'average1_cents': average1Cents,
      if (average7Cents != null) 'average7_cents': average7Cents,
      if (average30Cents != null) 'average30_cents': average30Cents,
      if (pricedAt != null) 'priced_at': pricedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SealedPricesCompanion copyWith({
    Value<String>? productId,
    Value<int?>? lowCents,
    Value<int?>? averageCents,
    Value<int?>? trendCents,
    Value<int?>? average1Cents,
    Value<int?>? average7Cents,
    Value<int?>? average30Cents,
    Value<DateTime>? pricedAt,
    Value<int>? rowid,
  }) {
    return SealedPricesCompanion(
      productId: productId ?? this.productId,
      lowCents: lowCents ?? this.lowCents,
      averageCents: averageCents ?? this.averageCents,
      trendCents: trendCents ?? this.trendCents,
      average1Cents: average1Cents ?? this.average1Cents,
      average7Cents: average7Cents ?? this.average7Cents,
      average30Cents: average30Cents ?? this.average30Cents,
      pricedAt: pricedAt ?? this.pricedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (lowCents.present) {
      map['low_cents'] = Variable<int>(lowCents.value);
    }
    if (averageCents.present) {
      map['average_cents'] = Variable<int>(averageCents.value);
    }
    if (trendCents.present) {
      map['trend_cents'] = Variable<int>(trendCents.value);
    }
    if (average1Cents.present) {
      map['average1_cents'] = Variable<int>(average1Cents.value);
    }
    if (average7Cents.present) {
      map['average7_cents'] = Variable<int>(average7Cents.value);
    }
    if (average30Cents.present) {
      map['average30_cents'] = Variable<int>(average30Cents.value);
    }
    if (pricedAt.present) {
      map['priced_at'] = Variable<DateTime>(pricedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SealedPricesCompanion(')
          ..write('productId: $productId, ')
          ..write('lowCents: $lowCents, ')
          ..write('averageCents: $averageCents, ')
          ..write('trendCents: $trendCents, ')
          ..write('average1Cents: $average1Cents, ')
          ..write('average7Cents: $average7Cents, ')
          ..write('average30Cents: $average30Cents, ')
          ..write('pricedAt: $pricedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SteamWatchesTable extends SteamWatches
    with TableInfo<$SteamWatchesTable, SteamWatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SteamWatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
    'app_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialPriceCentsMeta = const VerificationMeta(
    'initialPriceCents',
  );
  @override
  late final GeneratedColumn<int> initialPriceCents = GeneratedColumn<int>(
    'initial_price_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<int> discountPercent = GeneratedColumn<int>(
    'discount_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _priceCurrencyMeta = const VerificationMeta(
    'priceCurrency',
  );
  @override
  late final GeneratedColumn<String> priceCurrency = GeneratedColumn<String>(
    'price_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isComingSoonMeta = const VerificationMeta(
    'isComingSoon',
  );
  @override
  late final GeneratedColumn<bool> isComingSoon = GeneratedColumn<bool>(
    'is_coming_soon',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_coming_soon" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    appId,
    priceCents,
    initialPriceCents,
    discountPercent,
    priceCurrency,
    isComingSoon,
    checkedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'steam_watches';
  @override
  VerificationContext validateIntegrity(
    Insertable<SteamWatchRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('app_id')) {
      context.handle(
        _appIdMeta,
        appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta),
      );
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    }
    if (data.containsKey('initial_price_cents')) {
      context.handle(
        _initialPriceCentsMeta,
        initialPriceCents.isAcceptableOrUnknown(
          data['initial_price_cents']!,
          _initialPriceCentsMeta,
        ),
      );
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    if (data.containsKey('price_currency')) {
      context.handle(
        _priceCurrencyMeta,
        priceCurrency.isAcceptableOrUnknown(
          data['price_currency']!,
          _priceCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('is_coming_soon')) {
      context.handle(
        _isComingSoonMeta,
        isComingSoon.isAcceptableOrUnknown(
          data['is_coming_soon']!,
          _isComingSoonMeta,
        ),
      );
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_checkedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {appId};
  @override
  SteamWatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SteamWatchRow(
      appId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_id'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      ),
      initialPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_price_cents'],
      ),
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_percent'],
      )!,
      priceCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_currency'],
      ),
      isComingSoon: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_coming_soon'],
      )!,
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      )!,
    );
  }

  @override
  $SteamWatchesTable createAlias(String alias) {
    return $SteamWatchesTable(attachedDatabase, alias);
  }
}

class SteamWatchRow extends DataClass implements Insertable<SteamWatchRow> {
  final String appId;
  final int? priceCents;
  final int? initialPriceCents;
  final int discountPercent;
  final String? priceCurrency;
  final bool isComingSoon;
  final DateTime checkedAt;
  const SteamWatchRow({
    required this.appId,
    this.priceCents,
    this.initialPriceCents,
    required this.discountPercent,
    this.priceCurrency,
    required this.isComingSoon,
    required this.checkedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['app_id'] = Variable<String>(appId);
    if (!nullToAbsent || priceCents != null) {
      map['price_cents'] = Variable<int>(priceCents);
    }
    if (!nullToAbsent || initialPriceCents != null) {
      map['initial_price_cents'] = Variable<int>(initialPriceCents);
    }
    map['discount_percent'] = Variable<int>(discountPercent);
    if (!nullToAbsent || priceCurrency != null) {
      map['price_currency'] = Variable<String>(priceCurrency);
    }
    map['is_coming_soon'] = Variable<bool>(isComingSoon);
    map['checked_at'] = Variable<DateTime>(checkedAt);
    return map;
  }

  SteamWatchesCompanion toCompanion(bool nullToAbsent) {
    return SteamWatchesCompanion(
      appId: Value(appId),
      priceCents: priceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(priceCents),
      initialPriceCents: initialPriceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(initialPriceCents),
      discountPercent: Value(discountPercent),
      priceCurrency: priceCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(priceCurrency),
      isComingSoon: Value(isComingSoon),
      checkedAt: Value(checkedAt),
    );
  }

  factory SteamWatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SteamWatchRow(
      appId: serializer.fromJson<String>(json['appId']),
      priceCents: serializer.fromJson<int?>(json['priceCents']),
      initialPriceCents: serializer.fromJson<int?>(json['initialPriceCents']),
      discountPercent: serializer.fromJson<int>(json['discountPercent']),
      priceCurrency: serializer.fromJson<String?>(json['priceCurrency']),
      isComingSoon: serializer.fromJson<bool>(json['isComingSoon']),
      checkedAt: serializer.fromJson<DateTime>(json['checkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'appId': serializer.toJson<String>(appId),
      'priceCents': serializer.toJson<int?>(priceCents),
      'initialPriceCents': serializer.toJson<int?>(initialPriceCents),
      'discountPercent': serializer.toJson<int>(discountPercent),
      'priceCurrency': serializer.toJson<String?>(priceCurrency),
      'isComingSoon': serializer.toJson<bool>(isComingSoon),
      'checkedAt': serializer.toJson<DateTime>(checkedAt),
    };
  }

  SteamWatchRow copyWith({
    String? appId,
    Value<int?> priceCents = const Value.absent(),
    Value<int?> initialPriceCents = const Value.absent(),
    int? discountPercent,
    Value<String?> priceCurrency = const Value.absent(),
    bool? isComingSoon,
    DateTime? checkedAt,
  }) => SteamWatchRow(
    appId: appId ?? this.appId,
    priceCents: priceCents.present ? priceCents.value : this.priceCents,
    initialPriceCents: initialPriceCents.present
        ? initialPriceCents.value
        : this.initialPriceCents,
    discountPercent: discountPercent ?? this.discountPercent,
    priceCurrency: priceCurrency.present
        ? priceCurrency.value
        : this.priceCurrency,
    isComingSoon: isComingSoon ?? this.isComingSoon,
    checkedAt: checkedAt ?? this.checkedAt,
  );
  SteamWatchRow copyWithCompanion(SteamWatchesCompanion data) {
    return SteamWatchRow(
      appId: data.appId.present ? data.appId.value : this.appId,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      initialPriceCents: data.initialPriceCents.present
          ? data.initialPriceCents.value
          : this.initialPriceCents,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      priceCurrency: data.priceCurrency.present
          ? data.priceCurrency.value
          : this.priceCurrency,
      isComingSoon: data.isComingSoon.present
          ? data.isComingSoon.value
          : this.isComingSoon,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SteamWatchRow(')
          ..write('appId: $appId, ')
          ..write('priceCents: $priceCents, ')
          ..write('initialPriceCents: $initialPriceCents, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('priceCurrency: $priceCurrency, ')
          ..write('isComingSoon: $isComingSoon, ')
          ..write('checkedAt: $checkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    appId,
    priceCents,
    initialPriceCents,
    discountPercent,
    priceCurrency,
    isComingSoon,
    checkedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SteamWatchRow &&
          other.appId == this.appId &&
          other.priceCents == this.priceCents &&
          other.initialPriceCents == this.initialPriceCents &&
          other.discountPercent == this.discountPercent &&
          other.priceCurrency == this.priceCurrency &&
          other.isComingSoon == this.isComingSoon &&
          other.checkedAt == this.checkedAt);
}

class SteamWatchesCompanion extends UpdateCompanion<SteamWatchRow> {
  final Value<String> appId;
  final Value<int?> priceCents;
  final Value<int?> initialPriceCents;
  final Value<int> discountPercent;
  final Value<String?> priceCurrency;
  final Value<bool> isComingSoon;
  final Value<DateTime> checkedAt;
  final Value<int> rowid;
  const SteamWatchesCompanion({
    this.appId = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.initialPriceCents = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.priceCurrency = const Value.absent(),
    this.isComingSoon = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SteamWatchesCompanion.insert({
    required String appId,
    this.priceCents = const Value.absent(),
    this.initialPriceCents = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.priceCurrency = const Value.absent(),
    this.isComingSoon = const Value.absent(),
    required DateTime checkedAt,
    this.rowid = const Value.absent(),
  }) : appId = Value(appId),
       checkedAt = Value(checkedAt);
  static Insertable<SteamWatchRow> custom({
    Expression<String>? appId,
    Expression<int>? priceCents,
    Expression<int>? initialPriceCents,
    Expression<int>? discountPercent,
    Expression<String>? priceCurrency,
    Expression<bool>? isComingSoon,
    Expression<DateTime>? checkedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (appId != null) 'app_id': appId,
      if (priceCents != null) 'price_cents': priceCents,
      if (initialPriceCents != null) 'initial_price_cents': initialPriceCents,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (priceCurrency != null) 'price_currency': priceCurrency,
      if (isComingSoon != null) 'is_coming_soon': isComingSoon,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SteamWatchesCompanion copyWith({
    Value<String>? appId,
    Value<int?>? priceCents,
    Value<int?>? initialPriceCents,
    Value<int>? discountPercent,
    Value<String?>? priceCurrency,
    Value<bool>? isComingSoon,
    Value<DateTime>? checkedAt,
    Value<int>? rowid,
  }) {
    return SteamWatchesCompanion(
      appId: appId ?? this.appId,
      priceCents: priceCents ?? this.priceCents,
      initialPriceCents: initialPriceCents ?? this.initialPriceCents,
      discountPercent: discountPercent ?? this.discountPercent,
      priceCurrency: priceCurrency ?? this.priceCurrency,
      isComingSoon: isComingSoon ?? this.isComingSoon,
      checkedAt: checkedAt ?? this.checkedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (initialPriceCents.present) {
      map['initial_price_cents'] = Variable<int>(initialPriceCents.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<int>(discountPercent.value);
    }
    if (priceCurrency.present) {
      map['price_currency'] = Variable<String>(priceCurrency.value);
    }
    if (isComingSoon.present) {
      map['is_coming_soon'] = Variable<bool>(isComingSoon.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SteamWatchesCompanion(')
          ..write('appId: $appId, ')
          ..write('priceCents: $priceCents, ')
          ..write('initialPriceCents: $initialPriceCents, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('priceCurrency: $priceCurrency, ')
          ..write('isComingSoon: $isComingSoon, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SteamKnownDlcsTable extends SteamKnownDlcs
    with TableInfo<$SteamKnownDlcsTable, SteamKnownDlcsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SteamKnownDlcsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
    'app_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dlcIdsMeta = const VerificationMeta('dlcIds');
  @override
  late final GeneratedColumn<String> dlcIds = GeneratedColumn<String>(
    'dlc_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [appId, dlcIds, checkedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'steam_known_dlcs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SteamKnownDlcsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('app_id')) {
      context.handle(
        _appIdMeta,
        appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta),
      );
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('dlc_ids')) {
      context.handle(
        _dlcIdsMeta,
        dlcIds.isAcceptableOrUnknown(data['dlc_ids']!, _dlcIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_dlcIdsMeta);
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_checkedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {appId};
  @override
  SteamKnownDlcsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SteamKnownDlcsRow(
      appId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_id'],
      )!,
      dlcIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dlc_ids'],
      )!,
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      )!,
    );
  }

  @override
  $SteamKnownDlcsTable createAlias(String alias) {
    return $SteamKnownDlcsTable(attachedDatabase, alias);
  }
}

class SteamKnownDlcsRow extends DataClass
    implements Insertable<SteamKnownDlcsRow> {
  final String appId;
  final String dlcIds;
  final DateTime checkedAt;
  const SteamKnownDlcsRow({
    required this.appId,
    required this.dlcIds,
    required this.checkedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['app_id'] = Variable<String>(appId);
    map['dlc_ids'] = Variable<String>(dlcIds);
    map['checked_at'] = Variable<DateTime>(checkedAt);
    return map;
  }

  SteamKnownDlcsCompanion toCompanion(bool nullToAbsent) {
    return SteamKnownDlcsCompanion(
      appId: Value(appId),
      dlcIds: Value(dlcIds),
      checkedAt: Value(checkedAt),
    );
  }

  factory SteamKnownDlcsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SteamKnownDlcsRow(
      appId: serializer.fromJson<String>(json['appId']),
      dlcIds: serializer.fromJson<String>(json['dlcIds']),
      checkedAt: serializer.fromJson<DateTime>(json['checkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'appId': serializer.toJson<String>(appId),
      'dlcIds': serializer.toJson<String>(dlcIds),
      'checkedAt': serializer.toJson<DateTime>(checkedAt),
    };
  }

  SteamKnownDlcsRow copyWith({
    String? appId,
    String? dlcIds,
    DateTime? checkedAt,
  }) => SteamKnownDlcsRow(
    appId: appId ?? this.appId,
    dlcIds: dlcIds ?? this.dlcIds,
    checkedAt: checkedAt ?? this.checkedAt,
  );
  SteamKnownDlcsRow copyWithCompanion(SteamKnownDlcsCompanion data) {
    return SteamKnownDlcsRow(
      appId: data.appId.present ? data.appId.value : this.appId,
      dlcIds: data.dlcIds.present ? data.dlcIds.value : this.dlcIds,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SteamKnownDlcsRow(')
          ..write('appId: $appId, ')
          ..write('dlcIds: $dlcIds, ')
          ..write('checkedAt: $checkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(appId, dlcIds, checkedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SteamKnownDlcsRow &&
          other.appId == this.appId &&
          other.dlcIds == this.dlcIds &&
          other.checkedAt == this.checkedAt);
}

class SteamKnownDlcsCompanion extends UpdateCompanion<SteamKnownDlcsRow> {
  final Value<String> appId;
  final Value<String> dlcIds;
  final Value<DateTime> checkedAt;
  final Value<int> rowid;
  const SteamKnownDlcsCompanion({
    this.appId = const Value.absent(),
    this.dlcIds = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SteamKnownDlcsCompanion.insert({
    required String appId,
    required String dlcIds,
    required DateTime checkedAt,
    this.rowid = const Value.absent(),
  }) : appId = Value(appId),
       dlcIds = Value(dlcIds),
       checkedAt = Value(checkedAt);
  static Insertable<SteamKnownDlcsRow> custom({
    Expression<String>? appId,
    Expression<String>? dlcIds,
    Expression<DateTime>? checkedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (appId != null) 'app_id': appId,
      if (dlcIds != null) 'dlc_ids': dlcIds,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SteamKnownDlcsCompanion copyWith({
    Value<String>? appId,
    Value<String>? dlcIds,
    Value<DateTime>? checkedAt,
    Value<int>? rowid,
  }) {
    return SteamKnownDlcsCompanion(
      appId: appId ?? this.appId,
      dlcIds: dlcIds ?? this.dlcIds,
      checkedAt: checkedAt ?? this.checkedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (dlcIds.present) {
      map['dlc_ids'] = Variable<String>(dlcIds.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SteamKnownDlcsCompanion(')
          ..write('appId: $appId, ')
          ..write('dlcIds: $dlcIds, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceAlertsTable extends PriceAlerts
    with TableInfo<$PriceAlertsTable, PriceAlertRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceAlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _thresholdCentsMeta = const VerificationMeta(
    'thresholdCents',
  );
  @override
  late final GeneratedColumn<int> thresholdCents = GeneratedColumn<int>(
    'threshold_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAboveMeta = const VerificationMeta(
    'isAbove',
  );
  @override
  late final GeneratedColumn<bool> isAbove = GeneratedColumn<bool>(
    'is_above',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_above" IN (0, 1))',
    ),
  );
  static const VerificationMeta _notifiedAtMeta = const VerificationMeta(
    'notifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> notifiedAt = GeneratedColumn<DateTime>(
    'notified_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    thresholdCents,
    isAbove,
    notifiedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_alerts';
  @override
  VerificationContext validateIntegrity(
    Insertable<PriceAlertRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('threshold_cents')) {
      context.handle(
        _thresholdCentsMeta,
        thresholdCents.isAcceptableOrUnknown(
          data['threshold_cents']!,
          _thresholdCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thresholdCentsMeta);
    }
    if (data.containsKey('is_above')) {
      context.handle(
        _isAboveMeta,
        isAbove.isAcceptableOrUnknown(data['is_above']!, _isAboveMeta),
      );
    } else if (isInserting) {
      context.missing(_isAboveMeta);
    }
    if (data.containsKey('notified_at')) {
      context.handle(
        _notifiedAtMeta,
        notifiedAt.isAcceptableOrUnknown(data['notified_at']!, _notifiedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  PriceAlertRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceAlertRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      thresholdCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}threshold_cents'],
      )!,
      isAbove: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_above'],
      )!,
      notifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}notified_at'],
      ),
    );
  }

  @override
  $PriceAlertsTable createAlias(String alias) {
    return $PriceAlertsTable(attachedDatabase, alias);
  }
}

class PriceAlertRow extends DataClass implements Insertable<PriceAlertRow> {
  final String itemId;
  final int thresholdCents;
  final bool isAbove;
  final DateTime? notifiedAt;
  const PriceAlertRow({
    required this.itemId,
    required this.thresholdCents,
    required this.isAbove,
    this.notifiedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['threshold_cents'] = Variable<int>(thresholdCents);
    map['is_above'] = Variable<bool>(isAbove);
    if (!nullToAbsent || notifiedAt != null) {
      map['notified_at'] = Variable<DateTime>(notifiedAt);
    }
    return map;
  }

  PriceAlertsCompanion toCompanion(bool nullToAbsent) {
    return PriceAlertsCompanion(
      itemId: Value(itemId),
      thresholdCents: Value(thresholdCents),
      isAbove: Value(isAbove),
      notifiedAt: notifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(notifiedAt),
    );
  }

  factory PriceAlertRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceAlertRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      thresholdCents: serializer.fromJson<int>(json['thresholdCents']),
      isAbove: serializer.fromJson<bool>(json['isAbove']),
      notifiedAt: serializer.fromJson<DateTime?>(json['notifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'thresholdCents': serializer.toJson<int>(thresholdCents),
      'isAbove': serializer.toJson<bool>(isAbove),
      'notifiedAt': serializer.toJson<DateTime?>(notifiedAt),
    };
  }

  PriceAlertRow copyWith({
    String? itemId,
    int? thresholdCents,
    bool? isAbove,
    Value<DateTime?> notifiedAt = const Value.absent(),
  }) => PriceAlertRow(
    itemId: itemId ?? this.itemId,
    thresholdCents: thresholdCents ?? this.thresholdCents,
    isAbove: isAbove ?? this.isAbove,
    notifiedAt: notifiedAt.present ? notifiedAt.value : this.notifiedAt,
  );
  PriceAlertRow copyWithCompanion(PriceAlertsCompanion data) {
    return PriceAlertRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      thresholdCents: data.thresholdCents.present
          ? data.thresholdCents.value
          : this.thresholdCents,
      isAbove: data.isAbove.present ? data.isAbove.value : this.isAbove,
      notifiedAt: data.notifiedAt.present
          ? data.notifiedAt.value
          : this.notifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceAlertRow(')
          ..write('itemId: $itemId, ')
          ..write('thresholdCents: $thresholdCents, ')
          ..write('isAbove: $isAbove, ')
          ..write('notifiedAt: $notifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, thresholdCents, isAbove, notifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceAlertRow &&
          other.itemId == this.itemId &&
          other.thresholdCents == this.thresholdCents &&
          other.isAbove == this.isAbove &&
          other.notifiedAt == this.notifiedAt);
}

class PriceAlertsCompanion extends UpdateCompanion<PriceAlertRow> {
  final Value<String> itemId;
  final Value<int> thresholdCents;
  final Value<bool> isAbove;
  final Value<DateTime?> notifiedAt;
  final Value<int> rowid;
  const PriceAlertsCompanion({
    this.itemId = const Value.absent(),
    this.thresholdCents = const Value.absent(),
    this.isAbove = const Value.absent(),
    this.notifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceAlertsCompanion.insert({
    required String itemId,
    required int thresholdCents,
    required bool isAbove,
    this.notifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       thresholdCents = Value(thresholdCents),
       isAbove = Value(isAbove);
  static Insertable<PriceAlertRow> custom({
    Expression<String>? itemId,
    Expression<int>? thresholdCents,
    Expression<bool>? isAbove,
    Expression<DateTime>? notifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (thresholdCents != null) 'threshold_cents': thresholdCents,
      if (isAbove != null) 'is_above': isAbove,
      if (notifiedAt != null) 'notified_at': notifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceAlertsCompanion copyWith({
    Value<String>? itemId,
    Value<int>? thresholdCents,
    Value<bool>? isAbove,
    Value<DateTime?>? notifiedAt,
    Value<int>? rowid,
  }) {
    return PriceAlertsCompanion(
      itemId: itemId ?? this.itemId,
      thresholdCents: thresholdCents ?? this.thresholdCents,
      isAbove: isAbove ?? this.isAbove,
      notifiedAt: notifiedAt ?? this.notifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (thresholdCents.present) {
      map['threshold_cents'] = Variable<int>(thresholdCents.value);
    }
    if (isAbove.present) {
      map['is_above'] = Variable<bool>(isAbove.value);
    }
    if (notifiedAt.present) {
      map['notified_at'] = Variable<DateTime>(notifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceAlertsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('thresholdCents: $thresholdCents, ')
          ..write('isAbove: $isAbove, ')
          ..write('notifiedAt: $notifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ValueSnapshotsTable extends ValueSnapshots
    with TableInfo<$ValueSnapshotsTable, ValueSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ValueSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalsMeta = const VerificationMeta('totals');
  @override
  late final GeneratedColumn<String> totals = GeneratedColumn<String>(
    'totals',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [month, totals, takenAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'value_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ValueSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('totals')) {
      context.handle(
        _totalsMeta,
        totals.isAcceptableOrUnknown(data['totals']!, _totalsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalsMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {month};
  @override
  ValueSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ValueSnapshotRow(
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      totals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}totals'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
    );
  }

  @override
  $ValueSnapshotsTable createAlias(String alias) {
    return $ValueSnapshotsTable(attachedDatabase, alias);
  }
}

class ValueSnapshotRow extends DataClass
    implements Insertable<ValueSnapshotRow> {
  final String month;
  final String totals;
  final DateTime takenAt;
  const ValueSnapshotRow({
    required this.month,
    required this.totals,
    required this.takenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['month'] = Variable<String>(month);
    map['totals'] = Variable<String>(totals);
    map['taken_at'] = Variable<DateTime>(takenAt);
    return map;
  }

  ValueSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return ValueSnapshotsCompanion(
      month: Value(month),
      totals: Value(totals),
      takenAt: Value(takenAt),
    );
  }

  factory ValueSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ValueSnapshotRow(
      month: serializer.fromJson<String>(json['month']),
      totals: serializer.fromJson<String>(json['totals']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'month': serializer.toJson<String>(month),
      'totals': serializer.toJson<String>(totals),
      'takenAt': serializer.toJson<DateTime>(takenAt),
    };
  }

  ValueSnapshotRow copyWith({
    String? month,
    String? totals,
    DateTime? takenAt,
  }) => ValueSnapshotRow(
    month: month ?? this.month,
    totals: totals ?? this.totals,
    takenAt: takenAt ?? this.takenAt,
  );
  ValueSnapshotRow copyWithCompanion(ValueSnapshotsCompanion data) {
    return ValueSnapshotRow(
      month: data.month.present ? data.month.value : this.month,
      totals: data.totals.present ? data.totals.value : this.totals,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ValueSnapshotRow(')
          ..write('month: $month, ')
          ..write('totals: $totals, ')
          ..write('takenAt: $takenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(month, totals, takenAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ValueSnapshotRow &&
          other.month == this.month &&
          other.totals == this.totals &&
          other.takenAt == this.takenAt);
}

class ValueSnapshotsCompanion extends UpdateCompanion<ValueSnapshotRow> {
  final Value<String> month;
  final Value<String> totals;
  final Value<DateTime> takenAt;
  final Value<int> rowid;
  const ValueSnapshotsCompanion({
    this.month = const Value.absent(),
    this.totals = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ValueSnapshotsCompanion.insert({
    required String month,
    required String totals,
    required DateTime takenAt,
    this.rowid = const Value.absent(),
  }) : month = Value(month),
       totals = Value(totals),
       takenAt = Value(takenAt);
  static Insertable<ValueSnapshotRow> custom({
    Expression<String>? month,
    Expression<String>? totals,
    Expression<DateTime>? takenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (month != null) 'month': month,
      if (totals != null) 'totals': totals,
      if (takenAt != null) 'taken_at': takenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ValueSnapshotsCompanion copyWith({
    Value<String>? month,
    Value<String>? totals,
    Value<DateTime>? takenAt,
    Value<int>? rowid,
  }) {
    return ValueSnapshotsCompanion(
      month: month ?? this.month,
      totals: totals ?? this.totals,
      takenAt: takenAt ?? this.takenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (totals.present) {
      map['totals'] = Variable<String>(totals.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ValueSnapshotsCompanion(')
          ..write('month: $month, ')
          ..write('totals: $totals, ')
          ..write('takenAt: $takenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemValueSnapshotsTable extends ItemValueSnapshots
    with TableInfo<$ItemValueSnapshotsTable, ItemValueSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemValueSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _centsMeta = const VerificationMeta('cents');
  @override
  late final GeneratedColumn<int> cents = GeneratedColumn<int>(
    'cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, month, cents, currency];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_value_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemValueSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('cents')) {
      context.handle(
        _centsMeta,
        cents.isAcceptableOrUnknown(data['cents']!, _centsMeta),
      );
    } else if (isInserting) {
      context.missing(_centsMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, month};
  @override
  ItemValueSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemValueSnapshotRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      cents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
    );
  }

  @override
  $ItemValueSnapshotsTable createAlias(String alias) {
    return $ItemValueSnapshotsTable(attachedDatabase, alias);
  }
}

class ItemValueSnapshotRow extends DataClass
    implements Insertable<ItemValueSnapshotRow> {
  final String itemId;
  final String month;
  final int cents;
  final String currency;
  const ItemValueSnapshotRow({
    required this.itemId,
    required this.month,
    required this.cents,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['month'] = Variable<String>(month);
    map['cents'] = Variable<int>(cents);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  ItemValueSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return ItemValueSnapshotsCompanion(
      itemId: Value(itemId),
      month: Value(month),
      cents: Value(cents),
      currency: Value(currency),
    );
  }

  factory ItemValueSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemValueSnapshotRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      month: serializer.fromJson<String>(json['month']),
      cents: serializer.fromJson<int>(json['cents']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'month': serializer.toJson<String>(month),
      'cents': serializer.toJson<int>(cents),
      'currency': serializer.toJson<String>(currency),
    };
  }

  ItemValueSnapshotRow copyWith({
    String? itemId,
    String? month,
    int? cents,
    String? currency,
  }) => ItemValueSnapshotRow(
    itemId: itemId ?? this.itemId,
    month: month ?? this.month,
    cents: cents ?? this.cents,
    currency: currency ?? this.currency,
  );
  ItemValueSnapshotRow copyWithCompanion(ItemValueSnapshotsCompanion data) {
    return ItemValueSnapshotRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      month: data.month.present ? data.month.value : this.month,
      cents: data.cents.present ? data.cents.value : this.cents,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemValueSnapshotRow(')
          ..write('itemId: $itemId, ')
          ..write('month: $month, ')
          ..write('cents: $cents, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, month, cents, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemValueSnapshotRow &&
          other.itemId == this.itemId &&
          other.month == this.month &&
          other.cents == this.cents &&
          other.currency == this.currency);
}

class ItemValueSnapshotsCompanion
    extends UpdateCompanion<ItemValueSnapshotRow> {
  final Value<String> itemId;
  final Value<String> month;
  final Value<int> cents;
  final Value<String> currency;
  final Value<int> rowid;
  const ItemValueSnapshotsCompanion({
    this.itemId = const Value.absent(),
    this.month = const Value.absent(),
    this.cents = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemValueSnapshotsCompanion.insert({
    required String itemId,
    required String month,
    required int cents,
    required String currency,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       month = Value(month),
       cents = Value(cents),
       currency = Value(currency);
  static Insertable<ItemValueSnapshotRow> custom({
    Expression<String>? itemId,
    Expression<String>? month,
    Expression<int>? cents,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (month != null) 'month': month,
      if (cents != null) 'cents': cents,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemValueSnapshotsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? month,
    Value<int>? cents,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return ItemValueSnapshotsCompanion(
      itemId: itemId ?? this.itemId,
      month: month ?? this.month,
      cents: cents ?? this.cents,
      currency: currency ?? this.currency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (cents.present) {
      map['cents'] = Variable<int>(cents.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemValueSnapshotsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('month: $month, ')
          ..write('cents: $cents, ')
          ..write('currency: $currency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanSessionsTable extends ScanSessions
    with TableInfo<$ScanSessionsTable, ScanSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, startedAt, mode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
    );
  }

  @override
  $ScanSessionsTable createAlias(String alias) {
    return $ScanSessionsTable(attachedDatabase, alias);
  }
}

class ScanSessionRow extends DataClass implements Insertable<ScanSessionRow> {
  final String id;
  final DateTime startedAt;
  final String mode;
  const ScanSessionRow({
    required this.id,
    required this.startedAt,
    required this.mode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['mode'] = Variable<String>(mode);
    return map;
  }

  ScanSessionsCompanion toCompanion(bool nullToAbsent) {
    return ScanSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      mode: Value(mode),
    );
  }

  factory ScanSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanSessionRow(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      mode: serializer.fromJson<String>(json['mode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'mode': serializer.toJson<String>(mode),
    };
  }

  ScanSessionRow copyWith({String? id, DateTime? startedAt, String? mode}) =>
      ScanSessionRow(
        id: id ?? this.id,
        startedAt: startedAt ?? this.startedAt,
        mode: mode ?? this.mode,
      );
  ScanSessionRow copyWithCompanion(ScanSessionsCompanion data) {
    return ScanSessionRow(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      mode: data.mode.present ? data.mode.value : this.mode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanSessionRow(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('mode: $mode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, mode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanSessionRow &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.mode == this.mode);
}

class ScanSessionsCompanion extends UpdateCompanion<ScanSessionRow> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<String> mode;
  final Value<int> rowid;
  const ScanSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.mode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScanSessionsCompanion.insert({
    required String id,
    required DateTime startedAt,
    required String mode,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       mode = Value(mode);
  static Insertable<ScanSessionRow> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<String>? mode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (mode != null) 'mode': mode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScanSessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<String>? mode,
    Value<int>? rowid,
  }) {
    return ScanSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      mode: mode ?? this.mode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('mode: $mode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanSessionEntriesTable extends ScanSessionEntries
    with TableInfo<$ScanSessionEntriesTable, ScanSessionEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanSessionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES scan_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    position,
    title,
    outcome,
    source,
    itemId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_session_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanSessionEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, position};
  @override
  ScanSessionEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanSessionEntryRow(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      ),
    );
  }

  @override
  $ScanSessionEntriesTable createAlias(String alias) {
    return $ScanSessionEntriesTable(attachedDatabase, alias);
  }
}

class ScanSessionEntryRow extends DataClass
    implements Insertable<ScanSessionEntryRow> {
  final String sessionId;
  final int position;
  final String title;
  final String outcome;
  final String source;
  final String? itemId;
  const ScanSessionEntryRow({
    required this.sessionId,
    required this.position,
    required this.title,
    required this.outcome,
    required this.source,
    this.itemId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    map['outcome'] = Variable<String>(outcome);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<String>(itemId);
    }
    return map;
  }

  ScanSessionEntriesCompanion toCompanion(bool nullToAbsent) {
    return ScanSessionEntriesCompanion(
      sessionId: Value(sessionId),
      position: Value(position),
      title: Value(title),
      outcome: Value(outcome),
      source: Value(source),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
    );
  }

  factory ScanSessionEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanSessionEntryRow(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      outcome: serializer.fromJson<String>(json['outcome']),
      source: serializer.fromJson<String>(json['source']),
      itemId: serializer.fromJson<String?>(json['itemId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'outcome': serializer.toJson<String>(outcome),
      'source': serializer.toJson<String>(source),
      'itemId': serializer.toJson<String?>(itemId),
    };
  }

  ScanSessionEntryRow copyWith({
    String? sessionId,
    int? position,
    String? title,
    String? outcome,
    String? source,
    Value<String?> itemId = const Value.absent(),
  }) => ScanSessionEntryRow(
    sessionId: sessionId ?? this.sessionId,
    position: position ?? this.position,
    title: title ?? this.title,
    outcome: outcome ?? this.outcome,
    source: source ?? this.source,
    itemId: itemId.present ? itemId.value : this.itemId,
  );
  ScanSessionEntryRow copyWithCompanion(ScanSessionEntriesCompanion data) {
    return ScanSessionEntryRow(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      source: data.source.present ? data.source.value : this.source,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanSessionEntryRow(')
          ..write('sessionId: $sessionId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('outcome: $outcome, ')
          ..write('source: $source, ')
          ..write('itemId: $itemId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, position, title, outcome, source, itemId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanSessionEntryRow &&
          other.sessionId == this.sessionId &&
          other.position == this.position &&
          other.title == this.title &&
          other.outcome == this.outcome &&
          other.source == this.source &&
          other.itemId == this.itemId);
}

class ScanSessionEntriesCompanion extends UpdateCompanion<ScanSessionEntryRow> {
  final Value<String> sessionId;
  final Value<int> position;
  final Value<String> title;
  final Value<String> outcome;
  final Value<String> source;
  final Value<String?> itemId;
  final Value<int> rowid;
  const ScanSessionEntriesCompanion({
    this.sessionId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.outcome = const Value.absent(),
    this.source = const Value.absent(),
    this.itemId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScanSessionEntriesCompanion.insert({
    required String sessionId,
    required int position,
    required String title,
    required String outcome,
    required String source,
    this.itemId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       position = Value(position),
       title = Value(title),
       outcome = Value(outcome),
       source = Value(source);
  static Insertable<ScanSessionEntryRow> custom({
    Expression<String>? sessionId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<String>? outcome,
    Expression<String>? source,
    Expression<String>? itemId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (outcome != null) 'outcome': outcome,
      if (source != null) 'source': source,
      if (itemId != null) 'item_id': itemId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScanSessionEntriesCompanion copyWith({
    Value<String>? sessionId,
    Value<int>? position,
    Value<String>? title,
    Value<String>? outcome,
    Value<String>? source,
    Value<String?>? itemId,
    Value<int>? rowid,
  }) {
    return ScanSessionEntriesCompanion(
      sessionId: sessionId ?? this.sessionId,
      position: position ?? this.position,
      title: title ?? this.title,
      outcome: outcome ?? this.outcome,
      source: source ?? this.source,
      itemId: itemId ?? this.itemId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanSessionEntriesCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('outcome: $outcome, ')
          ..write('source: $source, ')
          ..write('itemId: $itemId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityEventsTable extends ActivityEvents
    with TableInfo<$ActivityEventsTable, ActivityEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    itemId,
    categoryId,
    title,
    amountCents,
    currency,
    detail,
    at,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $ActivityEventsTable createAlias(String alias) {
    return $ActivityEventsTable(attachedDatabase, alias);
  }
}

class ActivityEventRow extends DataClass
    implements Insertable<ActivityEventRow> {
  final int id;
  final String kind;
  final String? itemId;
  final String? categoryId;
  final String title;
  final int? amountCents;
  final String? currency;
  final String? detail;
  final DateTime at;
  const ActivityEventRow({
    required this.id,
    required this.kind,
    this.itemId,
    this.categoryId,
    required this.title,
    this.amountCents,
    this.currency,
    this.detail,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<String>(itemId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || amountCents != null) {
      map['amount_cents'] = Variable<int>(amountCents);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  ActivityEventsCompanion toCompanion(bool nullToAbsent) {
    return ActivityEventsCompanion(
      id: Value(id),
      kind: Value(kind),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      title: Value(title),
      amountCents: amountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(amountCents),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      detail: detail == null && nullToAbsent
          ? const Value.absent()
          : Value(detail),
      at: Value(at),
    );
  }

  factory ActivityEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityEventRow(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      itemId: serializer.fromJson<String?>(json['itemId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      title: serializer.fromJson<String>(json['title']),
      amountCents: serializer.fromJson<int?>(json['amountCents']),
      currency: serializer.fromJson<String?>(json['currency']),
      detail: serializer.fromJson<String?>(json['detail']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'itemId': serializer.toJson<String?>(itemId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'title': serializer.toJson<String>(title),
      'amountCents': serializer.toJson<int?>(amountCents),
      'currency': serializer.toJson<String?>(currency),
      'detail': serializer.toJson<String?>(detail),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  ActivityEventRow copyWith({
    int? id,
    String? kind,
    Value<String?> itemId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    String? title,
    Value<int?> amountCents = const Value.absent(),
    Value<String?> currency = const Value.absent(),
    Value<String?> detail = const Value.absent(),
    DateTime? at,
  }) => ActivityEventRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    itemId: itemId.present ? itemId.value : this.itemId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    title: title ?? this.title,
    amountCents: amountCents.present ? amountCents.value : this.amountCents,
    currency: currency.present ? currency.value : this.currency,
    detail: detail.present ? detail.value : this.detail,
    at: at ?? this.at,
  );
  ActivityEventRow copyWithCompanion(ActivityEventsCompanion data) {
    return ActivityEventRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      title: data.title.present ? data.title.value : this.title,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      detail: data.detail.present ? data.detail.value : this.detail,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEventRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('itemId: $itemId, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('amountCents: $amountCents, ')
          ..write('currency: $currency, ')
          ..write('detail: $detail, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    itemId,
    categoryId,
    title,
    amountCents,
    currency,
    detail,
    at,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityEventRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.itemId == this.itemId &&
          other.categoryId == this.categoryId &&
          other.title == this.title &&
          other.amountCents == this.amountCents &&
          other.currency == this.currency &&
          other.detail == this.detail &&
          other.at == this.at);
}

class ActivityEventsCompanion extends UpdateCompanion<ActivityEventRow> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String?> itemId;
  final Value<String?> categoryId;
  final Value<String> title;
  final Value<int?> amountCents;
  final Value<String?> currency;
  final Value<String?> detail;
  final Value<DateTime> at;
  const ActivityEventsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.itemId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.detail = const Value.absent(),
    this.at = const Value.absent(),
  });
  ActivityEventsCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    this.itemId = const Value.absent(),
    this.categoryId = const Value.absent(),
    required String title,
    this.amountCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.detail = const Value.absent(),
    required DateTime at,
  }) : kind = Value(kind),
       title = Value(title),
       at = Value(at);
  static Insertable<ActivityEventRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? itemId,
    Expression<String>? categoryId,
    Expression<String>? title,
    Expression<int>? amountCents,
    Expression<String>? currency,
    Expression<String>? detail,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (itemId != null) 'item_id': itemId,
      if (categoryId != null) 'category_id': categoryId,
      if (title != null) 'title': title,
      if (amountCents != null) 'amount_cents': amountCents,
      if (currency != null) 'currency': currency,
      if (detail != null) 'detail': detail,
      if (at != null) 'at': at,
    });
  }

  ActivityEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String?>? itemId,
    Value<String?>? categoryId,
    Value<String>? title,
    Value<int?>? amountCents,
    Value<String?>? currency,
    Value<String?>? detail,
    Value<DateTime>? at,
  }) {
    return ActivityEventsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      itemId: itemId ?? this.itemId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      amountCents: amountCents ?? this.amountCents,
      currency: currency ?? this.currency,
      detail: detail ?? this.detail,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEventsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('itemId: $itemId, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('amountCents: $amountCents, ')
          ..write('currency: $currency, ')
          ..write('detail: $detail, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measureMeta = const VerificationMeta(
    'measure',
  );
  @override
  late final GeneratedColumn<String> measure = GeneratedColumn<String>(
    'measure',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    measure,
    categoryId,
    target,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('measure')) {
      context.handle(
        _measureMeta,
        measure.isAcceptableOrUnknown(data['measure']!, _measureMeta),
      );
    } else if (isInserting) {
      context.missing(_measureMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      measure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measure'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class GoalRow extends DataClass implements Insertable<GoalRow> {
  final String id;
  final int year;
  final String measure;
  final String? categoryId;
  final int target;
  final DateTime createdAt;
  const GoalRow({
    required this.id,
    required this.year,
    required this.measure,
    this.categoryId,
    required this.target,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year'] = Variable<int>(year);
    map['measure'] = Variable<String>(measure);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['target'] = Variable<int>(target);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      year: Value(year),
      measure: Value(measure),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      target: Value(target),
      createdAt: Value(createdAt),
    );
  }

  factory GoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRow(
      id: serializer.fromJson<String>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      measure: serializer.fromJson<String>(json['measure']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      target: serializer.fromJson<int>(json['target']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'year': serializer.toJson<int>(year),
      'measure': serializer.toJson<String>(measure),
      'categoryId': serializer.toJson<String?>(categoryId),
      'target': serializer.toJson<int>(target),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoalRow copyWith({
    String? id,
    int? year,
    String? measure,
    Value<String?> categoryId = const Value.absent(),
    int? target,
    DateTime? createdAt,
  }) => GoalRow(
    id: id ?? this.id,
    year: year ?? this.year,
    measure: measure ?? this.measure,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    target: target ?? this.target,
    createdAt: createdAt ?? this.createdAt,
  );
  GoalRow copyWithCompanion(GoalsCompanion data) {
    return GoalRow(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      measure: data.measure.present ? data.measure.value : this.measure,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      target: data.target.present ? data.target.value : this.target,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRow(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('measure: $measure, ')
          ..write('categoryId: $categoryId, ')
          ..write('target: $target, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, year, measure, categoryId, target, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRow &&
          other.id == this.id &&
          other.year == this.year &&
          other.measure == this.measure &&
          other.categoryId == this.categoryId &&
          other.target == this.target &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<GoalRow> {
  final Value<String> id;
  final Value<int> year;
  final Value<String> measure;
  final Value<String?> categoryId;
  final Value<int> target;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.measure = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.target = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required int year,
    required String measure,
    this.categoryId = const Value.absent(),
    required int target,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       year = Value(year),
       measure = Value(measure),
       target = Value(target),
       createdAt = Value(createdAt);
  static Insertable<GoalRow> custom({
    Expression<String>? id,
    Expression<int>? year,
    Expression<String>? measure,
    Expression<String>? categoryId,
    Expression<int>? target,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (measure != null) 'measure': measure,
      if (categoryId != null) 'category_id': categoryId,
      if (target != null) 'target': target,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<int>? year,
    Value<String>? measure,
    Value<String?>? categoryId,
    Value<int>? target,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      measure: measure ?? this.measure,
      categoryId: categoryId ?? this.categoryId,
      target: target ?? this.target,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (measure.present) {
      map['measure'] = Variable<String>(measure.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('measure: $measure, ')
          ..write('categoryId: $categoryId, ')
          ..write('target: $target, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemTagsTable extends ItemTags
    with TableInfo<$ItemTagsTable, ItemTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemTagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, tag};
  @override
  ItemTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemTagRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      )!,
    );
  }

  @override
  $ItemTagsTable createAlias(String alias) {
    return $ItemTagsTable(attachedDatabase, alias);
  }
}

class ItemTagRow extends DataClass implements Insertable<ItemTagRow> {
  final String itemId;
  final String tag;
  const ItemTagRow({required this.itemId, required this.tag});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['tag'] = Variable<String>(tag);
    return map;
  }

  ItemTagsCompanion toCompanion(bool nullToAbsent) {
    return ItemTagsCompanion(itemId: Value(itemId), tag: Value(tag));
  }

  factory ItemTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemTagRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      tag: serializer.fromJson<String>(json['tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'tag': serializer.toJson<String>(tag),
    };
  }

  ItemTagRow copyWith({String? itemId, String? tag}) =>
      ItemTagRow(itemId: itemId ?? this.itemId, tag: tag ?? this.tag);
  ItemTagRow copyWithCompanion(ItemTagsCompanion data) {
    return ItemTagRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      tag: data.tag.present ? data.tag.value : this.tag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemTagRow(')
          ..write('itemId: $itemId, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, tag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemTagRow &&
          other.itemId == this.itemId &&
          other.tag == this.tag);
}

class ItemTagsCompanion extends UpdateCompanion<ItemTagRow> {
  final Value<String> itemId;
  final Value<String> tag;
  final Value<int> rowid;
  const ItemTagsCompanion({
    this.itemId = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemTagsCompanion.insert({
    required String itemId,
    required String tag,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       tag = Value(tag);
  static Insertable<ItemTagRow> custom({
    Expression<String>? itemId,
    Expression<String>? tag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (tag != null) 'tag': tag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemTagsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? tag,
    Value<int>? rowid,
  }) {
    return ItemTagsCompanion(
      itemId: itemId ?? this.itemId,
      tag: tag ?? this.tag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemTagsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('tag: $tag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SmartShelvesTable extends SmartShelves
    with TableInfo<$SmartShelvesTable, SmartShelfRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmartShelvesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filterMeta = const VerificationMeta('filter');
  @override
  late final GeneratedColumn<String> filter = GeneratedColumn<String>(
    'filter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    categoryId,
    filter,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smart_shelves';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmartShelfRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('filter')) {
      context.handle(
        _filterMeta,
        filter.isAcceptableOrUnknown(data['filter']!, _filterMeta),
      );
    } else if (isInserting) {
      context.missing(_filterMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmartShelfRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmartShelfRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      filter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filter'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SmartShelvesTable createAlias(String alias) {
    return $SmartShelvesTable(attachedDatabase, alias);
  }
}

class SmartShelfRow extends DataClass implements Insertable<SmartShelfRow> {
  final String id;
  final String name;
  final String? categoryId;
  final String filter;
  final DateTime createdAt;
  const SmartShelfRow({
    required this.id,
    required this.name,
    this.categoryId,
    required this.filter,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['filter'] = Variable<String>(filter);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SmartShelvesCompanion toCompanion(bool nullToAbsent) {
    return SmartShelvesCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      filter: Value(filter),
      createdAt: Value(createdAt),
    );
  }

  factory SmartShelfRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmartShelfRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      filter: serializer.fromJson<String>(json['filter']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String?>(categoryId),
      'filter': serializer.toJson<String>(filter),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SmartShelfRow copyWith({
    String? id,
    String? name,
    Value<String?> categoryId = const Value.absent(),
    String? filter,
    DateTime? createdAt,
  }) => SmartShelfRow(
    id: id ?? this.id,
    name: name ?? this.name,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    filter: filter ?? this.filter,
    createdAt: createdAt ?? this.createdAt,
  );
  SmartShelfRow copyWithCompanion(SmartShelvesCompanion data) {
    return SmartShelfRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      filter: data.filter.present ? data.filter.value : this.filter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmartShelfRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('filter: $filter, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, categoryId, filter, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmartShelfRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.filter == this.filter &&
          other.createdAt == this.createdAt);
}

class SmartShelvesCompanion extends UpdateCompanion<SmartShelfRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> categoryId;
  final Value<String> filter;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SmartShelvesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.filter = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SmartShelvesCompanion.insert({
    required String id,
    required String name,
    this.categoryId = const Value.absent(),
    required String filter,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       filter = Value(filter),
       createdAt = Value(createdAt);
  static Insertable<SmartShelfRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<String>? filter,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (filter != null) 'filter': filter,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SmartShelvesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? categoryId,
    Value<String>? filter,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SmartShelvesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      filter: filter ?? this.filter,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (filter.present) {
      map['filter'] = Variable<String>(filter.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmartShelvesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('filter: $filter, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoragePlacesTable extends StoragePlaces
    with TableInfo<$StoragePlacesTable, StoragePlaceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoragePlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, parentId, name, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'storage_places';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoragePlaceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoragePlaceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoragePlaceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $StoragePlacesTable createAlias(String alias) {
    return $StoragePlacesTable(attachedDatabase, alias);
  }
}

class StoragePlaceRow extends DataClass implements Insertable<StoragePlaceRow> {
  final String id;
  final String? parentId;
  final String name;
  final int position;
  const StoragePlaceRow({
    required this.id,
    this.parentId,
    required this.name,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['position'] = Variable<int>(position);
    return map;
  }

  StoragePlacesCompanion toCompanion(bool nullToAbsent) {
    return StoragePlacesCompanion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      position: Value(position),
    );
  }

  factory StoragePlaceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoragePlaceRow(
      id: serializer.fromJson<String>(json['id']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'position': serializer.toJson<int>(position),
    };
  }

  StoragePlaceRow copyWith({
    String? id,
    Value<String?> parentId = const Value.absent(),
    String? name,
    int? position,
  }) => StoragePlaceRow(
    id: id ?? this.id,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    position: position ?? this.position,
  );
  StoragePlaceRow copyWithCompanion(StoragePlacesCompanion data) {
    return StoragePlaceRow(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoragePlaceRow(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, parentId, name, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoragePlaceRow &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.position == this.position);
}

class StoragePlacesCompanion extends UpdateCompanion<StoragePlaceRow> {
  final Value<String> id;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<int> position;
  final Value<int> rowid;
  const StoragePlacesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoragePlacesCompanion.insert({
    required String id,
    this.parentId = const Value.absent(),
    required String name,
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<StoragePlaceRow> custom({
    Expression<String>? id,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoragePlacesCompanion copyWith({
    Value<String>? id,
    Value<String?>? parentId,
    Value<String>? name,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return StoragePlacesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoragePlacesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AkashicDatabase extends GeneratedDatabase {
  _$AkashicDatabase(QueryExecutor e) : super(e);
  $AkashicDatabaseManager get managers => $AkashicDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SeriesTableTable seriesTable = $SeriesTableTable(this);
  late final $SeriesTitlesTable seriesTitles = $SeriesTitlesTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $ItemTitlesTable itemTitles = $ItemTitlesTable(this);
  late final $CopiesTable copies = $CopiesTable(this);
  late final $CopyConditionsTable copyConditions = $CopyConditionsTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  late final $DeckCardsTable deckCards = $DeckCardsTable(this);
  late final $ItemDetailsTable itemDetails = $ItemDetailsTable(this);
  late final $WishesTable wishes = $WishesTable(this);
  late final $DismissedSuggestionsTable dismissedSuggestions =
      $DismissedSuggestionsTable(this);
  late final $DiscoveryCacheTable discoveryCache = $DiscoveryCacheTable(this);
  late final $ScanFollowsTable scanFollows = $ScanFollowsTable(this);
  late final $ReadChaptersTable readChapters = $ReadChaptersTable(this);
  late final $ScanReleasesTable scanReleases = $ScanReleasesTable(this);
  late final $SourceBlocksTable sourceBlocks = $SourceBlocksTable(this);
  late final $ItemPhotosTable itemPhotos = $ItemPhotosTable(this);
  late final $SteamGameStatsTable steamGameStats = $SteamGameStatsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SealedPricesTable sealedPrices = $SealedPricesTable(this);
  late final $SteamWatchesTable steamWatches = $SteamWatchesTable(this);
  late final $SteamKnownDlcsTable steamKnownDlcs = $SteamKnownDlcsTable(this);
  late final $PriceAlertsTable priceAlerts = $PriceAlertsTable(this);
  late final $ValueSnapshotsTable valueSnapshots = $ValueSnapshotsTable(this);
  late final $ItemValueSnapshotsTable itemValueSnapshots =
      $ItemValueSnapshotsTable(this);
  late final $ScanSessionsTable scanSessions = $ScanSessionsTable(this);
  late final $ScanSessionEntriesTable scanSessionEntries =
      $ScanSessionEntriesTable(this);
  late final $ActivityEventsTable activityEvents = $ActivityEventsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $ItemTagsTable itemTags = $ItemTagsTable(this);
  late final $SmartShelvesTable smartShelves = $SmartShelvesTable(this);
  late final $StoragePlacesTable storagePlaces = $StoragePlacesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    seriesTable,
    seriesTitles,
    items,
    itemTitles,
    copies,
    copyConditions,
    preferences,
    deckCards,
    itemDetails,
    wishes,
    dismissedSuggestions,
    discoveryCache,
    scanFollows,
    readChapters,
    scanReleases,
    sourceBlocks,
    itemPhotos,
    steamGameStats,
    sales,
    sealedPrices,
    steamWatches,
    steamKnownDlcs,
    priceAlerts,
    valueSnapshots,
    itemValueSnapshots,
    scanSessions,
    scanSessionEntries,
    activityEvents,
    goals,
    itemTags,
    smartShelves,
    storagePlaces,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('series_titles', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_titles', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('copies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'copies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('copy_conditions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('deck_cards', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_details', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wishes', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wishes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('scan_follows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('read_chapters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('scan_releases', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'copies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('steam_game_stats', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('price_alerts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_value_snapshots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'scan_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('scan_session_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_tags', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  Value<String?> parentId,
  required String name,
  required int colorValue,
  required String type,
  Value<String?> sourceKey,
  required String conditionParts,
  required int position,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String?> parentId,
  Value<String> name,
  Value<int> colorValue,
  Value<String> type,
  Value<String?> sourceKey,
  Value<String> conditionParts,
  Value<int> position,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AkashicDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$AkashicDatabase db) =>
      db.categories.createAlias('categories__parent_id__categories__id');

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SeriesTableTable, List<SeriesRow>>
  _seriesTableRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.seriesTable,
    aliasName: 'categories__id__series__category_id',
  );

  $$SeriesTableTableProcessedTableManager get seriesTableRefs {
    final manager = $$SeriesTableTableTableManager(
      $_db,
      $_db.seriesTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_seriesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemsTable, List<ItemRow>> _itemsRefsTable(
    _$AkashicDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'categories__id__items__category_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WishesTable, List<WishRow>> _wishesRefsTable(
    _$AkashicDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.wishes,
    aliasName: 'categories__id__wishes__category_id',
  );

  $$WishesTableProcessedTableManager get wishesRefs {
    final manager = $$WishesTableTableManager(
      $_db,
      $_db.wishes,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_wishesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AkashicDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionParts => $composableBuilder(
    column: $table.conditionParts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> seriesTableRefs(
    Expression<bool> Function($$SeriesTableTableFilterComposer f) f,
  ) {
    final $$SeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableFilterComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wishesRefs(
    Expression<bool> Function($$WishesTableFilterComposer f) f,
  ) {
    final $$WishesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishes,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishesTableFilterComposer(
            $db: $db,
            $table: $db.wishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionParts => $composableBuilder(
    column: $table.conditionParts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<String> get conditionParts => $composableBuilder(
    column: $table.conditionParts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> seriesTableRefs<T extends Object>(
    Expression<T> Function($$SeriesTableTableAnnotationComposer a) f,
  ) {
    final $$SeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wishesRefs<T extends Object>(
    Expression<T> Function($$WishesTableAnnotationComposer a) f,
  ) {
    final $$WishesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishes,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishesTableAnnotationComposer(
            $db: $db,
            $table: $db.wishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({
            bool parentId,
            bool seriesTableRefs,
            bool itemsRefs,
            bool wishesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AkashicDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> sourceKey = const Value.absent(),
                Value<String> conditionParts = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                parentId: parentId,
                name: name,
                colorValue: colorValue,
                type: type,
                sourceKey: sourceKey,
                conditionParts: conditionParts,
                position: position,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> parentId = const Value.absent(),
                required String name,
                required int colorValue,
                required String type,
                Value<String?> sourceKey = const Value.absent(),
                required String conditionParts,
                required int position,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                parentId: parentId,
                name: name,
                colorValue: colorValue,
                type: type,
                sourceKey: sourceKey,
                conditionParts: conditionParts,
                position: position,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                seriesTableRefs = false,
                itemsRefs = false,
                wishesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (seriesTableRefs) db.seriesTable,
                    if (itemsRefs) db.items,
                    if (wishesRefs) db.wishes,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $$CategoriesTableReferences
                                ._parentIdTable(db),
                            referencedColumn: $$CategoriesTableReferences
                                ._parentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (seriesTableRefs)
                        await $_getPrefetchedData<
                          CategoryRow,
                          $CategoriesTable,
                          SeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._seriesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).seriesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemsRefs)
                        await $_getPrefetchedData<
                          CategoryRow,
                          $CategoriesTable,
                          ItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._itemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).itemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (wishesRefs)
                        await $_getPrefetchedData<
                          CategoryRow,
                          $CategoriesTable,
                          WishRow
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._wishesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).wishesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({
        bool parentId,
        bool seriesTableRefs,
        bool itemsRefs,
        bool wishesRefs,
      })
    >;
typedef $$SeriesTableTableCreateCompanionBuilder =
    SeriesTableCompanion Function({
      required String id,
      required String categoryId,
      Value<String?> originalLanguage,
      Value<String?> creator,
      Value<int?> publishedVolumes,
      Value<String?> sourceKey,
      Value<String?> externalWorkId,
      Value<String?> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SeriesTableTableUpdateCompanionBuilder =
    SeriesTableCompanion Function({
      Value<String> id,
      Value<String> categoryId,
      Value<String?> originalLanguage,
      Value<String?> creator,
      Value<int?> publishedVolumes,
      Value<String?> sourceKey,
      Value<String?> externalWorkId,
      Value<String?> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SeriesTableTableReferences
    extends BaseReferences<_$AkashicDatabase, $SeriesTableTable, SeriesRow> {
  $$SeriesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AkashicDatabase db) =>
      db.categories.createAlias('series__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SeriesTitlesTable, List<SeriesTitleRow>>
  _seriesTitlesRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.seriesTitles,
    aliasName: 'series__id__series_titles__series_id',
  );

  $$SeriesTitlesTableProcessedTableManager get seriesTitlesRefs {
    final manager = $$SeriesTitlesTableTableManager(
      $_db,
      $_db.seriesTitles,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_seriesTitlesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemsTable, List<ItemRow>> _itemsRefsTable(
    _$AkashicDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'series__id__items__series_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WishesTable, List<WishRow>> _wishesRefsTable(
    _$AkashicDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.wishes,
    aliasName: 'series__id__wishes__series_id',
  );

  $$WishesTableProcessedTableManager get wishesRefs {
    final manager = $$WishesTableTableManager(
      $_db,
      $_db.wishes,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_wishesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScanFollowsTable, List<ScanFollowRow>>
  _scanFollowsRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.scanFollows,
    aliasName: 'series__id__scan_follows__series_id',
  );

  $$ScanFollowsTableProcessedTableManager get scanFollowsRefs {
    final manager = $$ScanFollowsTableTableManager(
      $_db,
      $_db.scanFollows,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scanFollowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadChaptersTable, List<ReadChapterRow>>
  _readChaptersRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.readChapters,
    aliasName: 'series__id__read_chapters__series_id',
  );

  $$ReadChaptersTableProcessedTableManager get readChaptersRefs {
    final manager = $$ReadChaptersTableTableManager(
      $_db,
      $_db.readChapters,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_readChaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScanReleasesTable, List<ScanReleaseRow>>
  _scanReleasesRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.scanReleases,
    aliasName: 'series__id__scan_releases__series_id',
  );

  $$ScanReleasesTableProcessedTableManager get scanReleasesRefs {
    final manager = $$ScanReleasesTableTableManager(
      $_db,
      $_db.scanReleases,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scanReleasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SeriesTableTableFilterComposer
    extends Composer<_$AkashicDatabase, $SeriesTableTable> {
  $$SeriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get publishedVolumes => $composableBuilder(
    column: $table.publishedVolumes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> seriesTitlesRefs(
    Expression<bool> Function($$SeriesTitlesTableFilterComposer f) f,
  ) {
    final $$SeriesTitlesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.seriesTitles,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTitlesTableFilterComposer(
            $db: $db,
            $table: $db.seriesTitles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wishesRefs(
    Expression<bool> Function($$WishesTableFilterComposer f) f,
  ) {
    final $$WishesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishes,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishesTableFilterComposer(
            $db: $db,
            $table: $db.wishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scanFollowsRefs(
    Expression<bool> Function($$ScanFollowsTableFilterComposer f) f,
  ) {
    final $$ScanFollowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scanFollows,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanFollowsTableFilterComposer(
            $db: $db,
            $table: $db.scanFollows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readChaptersRefs(
    Expression<bool> Function($$ReadChaptersTableFilterComposer f) f,
  ) {
    final $$ReadChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readChapters,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadChaptersTableFilterComposer(
            $db: $db,
            $table: $db.readChapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scanReleasesRefs(
    Expression<bool> Function($$ScanReleasesTableFilterComposer f) f,
  ) {
    final $$ScanReleasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scanReleases,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanReleasesTableFilterComposer(
            $db: $db,
            $table: $db.scanReleases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SeriesTableTableOrderingComposer
    extends Composer<_$AkashicDatabase, $SeriesTableTable> {
  $$SeriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get publishedVolumes => $composableBuilder(
    column: $table.publishedVolumes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTableTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $SeriesTableTable> {
  $$SeriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumn<int> get publishedVolumes => $composableBuilder(
    column: $table.publishedVolumes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> seriesTitlesRefs<T extends Object>(
    Expression<T> Function($$SeriesTitlesTableAnnotationComposer a) f,
  ) {
    final $$SeriesTitlesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.seriesTitles,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTitlesTableAnnotationComposer(
            $db: $db,
            $table: $db.seriesTitles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wishesRefs<T extends Object>(
    Expression<T> Function($$WishesTableAnnotationComposer a) f,
  ) {
    final $$WishesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishes,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishesTableAnnotationComposer(
            $db: $db,
            $table: $db.wishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scanFollowsRefs<T extends Object>(
    Expression<T> Function($$ScanFollowsTableAnnotationComposer a) f,
  ) {
    final $$ScanFollowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scanFollows,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanFollowsTableAnnotationComposer(
            $db: $db,
            $table: $db.scanFollows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readChaptersRefs<T extends Object>(
    Expression<T> Function($$ReadChaptersTableAnnotationComposer a) f,
  ) {
    final $$ReadChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readChapters,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.readChapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scanReleasesRefs<T extends Object>(
    Expression<T> Function($$ScanReleasesTableAnnotationComposer a) f,
  ) {
    final $$ScanReleasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scanReleases,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanReleasesTableAnnotationComposer(
            $db: $db,
            $table: $db.scanReleases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SeriesTableTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $SeriesTableTable,
          SeriesRow,
          $$SeriesTableTableFilterComposer,
          $$SeriesTableTableOrderingComposer,
          $$SeriesTableTableAnnotationComposer,
          $$SeriesTableTableCreateCompanionBuilder,
          $$SeriesTableTableUpdateCompanionBuilder,
          (SeriesRow, $$SeriesTableTableReferences),
          SeriesRow,
          PrefetchHooks Function({
            bool categoryId,
            bool seriesTitlesRefs,
            bool itemsRefs,
            bool wishesRefs,
            bool scanFollowsRefs,
            bool readChaptersRefs,
            bool scanReleasesRefs,
          })
        > {
  $$SeriesTableTableTableManager(_$AkashicDatabase db, $SeriesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<int?> publishedVolumes = const Value.absent(),
                Value<String?> sourceKey = const Value.absent(),
                Value<String?> externalWorkId = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeriesTableCompanion(
                id: id,
                categoryId: categoryId,
                originalLanguage: originalLanguage,
                creator: creator,
                publishedVolumes: publishedVolumes,
                sourceKey: sourceKey,
                externalWorkId: externalWorkId,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryId,
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<int?> publishedVolumes = const Value.absent(),
                Value<String?> sourceKey = const Value.absent(),
                Value<String?> externalWorkId = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeriesTableCompanion.insert(
                id: id,
                categoryId: categoryId,
                originalLanguage: originalLanguage,
                creator: creator,
                publishedVolumes: publishedVolumes,
                sourceKey: sourceKey,
                externalWorkId: externalWorkId,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SeriesTableTable, SeriesRow>(table),
                  $$SeriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                seriesTitlesRefs = false,
                itemsRefs = false,
                wishesRefs = false,
                scanFollowsRefs = false,
                readChaptersRefs = false,
                scanReleasesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (seriesTitlesRefs) db.seriesTitles,
                    if (itemsRefs) db.items,
                    if (wishesRefs) db.wishes,
                    if (scanFollowsRefs) db.scanFollows,
                    if (readChaptersRefs) db.readChapters,
                    if (scanReleasesRefs) db.scanReleases,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$SeriesTableTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$SeriesTableTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (seriesTitlesRefs)
                        await $_getPrefetchedData<
                          SeriesRow,
                          $SeriesTableTable,
                          SeriesTitleRow
                        >(
                          currentTable: table,
                          referencedTable: $$SeriesTableTableReferences
                              ._seriesTitlesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).seriesTitlesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seriesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemsRefs)
                        await $_getPrefetchedData<
                          SeriesRow,
                          $SeriesTableTable,
                          ItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$SeriesTableTableReferences
                              ._itemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).itemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seriesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (wishesRefs)
                        await $_getPrefetchedData<
                          SeriesRow,
                          $SeriesTableTable,
                          WishRow
                        >(
                          currentTable: table,
                          referencedTable: $$SeriesTableTableReferences
                              ._wishesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).wishesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seriesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (scanFollowsRefs)
                        await $_getPrefetchedData<
                          SeriesRow,
                          $SeriesTableTable,
                          ScanFollowRow
                        >(
                          currentTable: table,
                          referencedTable: $$SeriesTableTableReferences
                              ._scanFollowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).scanFollowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seriesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readChaptersRefs)
                        await $_getPrefetchedData<
                          SeriesRow,
                          $SeriesTableTable,
                          ReadChapterRow
                        >(
                          currentTable: table,
                          referencedTable: $$SeriesTableTableReferences
                              ._readChaptersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).readChaptersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seriesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (scanReleasesRefs)
                        await $_getPrefetchedData<
                          SeriesRow,
                          $SeriesTableTable,
                          ScanReleaseRow
                        >(
                          currentTable: table,
                          referencedTable: $$SeriesTableTableReferences
                              ._scanReleasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).scanReleasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seriesId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SeriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $SeriesTableTable,
      SeriesRow,
      $$SeriesTableTableFilterComposer,
      $$SeriesTableTableOrderingComposer,
      $$SeriesTableTableAnnotationComposer,
      $$SeriesTableTableCreateCompanionBuilder,
      $$SeriesTableTableUpdateCompanionBuilder,
      (SeriesRow, $$SeriesTableTableReferences),
      SeriesRow,
      PrefetchHooks Function({
        bool categoryId,
        bool seriesTitlesRefs,
        bool itemsRefs,
        bool wishesRefs,
        bool scanFollowsRefs,
        bool readChaptersRefs,
        bool scanReleasesRefs,
      })
    >;
typedef $$SeriesTitlesTableCreateCompanionBuilder =
    SeriesTitlesCompanion Function({
      required String seriesId,
      required String languageCode,
      required String title,
      Value<int> rowid,
    });
typedef $$SeriesTitlesTableUpdateCompanionBuilder =
    SeriesTitlesCompanion Function({
      Value<String> seriesId,
      Value<String> languageCode,
      Value<String> title,
      Value<int> rowid,
    });

final class $$SeriesTitlesTableReferences
    extends
        BaseReferences<_$AkashicDatabase, $SeriesTitlesTable, SeriesTitleRow> {
  $$SeriesTitlesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SeriesTableTable _seriesIdTable(_$AkashicDatabase db) =>
      db.seriesTable.createAlias('series_titles__series_id__series__id');

  $$SeriesTableTableProcessedTableManager get seriesId {
    final $_column = $_itemColumn<String>('series_id')!;

    final manager = $$SeriesTableTableTableManager(
      $_db,
      $_db.seriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SeriesTitlesTableFilterComposer
    extends Composer<_$AkashicDatabase, $SeriesTitlesTable> {
  $$SeriesTitlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  $$SeriesTableTableFilterComposer get seriesId {
    final $$SeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableFilterComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTitlesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $SeriesTitlesTable> {
  $$SeriesTitlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeriesTableTableOrderingComposer get seriesId {
    final $$SeriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTitlesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $SeriesTitlesTable> {
  $$SeriesTitlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  $$SeriesTableTableAnnotationComposer get seriesId {
    final $$SeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTitlesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $SeriesTitlesTable,
          SeriesTitleRow,
          $$SeriesTitlesTableFilterComposer,
          $$SeriesTitlesTableOrderingComposer,
          $$SeriesTitlesTableAnnotationComposer,
          $$SeriesTitlesTableCreateCompanionBuilder,
          $$SeriesTitlesTableUpdateCompanionBuilder,
          (SeriesTitleRow, $$SeriesTitlesTableReferences),
          SeriesTitleRow,
          PrefetchHooks Function({bool seriesId})
        > {
  $$SeriesTitlesTableTableManager(
    _$AkashicDatabase db,
    $SeriesTitlesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeriesTitlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeriesTitlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeriesTitlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> seriesId = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeriesTitlesCompanion(
                seriesId: seriesId,
                languageCode: languageCode,
                title: title,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String seriesId,
                required String languageCode,
                required String title,
                Value<int> rowid = const Value.absent(),
              }) => SeriesTitlesCompanion.insert(
                seriesId: seriesId,
                languageCode: languageCode,
                title: title,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SeriesTitlesTable, SeriesTitleRow>(table),
                  $$SeriesTitlesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seriesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (seriesId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.seriesId,
                        referencedTable: $$SeriesTitlesTableReferences
                            ._seriesIdTable(db),
                        referencedColumn: $$SeriesTitlesTableReferences
                            ._seriesIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SeriesTitlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $SeriesTitlesTable,
      SeriesTitleRow,
      $$SeriesTitlesTableFilterComposer,
      $$SeriesTitlesTableOrderingComposer,
      $$SeriesTitlesTableAnnotationComposer,
      $$SeriesTitlesTableCreateCompanionBuilder,
      $$SeriesTitlesTableUpdateCompanionBuilder,
      (SeriesTitleRow, $$SeriesTitlesTableReferences),
      SeriesTitleRow,
      PrefetchHooks Function({bool seriesId})
    >;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  required String id,
  required String categoryId,
  Value<String?> seriesId,
  Value<int?> volumeNumber,
  Value<String?> originalLanguage,
  Value<String?> creator,
  Value<int?> year,
  Value<String?> publisher,
  Value<String?> imagePath,
  Value<int?> spineColorValue,
  Value<int?> rating,
  Value<String?> groupKey,
  Value<String?> sourceKey,
  Value<String?> externalWorkId,
  Value<String?> cardKind,
  Value<String?> progressStatus,
  Value<String?> progressChapter,
  Value<int?> progressPage,
  Value<int?> marketValueCents,
  Value<String?> marketValueCurrency,
  Value<DateTime?> marketValuedAt,
  Value<DateTime?> preorderDueOn,
  Value<int?> preorderDepositCents,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<String> id,
  Value<String> categoryId,
  Value<String?> seriesId,
  Value<int?> volumeNumber,
  Value<String?> originalLanguage,
  Value<String?> creator,
  Value<int?> year,
  Value<String?> publisher,
  Value<String?> imagePath,
  Value<int?> spineColorValue,
  Value<int?> rating,
  Value<String?> groupKey,
  Value<String?> sourceKey,
  Value<String?> externalWorkId,
  Value<String?> cardKind,
  Value<String?> progressStatus,
  Value<String?> progressChapter,
  Value<int?> progressPage,
  Value<int?> marketValueCents,
  Value<String?> marketValueCurrency,
  Value<DateTime?> marketValuedAt,
  Value<DateTime?> preorderDueOn,
  Value<int?> preorderDepositCents,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$AkashicDatabase, $ItemsTable, ItemRow> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AkashicDatabase db) =>
      db.categories.createAlias('items__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SeriesTableTable _seriesIdTable(_$AkashicDatabase db) =>
      db.seriesTable.createAlias('items__series_id__series__id');

  $$SeriesTableTableProcessedTableManager? get seriesId {
    final $_column = $_itemColumn<String>('series_id');
    if ($_column == null) return null;
    final manager = $$SeriesTableTableTableManager(
      $_db,
      $_db.seriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItemTitlesTable, List<ItemTitleRow>>
  _itemTitlesRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.itemTitles,
    aliasName: 'items__id__item_titles__item_id',
  );

  $$ItemTitlesTableProcessedTableManager get itemTitlesRefs {
    final manager = $$ItemTitlesTableTableManager(
      $_db,
      $_db.itemTitles,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemTitlesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CopiesTable, List<CopyRow>> _copiesRefsTable(
    _$AkashicDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.copies,
    aliasName: 'items__id__copies__item_id',
  );

  $$CopiesTableProcessedTableManager get copiesRefs {
    final manager = $$CopiesTableTableManager(
      $_db,
      $_db.copies,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_copiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeckCardsTable, List<DeckCardRow>>
  _deckCardsRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.deckCards,
    aliasName: 'items__id__deck_cards__item_id',
  );

  $$DeckCardsTableProcessedTableManager get deckCardsRefs {
    final manager = $$DeckCardsTableTableManager(
      $_db,
      $_db.deckCards,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_deckCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemDetailsTable, List<ItemDetailsRow>>
  _itemDetailsRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.itemDetails,
    aliasName: 'items__id__item_details__item_id',
  );

  $$ItemDetailsTableProcessedTableManager get itemDetailsRefs {
    final manager = $$ItemDetailsTableTableManager(
      $_db,
      $_db.itemDetails,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemDetailsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemPhotosTable, List<ItemPhotoRow>>
  _itemPhotosRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.itemPhotos,
    aliasName: 'items__id__item_photos__item_id',
  );

  $$ItemPhotosTableProcessedTableManager get itemPhotosRefs {
    final manager = $$ItemPhotosTableTableManager(
      $_db,
      $_db.itemPhotos,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SteamGameStatsTable, List<SteamGameStatsRow>>
  _steamGameStatsRefsTable(_$AkashicDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.steamGameStats,
        aliasName: 'items__id__steam_game_stats__item_id',
      );

  $$SteamGameStatsTableProcessedTableManager get steamGameStatsRefs {
    final manager = $$SteamGameStatsTableTableManager(
      $_db,
      $_db.steamGameStats,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_steamGameStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PriceAlertsTable, List<PriceAlertRow>>
  _priceAlertsRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.priceAlerts,
    aliasName: 'items__id__price_alerts__item_id',
  );

  $$PriceAlertsTableProcessedTableManager get priceAlertsRefs {
    final manager = $$PriceAlertsTableTableManager(
      $_db,
      $_db.priceAlerts,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_priceAlertsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ItemValueSnapshotsTable,
    List<ItemValueSnapshotRow>
  >
  _itemValueSnapshotsRefsTable(_$AkashicDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.itemValueSnapshots,
        aliasName: 'items__id__item_value_snapshots__item_id',
      );

  $$ItemValueSnapshotsTableProcessedTableManager get itemValueSnapshotsRefs {
    final manager = $$ItemValueSnapshotsTableTableManager(
      $_db,
      $_db.itemValueSnapshots,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _itemValueSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemTagsTable, List<ItemTagRow>>
  _itemTagsRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.itemTags,
    aliasName: 'items__id__item_tags__item_id',
  );

  $$ItemTagsTableProcessedTableManager get itemTagsRefs {
    final manager = $$ItemTagsTableTableManager(
      $_db,
      $_db.itemTags,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemsTableFilterComposer
    extends Composer<_$AkashicDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spineColorValue => $composableBuilder(
    column: $table.spineColorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupKey => $composableBuilder(
    column: $table.groupKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardKind => $composableBuilder(
    column: $table.cardKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressStatus => $composableBuilder(
    column: $table.progressStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressChapter => $composableBuilder(
    column: $table.progressChapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressPage => $composableBuilder(
    column: $table.progressPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get marketValueCents => $composableBuilder(
    column: $table.marketValueCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marketValueCurrency => $composableBuilder(
    column: $table.marketValueCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get marketValuedAt => $composableBuilder(
    column: $table.marketValuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get preorderDueOn => $composableBuilder(
    column: $table.preorderDueOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preorderDepositCents => $composableBuilder(
    column: $table.preorderDepositCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeriesTableTableFilterComposer get seriesId {
    final $$SeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableFilterComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itemTitlesRefs(
    Expression<bool> Function($$ItemTitlesTableFilterComposer f) f,
  ) {
    final $$ItemTitlesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemTitles,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemTitlesTableFilterComposer(
            $db: $db,
            $table: $db.itemTitles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> copiesRefs(
    Expression<bool> Function($$CopiesTableFilterComposer f) f,
  ) {
    final $$CopiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableFilterComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deckCardsRefs(
    Expression<bool> Function($$DeckCardsTableFilterComposer f) f,
  ) {
    final $$DeckCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deckCards,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckCardsTableFilterComposer(
            $db: $db,
            $table: $db.deckCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemDetailsRefs(
    Expression<bool> Function($$ItemDetailsTableFilterComposer f) f,
  ) {
    final $$ItemDetailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemDetails,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemDetailsTableFilterComposer(
            $db: $db,
            $table: $db.itemDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemPhotosRefs(
    Expression<bool> Function($$ItemPhotosTableFilterComposer f) f,
  ) {
    final $$ItemPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableFilterComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> steamGameStatsRefs(
    Expression<bool> Function($$SteamGameStatsTableFilterComposer f) f,
  ) {
    final $$SteamGameStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.steamGameStats,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SteamGameStatsTableFilterComposer(
            $db: $db,
            $table: $db.steamGameStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> priceAlertsRefs(
    Expression<bool> Function($$PriceAlertsTableFilterComposer f) f,
  ) {
    final $$PriceAlertsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.priceAlerts,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PriceAlertsTableFilterComposer(
            $db: $db,
            $table: $db.priceAlerts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemValueSnapshotsRefs(
    Expression<bool> Function($$ItemValueSnapshotsTableFilterComposer f) f,
  ) {
    final $$ItemValueSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemValueSnapshots,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemValueSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.itemValueSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemTagsRefs(
    Expression<bool> Function($$ItemTagsTableFilterComposer f) f,
  ) {
    final $$ItemTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemTags,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemTagsTableFilterComposer(
            $db: $db,
            $table: $db.itemTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spineColorValue => $composableBuilder(
    column: $table.spineColorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupKey => $composableBuilder(
    column: $table.groupKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardKind => $composableBuilder(
    column: $table.cardKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressStatus => $composableBuilder(
    column: $table.progressStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressChapter => $composableBuilder(
    column: $table.progressChapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressPage => $composableBuilder(
    column: $table.progressPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get marketValueCents => $composableBuilder(
    column: $table.marketValueCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marketValueCurrency => $composableBuilder(
    column: $table.marketValueCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get marketValuedAt => $composableBuilder(
    column: $table.marketValuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get preorderDueOn => $composableBuilder(
    column: $table.preorderDueOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preorderDepositCents => $composableBuilder(
    column: $table.preorderDepositCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeriesTableTableOrderingComposer get seriesId {
    final $$SeriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get spineColorValue => $composableBuilder(
    column: $table.spineColorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get groupKey =>
      $composableBuilder(column: $table.groupKey, builder: (column) => column);

  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardKind =>
      $composableBuilder(column: $table.cardKind, builder: (column) => column);

  GeneratedColumn<String> get progressStatus => $composableBuilder(
    column: $table.progressStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get progressChapter => $composableBuilder(
    column: $table.progressChapter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressPage => $composableBuilder(
    column: $table.progressPage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get marketValueCents => $composableBuilder(
    column: $table.marketValueCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get marketValueCurrency => $composableBuilder(
    column: $table.marketValueCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get marketValuedAt => $composableBuilder(
    column: $table.marketValuedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get preorderDueOn => $composableBuilder(
    column: $table.preorderDueOn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preorderDepositCents => $composableBuilder(
    column: $table.preorderDepositCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeriesTableTableAnnotationComposer get seriesId {
    final $$SeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itemTitlesRefs<T extends Object>(
    Expression<T> Function($$ItemTitlesTableAnnotationComposer a) f,
  ) {
    final $$ItemTitlesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemTitles,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemTitlesTableAnnotationComposer(
            $db: $db,
            $table: $db.itemTitles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> copiesRefs<T extends Object>(
    Expression<T> Function($$CopiesTableAnnotationComposer a) f,
  ) {
    final $$CopiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableAnnotationComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deckCardsRefs<T extends Object>(
    Expression<T> Function($$DeckCardsTableAnnotationComposer a) f,
  ) {
    final $$DeckCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deckCards,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.deckCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemDetailsRefs<T extends Object>(
    Expression<T> Function($$ItemDetailsTableAnnotationComposer a) f,
  ) {
    final $$ItemDetailsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemDetails,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemDetailsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemPhotosRefs<T extends Object>(
    Expression<T> Function($$ItemPhotosTableAnnotationComposer a) f,
  ) {
    final $$ItemPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> steamGameStatsRefs<T extends Object>(
    Expression<T> Function($$SteamGameStatsTableAnnotationComposer a) f,
  ) {
    final $$SteamGameStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.steamGameStats,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SteamGameStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.steamGameStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> priceAlertsRefs<T extends Object>(
    Expression<T> Function($$PriceAlertsTableAnnotationComposer a) f,
  ) {
    final $$PriceAlertsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.priceAlerts,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PriceAlertsTableAnnotationComposer(
            $db: $db,
            $table: $db.priceAlerts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemValueSnapshotsRefs<T extends Object>(
    Expression<T> Function($$ItemValueSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$ItemValueSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.itemValueSnapshots,
          getReferencedColumn: (t) => t.itemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ItemValueSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.itemValueSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> itemTagsRefs<T extends Object>(
    Expression<T> Function($$ItemTagsTableAnnotationComposer a) f,
  ) {
    final $$ItemTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemTags,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ItemsTable,
          ItemRow,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (ItemRow, $$ItemsTableReferences),
          ItemRow,
          PrefetchHooks Function({
            bool categoryId,
            bool seriesId,
            bool itemTitlesRefs,
            bool copiesRefs,
            bool deckCardsRefs,
            bool itemDetailsRefs,
            bool itemPhotosRefs,
            bool steamGameStatsRefs,
            bool priceAlertsRefs,
            bool itemValueSnapshotsRefs,
            bool itemTagsRefs,
          })
        > {
  $$ItemsTableTableManager(_$AkashicDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> seriesId = const Value.absent(),
                Value<int?> volumeNumber = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int?> spineColorValue = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> groupKey = const Value.absent(),
                Value<String?> sourceKey = const Value.absent(),
                Value<String?> externalWorkId = const Value.absent(),
                Value<String?> cardKind = const Value.absent(),
                Value<String?> progressStatus = const Value.absent(),
                Value<String?> progressChapter = const Value.absent(),
                Value<int?> progressPage = const Value.absent(),
                Value<int?> marketValueCents = const Value.absent(),
                Value<String?> marketValueCurrency = const Value.absent(),
                Value<DateTime?> marketValuedAt = const Value.absent(),
                Value<DateTime?> preorderDueOn = const Value.absent(),
                Value<int?> preorderDepositCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                categoryId: categoryId,
                seriesId: seriesId,
                volumeNumber: volumeNumber,
                originalLanguage: originalLanguage,
                creator: creator,
                year: year,
                publisher: publisher,
                imagePath: imagePath,
                spineColorValue: spineColorValue,
                rating: rating,
                groupKey: groupKey,
                sourceKey: sourceKey,
                externalWorkId: externalWorkId,
                cardKind: cardKind,
                progressStatus: progressStatus,
                progressChapter: progressChapter,
                progressPage: progressPage,
                marketValueCents: marketValueCents,
                marketValueCurrency: marketValueCurrency,
                marketValuedAt: marketValuedAt,
                preorderDueOn: preorderDueOn,
                preorderDepositCents: preorderDepositCents,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryId,
                Value<String?> seriesId = const Value.absent(),
                Value<int?> volumeNumber = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int?> spineColorValue = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> groupKey = const Value.absent(),
                Value<String?> sourceKey = const Value.absent(),
                Value<String?> externalWorkId = const Value.absent(),
                Value<String?> cardKind = const Value.absent(),
                Value<String?> progressStatus = const Value.absent(),
                Value<String?> progressChapter = const Value.absent(),
                Value<int?> progressPage = const Value.absent(),
                Value<int?> marketValueCents = const Value.absent(),
                Value<String?> marketValueCurrency = const Value.absent(),
                Value<DateTime?> marketValuedAt = const Value.absent(),
                Value<DateTime?> preorderDueOn = const Value.absent(),
                Value<int?> preorderDepositCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                categoryId: categoryId,
                seriesId: seriesId,
                volumeNumber: volumeNumber,
                originalLanguage: originalLanguage,
                creator: creator,
                year: year,
                publisher: publisher,
                imagePath: imagePath,
                spineColorValue: spineColorValue,
                rating: rating,
                groupKey: groupKey,
                sourceKey: sourceKey,
                externalWorkId: externalWorkId,
                cardKind: cardKind,
                progressStatus: progressStatus,
                progressChapter: progressChapter,
                progressPage: progressPage,
                marketValueCents: marketValueCents,
                marketValueCurrency: marketValueCurrency,
                marketValuedAt: marketValuedAt,
                preorderDueOn: preorderDueOn,
                preorderDepositCents: preorderDepositCents,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, ItemRow>(table),
                  $$ItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                seriesId = false,
                itemTitlesRefs = false,
                copiesRefs = false,
                deckCardsRefs = false,
                itemDetailsRefs = false,
                itemPhotosRefs = false,
                steamGameStatsRefs = false,
                priceAlertsRefs = false,
                itemValueSnapshotsRefs = false,
                itemTagsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itemTitlesRefs) db.itemTitles,
                    if (copiesRefs) db.copies,
                    if (deckCardsRefs) db.deckCards,
                    if (itemDetailsRefs) db.itemDetails,
                    if (itemPhotosRefs) db.itemPhotos,
                    if (steamGameStatsRefs) db.steamGameStats,
                    if (priceAlertsRefs) db.priceAlerts,
                    if (itemValueSnapshotsRefs) db.itemValueSnapshots,
                    if (itemTagsRefs) db.itemTags,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$ItemsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$ItemsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (seriesId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.seriesId,
                            referencedTable: $$ItemsTableReferences
                                ._seriesIdTable(db),
                            referencedColumn: $$ItemsTableReferences
                                ._seriesIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itemTitlesRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          ItemTitleRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemTitlesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemTitlesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (copiesRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          CopyRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._copiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(db, table, p0).copiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deckCardsRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          DeckCardRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._deckCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).deckCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemDetailsRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          ItemDetailsRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemDetailsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemDetailsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemPhotosRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          ItemPhotoRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (steamGameStatsRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          SteamGameStatsRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._steamGameStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).steamGameStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (priceAlertsRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          PriceAlertRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._priceAlertsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).priceAlertsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemValueSnapshotsRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          ItemValueSnapshotRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemValueSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemValueSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemTagsRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          ItemTagRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ItemsTable,
      ItemRow,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (ItemRow, $$ItemsTableReferences),
      ItemRow,
      PrefetchHooks Function({
        bool categoryId,
        bool seriesId,
        bool itemTitlesRefs,
        bool copiesRefs,
        bool deckCardsRefs,
        bool itemDetailsRefs,
        bool itemPhotosRefs,
        bool steamGameStatsRefs,
        bool priceAlertsRefs,
        bool itemValueSnapshotsRefs,
        bool itemTagsRefs,
      })
    >;
typedef $$ItemTitlesTableCreateCompanionBuilder = ItemTitlesCompanion Function({
  required String itemId,
  required String languageCode,
  required String title,
  Value<int> rowid,
});
typedef $$ItemTitlesTableUpdateCompanionBuilder = ItemTitlesCompanion Function({
  Value<String> itemId,
  Value<String> languageCode,
  Value<String> title,
  Value<int> rowid,
});

final class $$ItemTitlesTableReferences
    extends BaseReferences<_$AkashicDatabase, $ItemTitlesTable, ItemTitleRow> {
  $$ItemTitlesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AkashicDatabase db) =>
      db.items.createAlias('item_titles__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemTitlesTableFilterComposer
    extends Composer<_$AkashicDatabase, $ItemTitlesTable> {
  $$ItemTitlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemTitlesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ItemTitlesTable> {
  $$ItemTitlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemTitlesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ItemTitlesTable> {
  $$ItemTitlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemTitlesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ItemTitlesTable,
          ItemTitleRow,
          $$ItemTitlesTableFilterComposer,
          $$ItemTitlesTableOrderingComposer,
          $$ItemTitlesTableAnnotationComposer,
          $$ItemTitlesTableCreateCompanionBuilder,
          $$ItemTitlesTableUpdateCompanionBuilder,
          (ItemTitleRow, $$ItemTitlesTableReferences),
          ItemTitleRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$ItemTitlesTableTableManager(_$AkashicDatabase db, $ItemTitlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemTitlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemTitlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemTitlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemTitlesCompanion(
                itemId: itemId,
                languageCode: languageCode,
                title: title,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String languageCode,
                required String title,
                Value<int> rowid = const Value.absent(),
              }) => ItemTitlesCompanion.insert(
                itemId: itemId,
                languageCode: languageCode,
                title: title,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemTitlesTable, ItemTitleRow>(table),
                  $$ItemTitlesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ItemTitlesTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$ItemTitlesTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemTitlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ItemTitlesTable,
      ItemTitleRow,
      $$ItemTitlesTableFilterComposer,
      $$ItemTitlesTableOrderingComposer,
      $$ItemTitlesTableAnnotationComposer,
      $$ItemTitlesTableCreateCompanionBuilder,
      $$ItemTitlesTableUpdateCompanionBuilder,
      (ItemTitleRow, $$ItemTitlesTableReferences),
      ItemTitleRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$CopiesTableCreateCompanionBuilder = CopiesCompanion Function({
  required String id,
  required String itemId,
  Value<String?> edition,
  Value<int?> pricePaidCents,
  Value<String?> location,
  Value<String?> barcode,
  Value<String?> externalEditionId,
  Value<String?> loanedTo,
  Value<DateTime?> loanedSince,
  Value<DateTime?> loanDueOn,
  Value<bool> loanRemindsAtDue,
  Value<bool> loanFollowsUp,
  Value<bool> isOpened,
  Value<DateTime?> purchasedOn,
  Value<String?> purchaseChannel,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CopiesTableUpdateCompanionBuilder = CopiesCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<String?> edition,
  Value<int?> pricePaidCents,
  Value<String?> location,
  Value<String?> barcode,
  Value<String?> externalEditionId,
  Value<String?> loanedTo,
  Value<DateTime?> loanedSince,
  Value<DateTime?> loanDueOn,
  Value<bool> loanRemindsAtDue,
  Value<bool> loanFollowsUp,
  Value<bool> isOpened,
  Value<DateTime?> purchasedOn,
  Value<String?> purchaseChannel,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CopiesTableReferences
    extends BaseReferences<_$AkashicDatabase, $CopiesTable, CopyRow> {
  $$CopiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AkashicDatabase db) =>
      db.items.createAlias('copies__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CopyConditionsTable, List<CopyConditionRow>>
  _copyConditionsRefsTable(_$AkashicDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.copyConditions,
        aliasName: 'copies__id__copy_conditions__copy_id',
      );

  $$CopyConditionsTableProcessedTableManager get copyConditionsRefs {
    final manager = $$CopyConditionsTableTableManager(
      $_db,
      $_db.copyConditions,
    ).filter((f) => f.copyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_copyConditionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemPhotosTable, List<ItemPhotoRow>>
  _itemPhotosRefsTable(_$AkashicDatabase db) => MultiTypedResultKey.fromTable(
    db.itemPhotos,
    aliasName: 'copies__id__item_photos__copy_id',
  );

  $$ItemPhotosTableProcessedTableManager get itemPhotosRefs {
    final manager = $$ItemPhotosTableTableManager(
      $_db,
      $_db.itemPhotos,
    ).filter((f) => f.copyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CopiesTableFilterComposer
    extends Composer<_$AkashicDatabase, $CopiesTable> {
  $$CopiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pricePaidCents => $composableBuilder(
    column: $table.pricePaidCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalEditionId => $composableBuilder(
    column: $table.externalEditionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loanedTo => $composableBuilder(
    column: $table.loanedTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loanedSince => $composableBuilder(
    column: $table.loanedSince,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loanDueOn => $composableBuilder(
    column: $table.loanDueOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get loanRemindsAtDue => $composableBuilder(
    column: $table.loanRemindsAtDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get loanFollowsUp => $composableBuilder(
    column: $table.loanFollowsUp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOpened => $composableBuilder(
    column: $table.isOpened,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedOn => $composableBuilder(
    column: $table.purchasedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseChannel => $composableBuilder(
    column: $table.purchaseChannel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> copyConditionsRefs(
    Expression<bool> Function($$CopyConditionsTableFilterComposer f) f,
  ) {
    final $$CopyConditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copyConditions,
      getReferencedColumn: (t) => t.copyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopyConditionsTableFilterComposer(
            $db: $db,
            $table: $db.copyConditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemPhotosRefs(
    Expression<bool> Function($$ItemPhotosTableFilterComposer f) f,
  ) {
    final $$ItemPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.copyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableFilterComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CopiesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $CopiesTable> {
  $$CopiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pricePaidCents => $composableBuilder(
    column: $table.pricePaidCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalEditionId => $composableBuilder(
    column: $table.externalEditionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loanedTo => $composableBuilder(
    column: $table.loanedTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loanedSince => $composableBuilder(
    column: $table.loanedSince,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loanDueOn => $composableBuilder(
    column: $table.loanDueOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get loanRemindsAtDue => $composableBuilder(
    column: $table.loanRemindsAtDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get loanFollowsUp => $composableBuilder(
    column: $table.loanFollowsUp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOpened => $composableBuilder(
    column: $table.isOpened,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedOn => $composableBuilder(
    column: $table.purchasedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseChannel => $composableBuilder(
    column: $table.purchaseChannel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopiesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $CopiesTable> {
  $$CopiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get edition =>
      $composableBuilder(column: $table.edition, builder: (column) => column);

  GeneratedColumn<int> get pricePaidCents => $composableBuilder(
    column: $table.pricePaidCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get externalEditionId => $composableBuilder(
    column: $table.externalEditionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get loanedTo =>
      $composableBuilder(column: $table.loanedTo, builder: (column) => column);

  GeneratedColumn<DateTime> get loanedSince => $composableBuilder(
    column: $table.loanedSince,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get loanDueOn =>
      $composableBuilder(column: $table.loanDueOn, builder: (column) => column);

  GeneratedColumn<bool> get loanRemindsAtDue => $composableBuilder(
    column: $table.loanRemindsAtDue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get loanFollowsUp => $composableBuilder(
    column: $table.loanFollowsUp,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOpened =>
      $composableBuilder(column: $table.isOpened, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedOn => $composableBuilder(
    column: $table.purchasedOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purchaseChannel => $composableBuilder(
    column: $table.purchaseChannel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> copyConditionsRefs<T extends Object>(
    Expression<T> Function($$CopyConditionsTableAnnotationComposer a) f,
  ) {
    final $$CopyConditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.copyConditions,
      getReferencedColumn: (t) => t.copyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopyConditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.copyConditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemPhotosRefs<T extends Object>(
    Expression<T> Function($$ItemPhotosTableAnnotationComposer a) f,
  ) {
    final $$ItemPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.copyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CopiesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $CopiesTable,
          CopyRow,
          $$CopiesTableFilterComposer,
          $$CopiesTableOrderingComposer,
          $$CopiesTableAnnotationComposer,
          $$CopiesTableCreateCompanionBuilder,
          $$CopiesTableUpdateCompanionBuilder,
          (CopyRow, $$CopiesTableReferences),
          CopyRow,
          PrefetchHooks Function({
            bool itemId,
            bool copyConditionsRefs,
            bool itemPhotosRefs,
          })
        > {
  $$CopiesTableTableManager(_$AkashicDatabase db, $CopiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CopiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CopiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CopiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String?> edition = const Value.absent(),
                Value<int?> pricePaidCents = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> externalEditionId = const Value.absent(),
                Value<String?> loanedTo = const Value.absent(),
                Value<DateTime?> loanedSince = const Value.absent(),
                Value<DateTime?> loanDueOn = const Value.absent(),
                Value<bool> loanRemindsAtDue = const Value.absent(),
                Value<bool> loanFollowsUp = const Value.absent(),
                Value<bool> isOpened = const Value.absent(),
                Value<DateTime?> purchasedOn = const Value.absent(),
                Value<String?> purchaseChannel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CopiesCompanion(
                id: id,
                itemId: itemId,
                edition: edition,
                pricePaidCents: pricePaidCents,
                location: location,
                barcode: barcode,
                externalEditionId: externalEditionId,
                loanedTo: loanedTo,
                loanedSince: loanedSince,
                loanDueOn: loanDueOn,
                loanRemindsAtDue: loanRemindsAtDue,
                loanFollowsUp: loanFollowsUp,
                isOpened: isOpened,
                purchasedOn: purchasedOn,
                purchaseChannel: purchaseChannel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemId,
                Value<String?> edition = const Value.absent(),
                Value<int?> pricePaidCents = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> externalEditionId = const Value.absent(),
                Value<String?> loanedTo = const Value.absent(),
                Value<DateTime?> loanedSince = const Value.absent(),
                Value<DateTime?> loanDueOn = const Value.absent(),
                Value<bool> loanRemindsAtDue = const Value.absent(),
                Value<bool> loanFollowsUp = const Value.absent(),
                Value<bool> isOpened = const Value.absent(),
                Value<DateTime?> purchasedOn = const Value.absent(),
                Value<String?> purchaseChannel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CopiesCompanion.insert(
                id: id,
                itemId: itemId,
                edition: edition,
                pricePaidCents: pricePaidCents,
                location: location,
                barcode: barcode,
                externalEditionId: externalEditionId,
                loanedTo: loanedTo,
                loanedSince: loanedSince,
                loanDueOn: loanDueOn,
                loanRemindsAtDue: loanRemindsAtDue,
                loanFollowsUp: loanFollowsUp,
                isOpened: isOpened,
                purchasedOn: purchasedOn,
                purchaseChannel: purchaseChannel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CopiesTable, CopyRow>(table),
                  $$CopiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                itemId = false,
                copyConditionsRefs = false,
                itemPhotosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (copyConditionsRefs) db.copyConditions,
                    if (itemPhotosRefs) db.itemPhotos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (itemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.itemId,
                            referencedTable: $$CopiesTableReferences
                                ._itemIdTable(db),
                            referencedColumn: $$CopiesTableReferences
                                ._itemIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (copyConditionsRefs)
                        await $_getPrefetchedData<
                          CopyRow,
                          $CopiesTable,
                          CopyConditionRow
                        >(
                          currentTable: table,
                          referencedTable: $$CopiesTableReferences
                              ._copyConditionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CopiesTableReferences(
                                db,
                                table,
                                p0,
                              ).copyConditionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.copyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemPhotosRefs)
                        await $_getPrefetchedData<
                          CopyRow,
                          $CopiesTable,
                          ItemPhotoRow
                        >(
                          currentTable: table,
                          referencedTable: $$CopiesTableReferences
                              ._itemPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CopiesTableReferences(
                                db,
                                table,
                                p0,
                              ).itemPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.copyId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CopiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $CopiesTable,
      CopyRow,
      $$CopiesTableFilterComposer,
      $$CopiesTableOrderingComposer,
      $$CopiesTableAnnotationComposer,
      $$CopiesTableCreateCompanionBuilder,
      $$CopiesTableUpdateCompanionBuilder,
      (CopyRow, $$CopiesTableReferences),
      CopyRow,
      PrefetchHooks Function({
        bool itemId,
        bool copyConditionsRefs,
        bool itemPhotosRefs,
      })
    >;
typedef $$CopyConditionsTableCreateCompanionBuilder =
    CopyConditionsCompanion Function({
      required String copyId,
      required String part,
      required String condition,
      Value<int> rowid,
    });
typedef $$CopyConditionsTableUpdateCompanionBuilder =
    CopyConditionsCompanion Function({
      Value<String> copyId,
      Value<String> part,
      Value<String> condition,
      Value<int> rowid,
    });

final class $$CopyConditionsTableReferences
    extends
        BaseReferences<
          _$AkashicDatabase,
          $CopyConditionsTable,
          CopyConditionRow
        > {
  $$CopyConditionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CopiesTable _copyIdTable(_$AkashicDatabase db) =>
      db.copies.createAlias('copy_conditions__copy_id__copies__id');

  $$CopiesTableProcessedTableManager get copyId {
    final $_column = $_itemColumn<String>('copy_id')!;

    final manager = $$CopiesTableTableManager(
      $_db,
      $_db.copies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_copyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CopyConditionsTableFilterComposer
    extends Composer<_$AkashicDatabase, $CopyConditionsTable> {
  $$CopyConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get part => $composableBuilder(
    column: $table.part,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  $$CopiesTableFilterComposer get copyId {
    final $$CopiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableFilterComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopyConditionsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $CopyConditionsTable> {
  $$CopyConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get part => $composableBuilder(
    column: $table.part,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  $$CopiesTableOrderingComposer get copyId {
    final $$CopiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableOrderingComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopyConditionsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $CopyConditionsTable> {
  $$CopyConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get part =>
      $composableBuilder(column: $table.part, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  $$CopiesTableAnnotationComposer get copyId {
    final $$CopiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableAnnotationComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CopyConditionsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $CopyConditionsTable,
          CopyConditionRow,
          $$CopyConditionsTableFilterComposer,
          $$CopyConditionsTableOrderingComposer,
          $$CopyConditionsTableAnnotationComposer,
          $$CopyConditionsTableCreateCompanionBuilder,
          $$CopyConditionsTableUpdateCompanionBuilder,
          (CopyConditionRow, $$CopyConditionsTableReferences),
          CopyConditionRow,
          PrefetchHooks Function({bool copyId})
        > {
  $$CopyConditionsTableTableManager(
    _$AkashicDatabase db,
    $CopyConditionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CopyConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CopyConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CopyConditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> copyId = const Value.absent(),
                Value<String> part = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CopyConditionsCompanion(
                copyId: copyId,
                part: part,
                condition: condition,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String copyId,
                required String part,
                required String condition,
                Value<int> rowid = const Value.absent(),
              }) => CopyConditionsCompanion.insert(
                copyId: copyId,
                part: part,
                condition: condition,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CopyConditionsTable, CopyConditionRow>(table),
                  $$CopyConditionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({copyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (copyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.copyId,
                        referencedTable: $$CopyConditionsTableReferences
                            ._copyIdTable(db),
                        referencedColumn: $$CopyConditionsTableReferences
                            ._copyIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CopyConditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $CopyConditionsTable,
      CopyConditionRow,
      $$CopyConditionsTableFilterComposer,
      $$CopyConditionsTableOrderingComposer,
      $$CopyConditionsTableAnnotationComposer,
      $$CopyConditionsTableCreateCompanionBuilder,
      $$CopyConditionsTableUpdateCompanionBuilder,
      (CopyConditionRow, $$CopyConditionsTableReferences),
      CopyConditionRow,
      PrefetchHooks Function({bool copyId})
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AkashicDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $PreferencesTable,
          PreferenceRow,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            PreferenceRow,
            BaseReferences<_$AkashicDatabase, $PreferencesTable, PreferenceRow>,
          ),
          PreferenceRow,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AkashicDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PreferencesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreferencesTable, PreferenceRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $PreferencesTable,
                    PreferenceRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $PreferencesTable,
      PreferenceRow,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        PreferenceRow,
        BaseReferences<_$AkashicDatabase, $PreferencesTable, PreferenceRow>,
      ),
      PreferenceRow,
      PrefetchHooks Function()
    >;
typedef $$DeckCardsTableCreateCompanionBuilder = DeckCardsCompanion Function({
  required String id,
  required String itemId,
  required String name,
  Value<String?> externalCardId,
  required int quantity,
  Value<String?> imageUrl,
  Value<String?> sourceKey,
  Value<int?> priceCents,
  Value<String?> priceCurrency,
  Value<DateTime?> pricedAt,
  Value<String?> typeLine,
  Value<String?> colorIdentity,
  Value<double?> manaValue,
  Value<bool> isCommander,
  Value<bool> isSecondaryCommander,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$DeckCardsTableUpdateCompanionBuilder = DeckCardsCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<String> name,
  Value<String?> externalCardId,
  Value<int> quantity,
  Value<String?> imageUrl,
  Value<String?> sourceKey,
  Value<int?> priceCents,
  Value<String?> priceCurrency,
  Value<DateTime?> pricedAt,
  Value<String?> typeLine,
  Value<String?> colorIdentity,
  Value<double?> manaValue,
  Value<bool> isCommander,
  Value<bool> isSecondaryCommander,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$DeckCardsTableReferences
    extends BaseReferences<_$AkashicDatabase, $DeckCardsTable, DeckCardRow> {
  $$DeckCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AkashicDatabase db) =>
      db.items.createAlias('deck_cards__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeckCardsTableFilterComposer
    extends Composer<_$AkashicDatabase, $DeckCardsTable> {
  $$DeckCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalCardId => $composableBuilder(
    column: $table.externalCardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceCurrency => $composableBuilder(
    column: $table.priceCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pricedAt => $composableBuilder(
    column: $table.pricedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeLine => $composableBuilder(
    column: $table.typeLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorIdentity => $composableBuilder(
    column: $table.colorIdentity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get manaValue => $composableBuilder(
    column: $table.manaValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCommander => $composableBuilder(
    column: $table.isCommander,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSecondaryCommander => $composableBuilder(
    column: $table.isSecondaryCommander,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeckCardsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $DeckCardsTable> {
  $$DeckCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalCardId => $composableBuilder(
    column: $table.externalCardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceCurrency => $composableBuilder(
    column: $table.priceCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pricedAt => $composableBuilder(
    column: $table.pricedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeLine => $composableBuilder(
    column: $table.typeLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorIdentity => $composableBuilder(
    column: $table.colorIdentity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get manaValue => $composableBuilder(
    column: $table.manaValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCommander => $composableBuilder(
    column: $table.isCommander,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSecondaryCommander => $composableBuilder(
    column: $table.isSecondaryCommander,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeckCardsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $DeckCardsTable> {
  $$DeckCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get externalCardId => $composableBuilder(
    column: $table.externalCardId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priceCurrency => $composableBuilder(
    column: $table.priceCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pricedAt =>
      $composableBuilder(column: $table.pricedAt, builder: (column) => column);

  GeneratedColumn<String> get typeLine =>
      $composableBuilder(column: $table.typeLine, builder: (column) => column);

  GeneratedColumn<String> get colorIdentity => $composableBuilder(
    column: $table.colorIdentity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get manaValue =>
      $composableBuilder(column: $table.manaValue, builder: (column) => column);

  GeneratedColumn<bool> get isCommander => $composableBuilder(
    column: $table.isCommander,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSecondaryCommander => $composableBuilder(
    column: $table.isSecondaryCommander,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeckCardsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $DeckCardsTable,
          DeckCardRow,
          $$DeckCardsTableFilterComposer,
          $$DeckCardsTableOrderingComposer,
          $$DeckCardsTableAnnotationComposer,
          $$DeckCardsTableCreateCompanionBuilder,
          $$DeckCardsTableUpdateCompanionBuilder,
          (DeckCardRow, $$DeckCardsTableReferences),
          DeckCardRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$DeckCardsTableTableManager(_$AkashicDatabase db, $DeckCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeckCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeckCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeckCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> externalCardId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> sourceKey = const Value.absent(),
                Value<int?> priceCents = const Value.absent(),
                Value<String?> priceCurrency = const Value.absent(),
                Value<DateTime?> pricedAt = const Value.absent(),
                Value<String?> typeLine = const Value.absent(),
                Value<String?> colorIdentity = const Value.absent(),
                Value<double?> manaValue = const Value.absent(),
                Value<bool> isCommander = const Value.absent(),
                Value<bool> isSecondaryCommander = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeckCardsCompanion(
                id: id,
                itemId: itemId,
                name: name,
                externalCardId: externalCardId,
                quantity: quantity,
                imageUrl: imageUrl,
                sourceKey: sourceKey,
                priceCents: priceCents,
                priceCurrency: priceCurrency,
                pricedAt: pricedAt,
                typeLine: typeLine,
                colorIdentity: colorIdentity,
                manaValue: manaValue,
                isCommander: isCommander,
                isSecondaryCommander: isSecondaryCommander,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemId,
                required String name,
                Value<String?> externalCardId = const Value.absent(),
                required int quantity,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> sourceKey = const Value.absent(),
                Value<int?> priceCents = const Value.absent(),
                Value<String?> priceCurrency = const Value.absent(),
                Value<DateTime?> pricedAt = const Value.absent(),
                Value<String?> typeLine = const Value.absent(),
                Value<String?> colorIdentity = const Value.absent(),
                Value<double?> manaValue = const Value.absent(),
                Value<bool> isCommander = const Value.absent(),
                Value<bool> isSecondaryCommander = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeckCardsCompanion.insert(
                id: id,
                itemId: itemId,
                name: name,
                externalCardId: externalCardId,
                quantity: quantity,
                imageUrl: imageUrl,
                sourceKey: sourceKey,
                priceCents: priceCents,
                priceCurrency: priceCurrency,
                pricedAt: pricedAt,
                typeLine: typeLine,
                colorIdentity: colorIdentity,
                manaValue: manaValue,
                isCommander: isCommander,
                isSecondaryCommander: isSecondaryCommander,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeckCardsTable, DeckCardRow>(table),
                  $$DeckCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$DeckCardsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$DeckCardsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeckCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $DeckCardsTable,
      DeckCardRow,
      $$DeckCardsTableFilterComposer,
      $$DeckCardsTableOrderingComposer,
      $$DeckCardsTableAnnotationComposer,
      $$DeckCardsTableCreateCompanionBuilder,
      $$DeckCardsTableUpdateCompanionBuilder,
      (DeckCardRow, $$DeckCardsTableReferences),
      DeckCardRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$ItemDetailsTableCreateCompanionBuilder =
    ItemDetailsCompanion Function({
      required String itemId,
      required String payload,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });
typedef $$ItemDetailsTableUpdateCompanionBuilder =
    ItemDetailsCompanion Function({
      Value<String> itemId,
      Value<String> payload,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

final class $$ItemDetailsTableReferences
    extends
        BaseReferences<_$AkashicDatabase, $ItemDetailsTable, ItemDetailsRow> {
  $$ItemDetailsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AkashicDatabase db) =>
      db.items.createAlias('item_details__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemDetailsTableFilterComposer
    extends Composer<_$AkashicDatabase, $ItemDetailsTable> {
  $$ItemDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemDetailsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ItemDetailsTable> {
  $$ItemDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemDetailsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ItemDetailsTable> {
  $$ItemDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemDetailsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ItemDetailsTable,
          ItemDetailsRow,
          $$ItemDetailsTableFilterComposer,
          $$ItemDetailsTableOrderingComposer,
          $$ItemDetailsTableAnnotationComposer,
          $$ItemDetailsTableCreateCompanionBuilder,
          $$ItemDetailsTableUpdateCompanionBuilder,
          (ItemDetailsRow, $$ItemDetailsTableReferences),
          ItemDetailsRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$ItemDetailsTableTableManager(_$AkashicDatabase db, $ItemDetailsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemDetailsCompanion(
                itemId: itemId,
                payload: payload,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String payload,
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemDetailsCompanion.insert(
                itemId: itemId,
                payload: payload,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemDetailsTable, ItemDetailsRow>(table),
                  $$ItemDetailsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ItemDetailsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$ItemDetailsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ItemDetailsTable,
      ItemDetailsRow,
      $$ItemDetailsTableFilterComposer,
      $$ItemDetailsTableOrderingComposer,
      $$ItemDetailsTableAnnotationComposer,
      $$ItemDetailsTableCreateCompanionBuilder,
      $$ItemDetailsTableUpdateCompanionBuilder,
      (ItemDetailsRow, $$ItemDetailsTableReferences),
      ItemDetailsRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$WishesTableCreateCompanionBuilder = WishesCompanion Function({
  required String id,
  required String categoryType,
  Value<String?> categoryId,
  required String title,
  Value<String?> creator,
  Value<String?> imageUrl,
  Value<String?> sourceKey,
  Value<String?> externalWorkId,
  Value<String?> barcode,
  Value<String?> seriesId,
  Value<int?> volumeNumber,
  required String origin,
  Value<String?> priority,
  Value<int?> maxPriceCents,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$WishesTableUpdateCompanionBuilder = WishesCompanion Function({
  Value<String> id,
  Value<String> categoryType,
  Value<String?> categoryId,
  Value<String> title,
  Value<String?> creator,
  Value<String?> imageUrl,
  Value<String?> sourceKey,
  Value<String?> externalWorkId,
  Value<String?> barcode,
  Value<String?> seriesId,
  Value<int?> volumeNumber,
  Value<String> origin,
  Value<String?> priority,
  Value<int?> maxPriceCents,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$WishesTableReferences
    extends BaseReferences<_$AkashicDatabase, $WishesTable, WishRow> {
  $$WishesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AkashicDatabase db) =>
      db.categories.createAlias('wishes__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SeriesTableTable _seriesIdTable(_$AkashicDatabase db) =>
      db.seriesTable.createAlias('wishes__series_id__series__id');

  $$SeriesTableTableProcessedTableManager? get seriesId {
    final $_column = $_itemColumn<String>('series_id');
    if ($_column == null) return null;
    final manager = $$SeriesTableTableTableManager(
      $_db,
      $_db.seriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WishesTableFilterComposer
    extends Composer<_$AkashicDatabase, $WishesTable> {
  $$WishesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPriceCents => $composableBuilder(
    column: $table.maxPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeriesTableTableFilterComposer get seriesId {
    final $$SeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableFilterComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $WishesTable> {
  $$WishesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPriceCents => $composableBuilder(
    column: $table.maxPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeriesTableTableOrderingComposer get seriesId {
    final $$SeriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $WishesTable> {
  $$WishesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<int> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get maxPriceCents => $composableBuilder(
    column: $table.maxPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeriesTableTableAnnotationComposer get seriesId {
    final $$SeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $WishesTable,
          WishRow,
          $$WishesTableFilterComposer,
          $$WishesTableOrderingComposer,
          $$WishesTableAnnotationComposer,
          $$WishesTableCreateCompanionBuilder,
          $$WishesTableUpdateCompanionBuilder,
          (WishRow, $$WishesTableReferences),
          WishRow,
          PrefetchHooks Function({bool categoryId, bool seriesId})
        > {
  $$WishesTableTableManager(_$AkashicDatabase db, $WishesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryType = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> creator = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> sourceKey = const Value.absent(),
                Value<String?> externalWorkId = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> seriesId = const Value.absent(),
                Value<int?> volumeNumber = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<String?> priority = const Value.absent(),
                Value<int?> maxPriceCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WishesCompanion(
                id: id,
                categoryType: categoryType,
                categoryId: categoryId,
                title: title,
                creator: creator,
                imageUrl: imageUrl,
                sourceKey: sourceKey,
                externalWorkId: externalWorkId,
                barcode: barcode,
                seriesId: seriesId,
                volumeNumber: volumeNumber,
                origin: origin,
                priority: priority,
                maxPriceCents: maxPriceCents,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryType,
                Value<String?> categoryId = const Value.absent(),
                required String title,
                Value<String?> creator = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> sourceKey = const Value.absent(),
                Value<String?> externalWorkId = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> seriesId = const Value.absent(),
                Value<int?> volumeNumber = const Value.absent(),
                required String origin,
                Value<String?> priority = const Value.absent(),
                Value<int?> maxPriceCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WishesCompanion.insert(
                id: id,
                categoryType: categoryType,
                categoryId: categoryId,
                title: title,
                creator: creator,
                imageUrl: imageUrl,
                sourceKey: sourceKey,
                externalWorkId: externalWorkId,
                barcode: barcode,
                seriesId: seriesId,
                volumeNumber: volumeNumber,
                origin: origin,
                priority: priority,
                maxPriceCents: maxPriceCents,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WishesTable, WishRow>(table),
                  $$WishesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, seriesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$WishesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$WishesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (seriesId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.seriesId,
                        referencedTable: $$WishesTableReferences._seriesIdTable(
                          db,
                        ),
                        referencedColumn: $$WishesTableReferences
                            ._seriesIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WishesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $WishesTable,
      WishRow,
      $$WishesTableFilterComposer,
      $$WishesTableOrderingComposer,
      $$WishesTableAnnotationComposer,
      $$WishesTableCreateCompanionBuilder,
      $$WishesTableUpdateCompanionBuilder,
      (WishRow, $$WishesTableReferences),
      WishRow,
      PrefetchHooks Function({bool categoryId, bool seriesId})
    >;
typedef $$DismissedSuggestionsTableCreateCompanionBuilder =
    DismissedSuggestionsCompanion Function({
      required String sourceKey,
      required String externalWorkId,
      Value<int> rowid,
    });
typedef $$DismissedSuggestionsTableUpdateCompanionBuilder =
    DismissedSuggestionsCompanion Function({
      Value<String> sourceKey,
      Value<String> externalWorkId,
      Value<int> rowid,
    });

class $$DismissedSuggestionsTableFilterComposer
    extends Composer<_$AkashicDatabase, $DismissedSuggestionsTable> {
  $$DismissedSuggestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DismissedSuggestionsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $DismissedSuggestionsTable> {
  $$DismissedSuggestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DismissedSuggestionsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $DismissedSuggestionsTable> {
  $$DismissedSuggestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<String> get externalWorkId => $composableBuilder(
    column: $table.externalWorkId,
    builder: (column) => column,
  );
}

class $$DismissedSuggestionsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $DismissedSuggestionsTable,
          DismissedSuggestionRow,
          $$DismissedSuggestionsTableFilterComposer,
          $$DismissedSuggestionsTableOrderingComposer,
          $$DismissedSuggestionsTableAnnotationComposer,
          $$DismissedSuggestionsTableCreateCompanionBuilder,
          $$DismissedSuggestionsTableUpdateCompanionBuilder,
          (
            DismissedSuggestionRow,
            BaseReferences<
              _$AkashicDatabase,
              $DismissedSuggestionsTable,
              DismissedSuggestionRow
            >,
          ),
          DismissedSuggestionRow,
          PrefetchHooks Function()
        > {
  $$DismissedSuggestionsTableTableManager(
    _$AkashicDatabase db,
    $DismissedSuggestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DismissedSuggestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DismissedSuggestionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DismissedSuggestionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sourceKey = const Value.absent(),
                Value<String> externalWorkId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DismissedSuggestionsCompanion(
                sourceKey: sourceKey,
                externalWorkId: externalWorkId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sourceKey,
                required String externalWorkId,
                Value<int> rowid = const Value.absent(),
              }) => DismissedSuggestionsCompanion.insert(
                sourceKey: sourceKey,
                externalWorkId: externalWorkId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $DismissedSuggestionsTable,
                    DismissedSuggestionRow
                  >(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $DismissedSuggestionsTable,
                    DismissedSuggestionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DismissedSuggestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $DismissedSuggestionsTable,
      DismissedSuggestionRow,
      $$DismissedSuggestionsTableFilterComposer,
      $$DismissedSuggestionsTableOrderingComposer,
      $$DismissedSuggestionsTableAnnotationComposer,
      $$DismissedSuggestionsTableCreateCompanionBuilder,
      $$DismissedSuggestionsTableUpdateCompanionBuilder,
      (
        DismissedSuggestionRow,
        BaseReferences<
          _$AkashicDatabase,
          $DismissedSuggestionsTable,
          DismissedSuggestionRow
        >,
      ),
      DismissedSuggestionRow,
      PrefetchHooks Function()
    >;
typedef $$DiscoveryCacheTableCreateCompanionBuilder =
    DiscoveryCacheCompanion Function({
      required String id,
      required String payload,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });
typedef $$DiscoveryCacheTableUpdateCompanionBuilder =
    DiscoveryCacheCompanion Function({
      Value<String> id,
      Value<String> payload,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$DiscoveryCacheTableFilterComposer
    extends Composer<_$AkashicDatabase, $DiscoveryCacheTable> {
  $$DiscoveryCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiscoveryCacheTableOrderingComposer
    extends Composer<_$AkashicDatabase, $DiscoveryCacheTable> {
  $$DiscoveryCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiscoveryCacheTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $DiscoveryCacheTable> {
  $$DiscoveryCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$DiscoveryCacheTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $DiscoveryCacheTable,
          DiscoveryCacheRow,
          $$DiscoveryCacheTableFilterComposer,
          $$DiscoveryCacheTableOrderingComposer,
          $$DiscoveryCacheTableAnnotationComposer,
          $$DiscoveryCacheTableCreateCompanionBuilder,
          $$DiscoveryCacheTableUpdateCompanionBuilder,
          (
            DiscoveryCacheRow,
            BaseReferences<
              _$AkashicDatabase,
              $DiscoveryCacheTable,
              DiscoveryCacheRow
            >,
          ),
          DiscoveryCacheRow,
          PrefetchHooks Function()
        > {
  $$DiscoveryCacheTableTableManager(
    _$AkashicDatabase db,
    $DiscoveryCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscoveryCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscoveryCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscoveryCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiscoveryCacheCompanion(
                id: id,
                payload: payload,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payload,
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiscoveryCacheCompanion.insert(
                id: id,
                payload: payload,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DiscoveryCacheTable, DiscoveryCacheRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $DiscoveryCacheTable,
                    DiscoveryCacheRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiscoveryCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $DiscoveryCacheTable,
      DiscoveryCacheRow,
      $$DiscoveryCacheTableFilterComposer,
      $$DiscoveryCacheTableOrderingComposer,
      $$DiscoveryCacheTableAnnotationComposer,
      $$DiscoveryCacheTableCreateCompanionBuilder,
      $$DiscoveryCacheTableUpdateCompanionBuilder,
      (
        DiscoveryCacheRow,
        BaseReferences<
          _$AkashicDatabase,
          $DiscoveryCacheTable,
          DiscoveryCacheRow
        >,
      ),
      DiscoveryCacheRow,
      PrefetchHooks Function()
    >;
typedef $$ScanFollowsTableCreateCompanionBuilder =
    ScanFollowsCompanion Function({
      required String seriesId,
      Value<String?> siteUrl,
      Value<String?> teamName,
      Value<String?> mangaUpdatesSeriesId,
      Value<bool> alertsEnabled,
      Value<bool> onlyFollowedTeam,
      Value<DateTime?> lastCheckedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ScanFollowsTableUpdateCompanionBuilder =
    ScanFollowsCompanion Function({
      Value<String> seriesId,
      Value<String?> siteUrl,
      Value<String?> teamName,
      Value<String?> mangaUpdatesSeriesId,
      Value<bool> alertsEnabled,
      Value<bool> onlyFollowedTeam,
      Value<DateTime?> lastCheckedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ScanFollowsTableReferences
    extends
        BaseReferences<_$AkashicDatabase, $ScanFollowsTable, ScanFollowRow> {
  $$ScanFollowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SeriesTableTable _seriesIdTable(_$AkashicDatabase db) =>
      db.seriesTable.createAlias('scan_follows__series_id__series__id');

  $$SeriesTableTableProcessedTableManager get seriesId {
    final $_column = $_itemColumn<String>('series_id')!;

    final manager = $$SeriesTableTableTableManager(
      $_db,
      $_db.seriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScanFollowsTableFilterComposer
    extends Composer<_$AkashicDatabase, $ScanFollowsTable> {
  $$ScanFollowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get siteUrl => $composableBuilder(
    column: $table.siteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mangaUpdatesSeriesId => $composableBuilder(
    column: $table.mangaUpdatesSeriesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alertsEnabled => $composableBuilder(
    column: $table.alertsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onlyFollowedTeam => $composableBuilder(
    column: $table.onlyFollowedTeam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SeriesTableTableFilterComposer get seriesId {
    final $$SeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableFilterComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanFollowsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ScanFollowsTable> {
  $$ScanFollowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get siteUrl => $composableBuilder(
    column: $table.siteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mangaUpdatesSeriesId => $composableBuilder(
    column: $table.mangaUpdatesSeriesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alertsEnabled => $composableBuilder(
    column: $table.alertsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onlyFollowedTeam => $composableBuilder(
    column: $table.onlyFollowedTeam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeriesTableTableOrderingComposer get seriesId {
    final $$SeriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanFollowsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ScanFollowsTable> {
  $$ScanFollowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get siteUrl =>
      $composableBuilder(column: $table.siteUrl, builder: (column) => column);

  GeneratedColumn<String> get teamName =>
      $composableBuilder(column: $table.teamName, builder: (column) => column);

  GeneratedColumn<String> get mangaUpdatesSeriesId => $composableBuilder(
    column: $table.mangaUpdatesSeriesId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get alertsEnabled => $composableBuilder(
    column: $table.alertsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onlyFollowedTeam => $composableBuilder(
    column: $table.onlyFollowedTeam,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SeriesTableTableAnnotationComposer get seriesId {
    final $$SeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanFollowsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ScanFollowsTable,
          ScanFollowRow,
          $$ScanFollowsTableFilterComposer,
          $$ScanFollowsTableOrderingComposer,
          $$ScanFollowsTableAnnotationComposer,
          $$ScanFollowsTableCreateCompanionBuilder,
          $$ScanFollowsTableUpdateCompanionBuilder,
          (ScanFollowRow, $$ScanFollowsTableReferences),
          ScanFollowRow,
          PrefetchHooks Function({bool seriesId})
        > {
  $$ScanFollowsTableTableManager(_$AkashicDatabase db, $ScanFollowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanFollowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanFollowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanFollowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> seriesId = const Value.absent(),
                Value<String?> siteUrl = const Value.absent(),
                Value<String?> teamName = const Value.absent(),
                Value<String?> mangaUpdatesSeriesId = const Value.absent(),
                Value<bool> alertsEnabled = const Value.absent(),
                Value<bool> onlyFollowedTeam = const Value.absent(),
                Value<DateTime?> lastCheckedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanFollowsCompanion(
                seriesId: seriesId,
                siteUrl: siteUrl,
                teamName: teamName,
                mangaUpdatesSeriesId: mangaUpdatesSeriesId,
                alertsEnabled: alertsEnabled,
                onlyFollowedTeam: onlyFollowedTeam,
                lastCheckedAt: lastCheckedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String seriesId,
                Value<String?> siteUrl = const Value.absent(),
                Value<String?> teamName = const Value.absent(),
                Value<String?> mangaUpdatesSeriesId = const Value.absent(),
                Value<bool> alertsEnabled = const Value.absent(),
                Value<bool> onlyFollowedTeam = const Value.absent(),
                Value<DateTime?> lastCheckedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanFollowsCompanion.insert(
                seriesId: seriesId,
                siteUrl: siteUrl,
                teamName: teamName,
                mangaUpdatesSeriesId: mangaUpdatesSeriesId,
                alertsEnabled: alertsEnabled,
                onlyFollowedTeam: onlyFollowedTeam,
                lastCheckedAt: lastCheckedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScanFollowsTable, ScanFollowRow>(table),
                  $$ScanFollowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seriesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (seriesId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.seriesId,
                        referencedTable: $$ScanFollowsTableReferences
                            ._seriesIdTable(db),
                        referencedColumn: $$ScanFollowsTableReferences
                            ._seriesIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScanFollowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ScanFollowsTable,
      ScanFollowRow,
      $$ScanFollowsTableFilterComposer,
      $$ScanFollowsTableOrderingComposer,
      $$ScanFollowsTableAnnotationComposer,
      $$ScanFollowsTableCreateCompanionBuilder,
      $$ScanFollowsTableUpdateCompanionBuilder,
      (ScanFollowRow, $$ScanFollowsTableReferences),
      ScanFollowRow,
      PrefetchHooks Function({bool seriesId})
    >;
typedef $$ReadChaptersTableCreateCompanionBuilder =
    ReadChaptersCompanion Function({
      required String seriesId,
      required double chapter,
      Value<int> rowid,
    });
typedef $$ReadChaptersTableUpdateCompanionBuilder =
    ReadChaptersCompanion Function({
      Value<String> seriesId,
      Value<double> chapter,
      Value<int> rowid,
    });

final class $$ReadChaptersTableReferences
    extends
        BaseReferences<_$AkashicDatabase, $ReadChaptersTable, ReadChapterRow> {
  $$ReadChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SeriesTableTable _seriesIdTable(_$AkashicDatabase db) =>
      db.seriesTable.createAlias('read_chapters__series_id__series__id');

  $$SeriesTableTableProcessedTableManager get seriesId {
    final $_column = $_itemColumn<String>('series_id')!;

    final manager = $$SeriesTableTableTableManager(
      $_db,
      $_db.seriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadChaptersTableFilterComposer
    extends Composer<_$AkashicDatabase, $ReadChaptersTable> {
  $$ReadChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  $$SeriesTableTableFilterComposer get seriesId {
    final $$SeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableFilterComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadChaptersTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ReadChaptersTable> {
  $$ReadChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeriesTableTableOrderingComposer get seriesId {
    final $$SeriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadChaptersTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ReadChaptersTable> {
  $$ReadChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  $$SeriesTableTableAnnotationComposer get seriesId {
    final $$SeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadChaptersTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ReadChaptersTable,
          ReadChapterRow,
          $$ReadChaptersTableFilterComposer,
          $$ReadChaptersTableOrderingComposer,
          $$ReadChaptersTableAnnotationComposer,
          $$ReadChaptersTableCreateCompanionBuilder,
          $$ReadChaptersTableUpdateCompanionBuilder,
          (ReadChapterRow, $$ReadChaptersTableReferences),
          ReadChapterRow,
          PrefetchHooks Function({bool seriesId})
        > {
  $$ReadChaptersTableTableManager(
    _$AkashicDatabase db,
    $ReadChaptersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> seriesId = const Value.absent(),
                Value<double> chapter = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadChaptersCompanion(
                seriesId: seriesId,
                chapter: chapter,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String seriesId,
                required double chapter,
                Value<int> rowid = const Value.absent(),
              }) => ReadChaptersCompanion.insert(
                seriesId: seriesId,
                chapter: chapter,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadChaptersTable, ReadChapterRow>(table),
                  $$ReadChaptersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seriesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (seriesId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.seriesId,
                        referencedTable: $$ReadChaptersTableReferences
                            ._seriesIdTable(db),
                        referencedColumn: $$ReadChaptersTableReferences
                            ._seriesIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ReadChaptersTable,
      ReadChapterRow,
      $$ReadChaptersTableFilterComposer,
      $$ReadChaptersTableOrderingComposer,
      $$ReadChaptersTableAnnotationComposer,
      $$ReadChaptersTableCreateCompanionBuilder,
      $$ReadChaptersTableUpdateCompanionBuilder,
      (ReadChapterRow, $$ReadChaptersTableReferences),
      ReadChapterRow,
      PrefetchHooks Function({bool seriesId})
    >;
typedef $$ScanReleasesTableCreateCompanionBuilder =
    ScanReleasesCompanion Function({
      required String seriesId,
      required double chapter,
      required String teamName,
      Value<DateTime?> releasedOn,
      Value<bool> notified,
      Value<int> rowid,
    });
typedef $$ScanReleasesTableUpdateCompanionBuilder =
    ScanReleasesCompanion Function({
      Value<String> seriesId,
      Value<double> chapter,
      Value<String> teamName,
      Value<DateTime?> releasedOn,
      Value<bool> notified,
      Value<int> rowid,
    });

final class $$ScanReleasesTableReferences
    extends
        BaseReferences<_$AkashicDatabase, $ScanReleasesTable, ScanReleaseRow> {
  $$ScanReleasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SeriesTableTable _seriesIdTable(_$AkashicDatabase db) =>
      db.seriesTable.createAlias('scan_releases__series_id__series__id');

  $$SeriesTableTableProcessedTableManager get seriesId {
    final $_column = $_itemColumn<String>('series_id')!;

    final manager = $$SeriesTableTableTableManager(
      $_db,
      $_db.seriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScanReleasesTableFilterComposer
    extends Composer<_$AkashicDatabase, $ScanReleasesTable> {
  $$ScanReleasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releasedOn => $composableBuilder(
    column: $table.releasedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notified => $composableBuilder(
    column: $table.notified,
    builder: (column) => ColumnFilters(column),
  );

  $$SeriesTableTableFilterComposer get seriesId {
    final $$SeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableFilterComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanReleasesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ScanReleasesTable> {
  $$ScanReleasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releasedOn => $composableBuilder(
    column: $table.releasedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notified => $composableBuilder(
    column: $table.notified,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeriesTableTableOrderingComposer get seriesId {
    final $$SeriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanReleasesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ScanReleasesTable> {
  $$ScanReleasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get teamName =>
      $composableBuilder(column: $table.teamName, builder: (column) => column);

  GeneratedColumn<DateTime> get releasedOn => $composableBuilder(
    column: $table.releasedOn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notified =>
      $composableBuilder(column: $table.notified, builder: (column) => column);

  $$SeriesTableTableAnnotationComposer get seriesId {
    final $$SeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.seriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.seriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanReleasesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ScanReleasesTable,
          ScanReleaseRow,
          $$ScanReleasesTableFilterComposer,
          $$ScanReleasesTableOrderingComposer,
          $$ScanReleasesTableAnnotationComposer,
          $$ScanReleasesTableCreateCompanionBuilder,
          $$ScanReleasesTableUpdateCompanionBuilder,
          (ScanReleaseRow, $$ScanReleasesTableReferences),
          ScanReleaseRow,
          PrefetchHooks Function({bool seriesId})
        > {
  $$ScanReleasesTableTableManager(
    _$AkashicDatabase db,
    $ScanReleasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanReleasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanReleasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanReleasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> seriesId = const Value.absent(),
                Value<double> chapter = const Value.absent(),
                Value<String> teamName = const Value.absent(),
                Value<DateTime?> releasedOn = const Value.absent(),
                Value<bool> notified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanReleasesCompanion(
                seriesId: seriesId,
                chapter: chapter,
                teamName: teamName,
                releasedOn: releasedOn,
                notified: notified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String seriesId,
                required double chapter,
                required String teamName,
                Value<DateTime?> releasedOn = const Value.absent(),
                Value<bool> notified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanReleasesCompanion.insert(
                seriesId: seriesId,
                chapter: chapter,
                teamName: teamName,
                releasedOn: releasedOn,
                notified: notified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScanReleasesTable, ScanReleaseRow>(table),
                  $$ScanReleasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seriesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (seriesId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.seriesId,
                        referencedTable: $$ScanReleasesTableReferences
                            ._seriesIdTable(db),
                        referencedColumn: $$ScanReleasesTableReferences
                            ._seriesIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScanReleasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ScanReleasesTable,
      ScanReleaseRow,
      $$ScanReleasesTableFilterComposer,
      $$ScanReleasesTableOrderingComposer,
      $$ScanReleasesTableAnnotationComposer,
      $$ScanReleasesTableCreateCompanionBuilder,
      $$ScanReleasesTableUpdateCompanionBuilder,
      (ScanReleaseRow, $$ScanReleasesTableReferences),
      ScanReleaseRow,
      PrefetchHooks Function({bool seriesId})
    >;
typedef $$SourceBlocksTableCreateCompanionBuilder =
    SourceBlocksCompanion Function({
      required String apiFamily,
      required DateTime blockedAt,
      required DateTime retryAt,
      Value<int> rowid,
    });
typedef $$SourceBlocksTableUpdateCompanionBuilder =
    SourceBlocksCompanion Function({
      Value<String> apiFamily,
      Value<DateTime> blockedAt,
      Value<DateTime> retryAt,
      Value<int> rowid,
    });

class $$SourceBlocksTableFilterComposer
    extends Composer<_$AkashicDatabase, $SourceBlocksTable> {
  $$SourceBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get apiFamily => $composableBuilder(
    column: $table.apiFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get blockedAt => $composableBuilder(
    column: $table.blockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get retryAt => $composableBuilder(
    column: $table.retryAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SourceBlocksTableOrderingComposer
    extends Composer<_$AkashicDatabase, $SourceBlocksTable> {
  $$SourceBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get apiFamily => $composableBuilder(
    column: $table.apiFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get blockedAt => $composableBuilder(
    column: $table.blockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get retryAt => $composableBuilder(
    column: $table.retryAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourceBlocksTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $SourceBlocksTable> {
  $$SourceBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get apiFamily =>
      $composableBuilder(column: $table.apiFamily, builder: (column) => column);

  GeneratedColumn<DateTime> get blockedAt =>
      $composableBuilder(column: $table.blockedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get retryAt =>
      $composableBuilder(column: $table.retryAt, builder: (column) => column);
}

class $$SourceBlocksTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $SourceBlocksTable,
          SourceBlockRow,
          $$SourceBlocksTableFilterComposer,
          $$SourceBlocksTableOrderingComposer,
          $$SourceBlocksTableAnnotationComposer,
          $$SourceBlocksTableCreateCompanionBuilder,
          $$SourceBlocksTableUpdateCompanionBuilder,
          (
            SourceBlockRow,
            BaseReferences<
              _$AkashicDatabase,
              $SourceBlocksTable,
              SourceBlockRow
            >,
          ),
          SourceBlockRow,
          PrefetchHooks Function()
        > {
  $$SourceBlocksTableTableManager(
    _$AkashicDatabase db,
    $SourceBlocksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> apiFamily = const Value.absent(),
                Value<DateTime> blockedAt = const Value.absent(),
                Value<DateTime> retryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceBlocksCompanion(
                apiFamily: apiFamily,
                blockedAt: blockedAt,
                retryAt: retryAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String apiFamily,
                required DateTime blockedAt,
                required DateTime retryAt,
                Value<int> rowid = const Value.absent(),
              }) => SourceBlocksCompanion.insert(
                apiFamily: apiFamily,
                blockedAt: blockedAt,
                retryAt: retryAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceBlocksTable, SourceBlockRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $SourceBlocksTable,
                    SourceBlockRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SourceBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $SourceBlocksTable,
      SourceBlockRow,
      $$SourceBlocksTableFilterComposer,
      $$SourceBlocksTableOrderingComposer,
      $$SourceBlocksTableAnnotationComposer,
      $$SourceBlocksTableCreateCompanionBuilder,
      $$SourceBlocksTableUpdateCompanionBuilder,
      (
        SourceBlockRow,
        BaseReferences<_$AkashicDatabase, $SourceBlocksTable, SourceBlockRow>,
      ),
      SourceBlockRow,
      PrefetchHooks Function()
    >;
typedef $$ItemPhotosTableCreateCompanionBuilder = ItemPhotosCompanion Function({
  required String id,
  required String itemId,
  Value<String?> copyId,
  required String path,
  required int position,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ItemPhotosTableUpdateCompanionBuilder = ItemPhotosCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<String?> copyId,
  Value<String> path,
  Value<int> position,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ItemPhotosTableReferences
    extends BaseReferences<_$AkashicDatabase, $ItemPhotosTable, ItemPhotoRow> {
  $$ItemPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AkashicDatabase db) =>
      db.items.createAlias('item_photos__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CopiesTable _copyIdTable(_$AkashicDatabase db) =>
      db.copies.createAlias('item_photos__copy_id__copies__id');

  $$CopiesTableProcessedTableManager? get copyId {
    final $_column = $_itemColumn<String>('copy_id');
    if ($_column == null) return null;
    final manager = $$CopiesTableTableManager(
      $_db,
      $_db.copies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_copyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemPhotosTableFilterComposer
    extends Composer<_$AkashicDatabase, $ItemPhotosTable> {
  $$ItemPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CopiesTableFilterComposer get copyId {
    final $$CopiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableFilterComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ItemPhotosTable> {
  $$ItemPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CopiesTableOrderingComposer get copyId {
    final $$CopiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableOrderingComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ItemPhotosTable> {
  $$ItemPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CopiesTableAnnotationComposer get copyId {
    final $$CopiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copyId,
      referencedTable: $db.copies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopiesTableAnnotationComposer(
            $db: $db,
            $table: $db.copies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ItemPhotosTable,
          ItemPhotoRow,
          $$ItemPhotosTableFilterComposer,
          $$ItemPhotosTableOrderingComposer,
          $$ItemPhotosTableAnnotationComposer,
          $$ItemPhotosTableCreateCompanionBuilder,
          $$ItemPhotosTableUpdateCompanionBuilder,
          (ItemPhotoRow, $$ItemPhotosTableReferences),
          ItemPhotoRow,
          PrefetchHooks Function({bool itemId, bool copyId})
        > {
  $$ItemPhotosTableTableManager(_$AkashicDatabase db, $ItemPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String?> copyId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemPhotosCompanion(
                id: id,
                itemId: itemId,
                copyId: copyId,
                path: path,
                position: position,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemId,
                Value<String?> copyId = const Value.absent(),
                required String path,
                required int position,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemPhotosCompanion.insert(
                id: id,
                itemId: itemId,
                copyId: copyId,
                path: path,
                position: position,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemPhotosTable, ItemPhotoRow>(table),
                  $$ItemPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false, copyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ItemPhotosTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$ItemPhotosTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (copyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.copyId,
                        referencedTable: $$ItemPhotosTableReferences
                            ._copyIdTable(db),
                        referencedColumn: $$ItemPhotosTableReferences
                            ._copyIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ItemPhotosTable,
      ItemPhotoRow,
      $$ItemPhotosTableFilterComposer,
      $$ItemPhotosTableOrderingComposer,
      $$ItemPhotosTableAnnotationComposer,
      $$ItemPhotosTableCreateCompanionBuilder,
      $$ItemPhotosTableUpdateCompanionBuilder,
      (ItemPhotoRow, $$ItemPhotosTableReferences),
      ItemPhotoRow,
      PrefetchHooks Function({bool itemId, bool copyId})
    >;
typedef $$SteamGameStatsTableCreateCompanionBuilder =
    SteamGameStatsCompanion Function({
      required String itemId,
      required String appId,
      Value<int> playtimeMinutes,
      Value<int> recentMinutes,
      Value<DateTime?> lastPlayedAt,
      Value<int?> achievementsUnlocked,
      Value<int?> achievementsTotal,
      Value<DateTime?> achievementsCheckedAt,
      Value<String?> deckStatus,
      Value<DateTime?> deckCheckedAt,
      Value<String?> autoProgressStatus,
      Value<int?> priceCents,
      Value<String?> priceCurrency,
      Value<DateTime?> pricedAt,
      required DateTime syncedAt,
      Value<int> rowid,
    });
typedef $$SteamGameStatsTableUpdateCompanionBuilder =
    SteamGameStatsCompanion Function({
      Value<String> itemId,
      Value<String> appId,
      Value<int> playtimeMinutes,
      Value<int> recentMinutes,
      Value<DateTime?> lastPlayedAt,
      Value<int?> achievementsUnlocked,
      Value<int?> achievementsTotal,
      Value<DateTime?> achievementsCheckedAt,
      Value<String?> deckStatus,
      Value<DateTime?> deckCheckedAt,
      Value<String?> autoProgressStatus,
      Value<int?> priceCents,
      Value<String?> priceCurrency,
      Value<DateTime?> pricedAt,
      Value<DateTime> syncedAt,
      Value<int> rowid,
    });

final class $$SteamGameStatsTableReferences
    extends
        BaseReferences<
          _$AkashicDatabase,
          $SteamGameStatsTable,
          SteamGameStatsRow
        > {
  $$SteamGameStatsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ItemsTable _itemIdTable(_$AkashicDatabase db) =>
      db.items.createAlias('steam_game_stats__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SteamGameStatsTableFilterComposer
    extends Composer<_$AkashicDatabase, $SteamGameStatsTable> {
  $$SteamGameStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playtimeMinutes => $composableBuilder(
    column: $table.playtimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recentMinutes => $composableBuilder(
    column: $table.recentMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get achievementsUnlocked => $composableBuilder(
    column: $table.achievementsUnlocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get achievementsTotal => $composableBuilder(
    column: $table.achievementsTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievementsCheckedAt => $composableBuilder(
    column: $table.achievementsCheckedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deckStatus => $composableBuilder(
    column: $table.deckStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deckCheckedAt => $composableBuilder(
    column: $table.deckCheckedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get autoProgressStatus => $composableBuilder(
    column: $table.autoProgressStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceCurrency => $composableBuilder(
    column: $table.priceCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pricedAt => $composableBuilder(
    column: $table.pricedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SteamGameStatsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $SteamGameStatsTable> {
  $$SteamGameStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playtimeMinutes => $composableBuilder(
    column: $table.playtimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recentMinutes => $composableBuilder(
    column: $table.recentMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get achievementsUnlocked => $composableBuilder(
    column: $table.achievementsUnlocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get achievementsTotal => $composableBuilder(
    column: $table.achievementsTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievementsCheckedAt => $composableBuilder(
    column: $table.achievementsCheckedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deckStatus => $composableBuilder(
    column: $table.deckStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deckCheckedAt => $composableBuilder(
    column: $table.deckCheckedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get autoProgressStatus => $composableBuilder(
    column: $table.autoProgressStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceCurrency => $composableBuilder(
    column: $table.priceCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pricedAt => $composableBuilder(
    column: $table.pricedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SteamGameStatsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $SteamGameStatsTable> {
  $$SteamGameStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get appId =>
      $composableBuilder(column: $table.appId, builder: (column) => column);

  GeneratedColumn<int> get playtimeMinutes => $composableBuilder(
    column: $table.playtimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recentMinutes => $composableBuilder(
    column: $table.recentMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get achievementsUnlocked => $composableBuilder(
    column: $table.achievementsUnlocked,
    builder: (column) => column,
  );

  GeneratedColumn<int> get achievementsTotal => $composableBuilder(
    column: $table.achievementsTotal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get achievementsCheckedAt => $composableBuilder(
    column: $table.achievementsCheckedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deckStatus => $composableBuilder(
    column: $table.deckStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deckCheckedAt => $composableBuilder(
    column: $table.deckCheckedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get autoProgressStatus => $composableBuilder(
    column: $table.autoProgressStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priceCurrency => $composableBuilder(
    column: $table.priceCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pricedAt =>
      $composableBuilder(column: $table.pricedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SteamGameStatsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $SteamGameStatsTable,
          SteamGameStatsRow,
          $$SteamGameStatsTableFilterComposer,
          $$SteamGameStatsTableOrderingComposer,
          $$SteamGameStatsTableAnnotationComposer,
          $$SteamGameStatsTableCreateCompanionBuilder,
          $$SteamGameStatsTableUpdateCompanionBuilder,
          (SteamGameStatsRow, $$SteamGameStatsTableReferences),
          SteamGameStatsRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$SteamGameStatsTableTableManager(
    _$AkashicDatabase db,
    $SteamGameStatsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SteamGameStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SteamGameStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SteamGameStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> appId = const Value.absent(),
                Value<int> playtimeMinutes = const Value.absent(),
                Value<int> recentMinutes = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int?> achievementsUnlocked = const Value.absent(),
                Value<int?> achievementsTotal = const Value.absent(),
                Value<DateTime?> achievementsCheckedAt = const Value.absent(),
                Value<String?> deckStatus = const Value.absent(),
                Value<DateTime?> deckCheckedAt = const Value.absent(),
                Value<String?> autoProgressStatus = const Value.absent(),
                Value<int?> priceCents = const Value.absent(),
                Value<String?> priceCurrency = const Value.absent(),
                Value<DateTime?> pricedAt = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SteamGameStatsCompanion(
                itemId: itemId,
                appId: appId,
                playtimeMinutes: playtimeMinutes,
                recentMinutes: recentMinutes,
                lastPlayedAt: lastPlayedAt,
                achievementsUnlocked: achievementsUnlocked,
                achievementsTotal: achievementsTotal,
                achievementsCheckedAt: achievementsCheckedAt,
                deckStatus: deckStatus,
                deckCheckedAt: deckCheckedAt,
                autoProgressStatus: autoProgressStatus,
                priceCents: priceCents,
                priceCurrency: priceCurrency,
                pricedAt: pricedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String appId,
                Value<int> playtimeMinutes = const Value.absent(),
                Value<int> recentMinutes = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int?> achievementsUnlocked = const Value.absent(),
                Value<int?> achievementsTotal = const Value.absent(),
                Value<DateTime?> achievementsCheckedAt = const Value.absent(),
                Value<String?> deckStatus = const Value.absent(),
                Value<DateTime?> deckCheckedAt = const Value.absent(),
                Value<String?> autoProgressStatus = const Value.absent(),
                Value<int?> priceCents = const Value.absent(),
                Value<String?> priceCurrency = const Value.absent(),
                Value<DateTime?> pricedAt = const Value.absent(),
                required DateTime syncedAt,
                Value<int> rowid = const Value.absent(),
              }) => SteamGameStatsCompanion.insert(
                itemId: itemId,
                appId: appId,
                playtimeMinutes: playtimeMinutes,
                recentMinutes: recentMinutes,
                lastPlayedAt: lastPlayedAt,
                achievementsUnlocked: achievementsUnlocked,
                achievementsTotal: achievementsTotal,
                achievementsCheckedAt: achievementsCheckedAt,
                deckStatus: deckStatus,
                deckCheckedAt: deckCheckedAt,
                autoProgressStatus: autoProgressStatus,
                priceCents: priceCents,
                priceCurrency: priceCurrency,
                pricedAt: pricedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SteamGameStatsTable, SteamGameStatsRow>(table),
                  $$SteamGameStatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$SteamGameStatsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$SteamGameStatsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SteamGameStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $SteamGameStatsTable,
      SteamGameStatsRow,
      $$SteamGameStatsTableFilterComposer,
      $$SteamGameStatsTableOrderingComposer,
      $$SteamGameStatsTableAnnotationComposer,
      $$SteamGameStatsTableCreateCompanionBuilder,
      $$SteamGameStatsTableUpdateCompanionBuilder,
      (SteamGameStatsRow, $$SteamGameStatsTableReferences),
      SteamGameStatsRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  required String id,
  required String itemId,
  Value<String?> categoryId,
  required String titles,
  Value<String?> originalLanguage,
  Value<String?> edition,
  Value<bool> wasOpened,
  Value<int?> purchasePriceCents,
  Value<DateTime?> purchasedOn,
  Value<String?> purchaseChannel,
  required int salePriceCents,
  required DateTime soldOn,
  Value<String?> saleChannel,
  Value<int> rowid,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<String?> categoryId,
  Value<String> titles,
  Value<String?> originalLanguage,
  Value<String?> edition,
  Value<bool> wasOpened,
  Value<int?> purchasePriceCents,
  Value<DateTime?> purchasedOn,
  Value<String?> purchaseChannel,
  Value<int> salePriceCents,
  Value<DateTime> soldOn,
  Value<String?> saleChannel,
  Value<int> rowid,
});

class $$SalesTableFilterComposer
    extends Composer<_$AkashicDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titles => $composableBuilder(
    column: $table.titles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wasOpened => $composableBuilder(
    column: $table.wasOpened,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePriceCents => $composableBuilder(
    column: $table.purchasePriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedOn => $composableBuilder(
    column: $table.purchasedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseChannel => $composableBuilder(
    column: $table.purchaseChannel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salePriceCents => $composableBuilder(
    column: $table.salePriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get soldOn => $composableBuilder(
    column: $table.soldOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleChannel => $composableBuilder(
    column: $table.saleChannel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titles => $composableBuilder(
    column: $table.titles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wasOpened => $composableBuilder(
    column: $table.wasOpened,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePriceCents => $composableBuilder(
    column: $table.purchasePriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedOn => $composableBuilder(
    column: $table.purchasedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseChannel => $composableBuilder(
    column: $table.purchaseChannel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salePriceCents => $composableBuilder(
    column: $table.salePriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get soldOn => $composableBuilder(
    column: $table.soldOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleChannel => $composableBuilder(
    column: $table.saleChannel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get titles =>
      $composableBuilder(column: $table.titles, builder: (column) => column);

  GeneratedColumn<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get edition =>
      $composableBuilder(column: $table.edition, builder: (column) => column);

  GeneratedColumn<bool> get wasOpened =>
      $composableBuilder(column: $table.wasOpened, builder: (column) => column);

  GeneratedColumn<int> get purchasePriceCents => $composableBuilder(
    column: $table.purchasePriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchasedOn => $composableBuilder(
    column: $table.purchasedOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purchaseChannel => $composableBuilder(
    column: $table.purchaseChannel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get salePriceCents => $composableBuilder(
    column: $table.salePriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get soldOn =>
      $composableBuilder(column: $table.soldOn, builder: (column) => column);

  GeneratedColumn<String> get saleChannel => $composableBuilder(
    column: $table.saleChannel,
    builder: (column) => column,
  );
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $SalesTable,
          SaleRow,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (SaleRow, BaseReferences<_$AkashicDatabase, $SalesTable, SaleRow>),
          SaleRow,
          PrefetchHooks Function()
        > {
  $$SalesTableTableManager(_$AkashicDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> titles = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> edition = const Value.absent(),
                Value<bool> wasOpened = const Value.absent(),
                Value<int?> purchasePriceCents = const Value.absent(),
                Value<DateTime?> purchasedOn = const Value.absent(),
                Value<String?> purchaseChannel = const Value.absent(),
                Value<int> salePriceCents = const Value.absent(),
                Value<DateTime> soldOn = const Value.absent(),
                Value<String?> saleChannel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                itemId: itemId,
                categoryId: categoryId,
                titles: titles,
                originalLanguage: originalLanguage,
                edition: edition,
                wasOpened: wasOpened,
                purchasePriceCents: purchasePriceCents,
                purchasedOn: purchasedOn,
                purchaseChannel: purchaseChannel,
                salePriceCents: salePriceCents,
                soldOn: soldOn,
                saleChannel: saleChannel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemId,
                Value<String?> categoryId = const Value.absent(),
                required String titles,
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> edition = const Value.absent(),
                Value<bool> wasOpened = const Value.absent(),
                Value<int?> purchasePriceCents = const Value.absent(),
                Value<DateTime?> purchasedOn = const Value.absent(),
                Value<String?> purchaseChannel = const Value.absent(),
                required int salePriceCents,
                required DateTime soldOn,
                Value<String?> saleChannel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                itemId: itemId,
                categoryId: categoryId,
                titles: titles,
                originalLanguage: originalLanguage,
                edition: edition,
                wasOpened: wasOpened,
                purchasePriceCents: purchasePriceCents,
                purchasedOn: purchasedOn,
                purchaseChannel: purchaseChannel,
                salePriceCents: salePriceCents,
                soldOn: soldOn,
                saleChannel: saleChannel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalesTable, SaleRow>(table),
                  BaseReferences<_$AkashicDatabase, $SalesTable, SaleRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $SalesTable,
      SaleRow,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (SaleRow, BaseReferences<_$AkashicDatabase, $SalesTable, SaleRow>),
      SaleRow,
      PrefetchHooks Function()
    >;
typedef $$SealedPricesTableCreateCompanionBuilder =
    SealedPricesCompanion Function({
      required String productId,
      Value<int?> lowCents,
      Value<int?> averageCents,
      Value<int?> trendCents,
      Value<int?> average1Cents,
      Value<int?> average7Cents,
      Value<int?> average30Cents,
      required DateTime pricedAt,
      Value<int> rowid,
    });
typedef $$SealedPricesTableUpdateCompanionBuilder =
    SealedPricesCompanion Function({
      Value<String> productId,
      Value<int?> lowCents,
      Value<int?> averageCents,
      Value<int?> trendCents,
      Value<int?> average1Cents,
      Value<int?> average7Cents,
      Value<int?> average30Cents,
      Value<DateTime> pricedAt,
      Value<int> rowid,
    });

class $$SealedPricesTableFilterComposer
    extends Composer<_$AkashicDatabase, $SealedPricesTable> {
  $$SealedPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowCents => $composableBuilder(
    column: $table.lowCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageCents => $composableBuilder(
    column: $table.averageCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trendCents => $composableBuilder(
    column: $table.trendCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get average1Cents => $composableBuilder(
    column: $table.average1Cents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get average7Cents => $composableBuilder(
    column: $table.average7Cents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get average30Cents => $composableBuilder(
    column: $table.average30Cents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pricedAt => $composableBuilder(
    column: $table.pricedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SealedPricesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $SealedPricesTable> {
  $$SealedPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowCents => $composableBuilder(
    column: $table.lowCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageCents => $composableBuilder(
    column: $table.averageCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trendCents => $composableBuilder(
    column: $table.trendCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get average1Cents => $composableBuilder(
    column: $table.average1Cents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get average7Cents => $composableBuilder(
    column: $table.average7Cents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get average30Cents => $composableBuilder(
    column: $table.average30Cents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pricedAt => $composableBuilder(
    column: $table.pricedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SealedPricesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $SealedPricesTable> {
  $$SealedPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get lowCents =>
      $composableBuilder(column: $table.lowCents, builder: (column) => column);

  GeneratedColumn<int> get averageCents => $composableBuilder(
    column: $table.averageCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trendCents => $composableBuilder(
    column: $table.trendCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get average1Cents => $composableBuilder(
    column: $table.average1Cents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get average7Cents => $composableBuilder(
    column: $table.average7Cents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get average30Cents => $composableBuilder(
    column: $table.average30Cents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pricedAt =>
      $composableBuilder(column: $table.pricedAt, builder: (column) => column);
}

class $$SealedPricesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $SealedPricesTable,
          SealedPriceRow,
          $$SealedPricesTableFilterComposer,
          $$SealedPricesTableOrderingComposer,
          $$SealedPricesTableAnnotationComposer,
          $$SealedPricesTableCreateCompanionBuilder,
          $$SealedPricesTableUpdateCompanionBuilder,
          (
            SealedPriceRow,
            BaseReferences<
              _$AkashicDatabase,
              $SealedPricesTable,
              SealedPriceRow
            >,
          ),
          SealedPriceRow,
          PrefetchHooks Function()
        > {
  $$SealedPricesTableTableManager(
    _$AkashicDatabase db,
    $SealedPricesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SealedPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SealedPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SealedPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> productId = const Value.absent(),
                Value<int?> lowCents = const Value.absent(),
                Value<int?> averageCents = const Value.absent(),
                Value<int?> trendCents = const Value.absent(),
                Value<int?> average1Cents = const Value.absent(),
                Value<int?> average7Cents = const Value.absent(),
                Value<int?> average30Cents = const Value.absent(),
                Value<DateTime> pricedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SealedPricesCompanion(
                productId: productId,
                lowCents: lowCents,
                averageCents: averageCents,
                trendCents: trendCents,
                average1Cents: average1Cents,
                average7Cents: average7Cents,
                average30Cents: average30Cents,
                pricedAt: pricedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productId,
                Value<int?> lowCents = const Value.absent(),
                Value<int?> averageCents = const Value.absent(),
                Value<int?> trendCents = const Value.absent(),
                Value<int?> average1Cents = const Value.absent(),
                Value<int?> average7Cents = const Value.absent(),
                Value<int?> average30Cents = const Value.absent(),
                required DateTime pricedAt,
                Value<int> rowid = const Value.absent(),
              }) => SealedPricesCompanion.insert(
                productId: productId,
                lowCents: lowCents,
                averageCents: averageCents,
                trendCents: trendCents,
                average1Cents: average1Cents,
                average7Cents: average7Cents,
                average30Cents: average30Cents,
                pricedAt: pricedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SealedPricesTable, SealedPriceRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $SealedPricesTable,
                    SealedPriceRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SealedPricesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $SealedPricesTable,
      SealedPriceRow,
      $$SealedPricesTableFilterComposer,
      $$SealedPricesTableOrderingComposer,
      $$SealedPricesTableAnnotationComposer,
      $$SealedPricesTableCreateCompanionBuilder,
      $$SealedPricesTableUpdateCompanionBuilder,
      (
        SealedPriceRow,
        BaseReferences<_$AkashicDatabase, $SealedPricesTable, SealedPriceRow>,
      ),
      SealedPriceRow,
      PrefetchHooks Function()
    >;
typedef $$SteamWatchesTableCreateCompanionBuilder =
    SteamWatchesCompanion Function({
      required String appId,
      Value<int?> priceCents,
      Value<int?> initialPriceCents,
      Value<int> discountPercent,
      Value<String?> priceCurrency,
      Value<bool> isComingSoon,
      required DateTime checkedAt,
      Value<int> rowid,
    });
typedef $$SteamWatchesTableUpdateCompanionBuilder =
    SteamWatchesCompanion Function({
      Value<String> appId,
      Value<int?> priceCents,
      Value<int?> initialPriceCents,
      Value<int> discountPercent,
      Value<String?> priceCurrency,
      Value<bool> isComingSoon,
      Value<DateTime> checkedAt,
      Value<int> rowid,
    });

class $$SteamWatchesTableFilterComposer
    extends Composer<_$AkashicDatabase, $SteamWatchesTable> {
  $$SteamWatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialPriceCents => $composableBuilder(
    column: $table.initialPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceCurrency => $composableBuilder(
    column: $table.priceCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isComingSoon => $composableBuilder(
    column: $table.isComingSoon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SteamWatchesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $SteamWatchesTable> {
  $$SteamWatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialPriceCents => $composableBuilder(
    column: $table.initialPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceCurrency => $composableBuilder(
    column: $table.priceCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isComingSoon => $composableBuilder(
    column: $table.isComingSoon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SteamWatchesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $SteamWatchesTable> {
  $$SteamWatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get appId =>
      $composableBuilder(column: $table.appId, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get initialPriceCents => $composableBuilder(
    column: $table.initialPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priceCurrency => $composableBuilder(
    column: $table.priceCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isComingSoon => $composableBuilder(
    column: $table.isComingSoon,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);
}

class $$SteamWatchesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $SteamWatchesTable,
          SteamWatchRow,
          $$SteamWatchesTableFilterComposer,
          $$SteamWatchesTableOrderingComposer,
          $$SteamWatchesTableAnnotationComposer,
          $$SteamWatchesTableCreateCompanionBuilder,
          $$SteamWatchesTableUpdateCompanionBuilder,
          (
            SteamWatchRow,
            BaseReferences<
              _$AkashicDatabase,
              $SteamWatchesTable,
              SteamWatchRow
            >,
          ),
          SteamWatchRow,
          PrefetchHooks Function()
        > {
  $$SteamWatchesTableTableManager(
    _$AkashicDatabase db,
    $SteamWatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SteamWatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SteamWatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SteamWatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> appId = const Value.absent(),
                Value<int?> priceCents = const Value.absent(),
                Value<int?> initialPriceCents = const Value.absent(),
                Value<int> discountPercent = const Value.absent(),
                Value<String?> priceCurrency = const Value.absent(),
                Value<bool> isComingSoon = const Value.absent(),
                Value<DateTime> checkedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SteamWatchesCompanion(
                appId: appId,
                priceCents: priceCents,
                initialPriceCents: initialPriceCents,
                discountPercent: discountPercent,
                priceCurrency: priceCurrency,
                isComingSoon: isComingSoon,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String appId,
                Value<int?> priceCents = const Value.absent(),
                Value<int?> initialPriceCents = const Value.absent(),
                Value<int> discountPercent = const Value.absent(),
                Value<String?> priceCurrency = const Value.absent(),
                Value<bool> isComingSoon = const Value.absent(),
                required DateTime checkedAt,
                Value<int> rowid = const Value.absent(),
              }) => SteamWatchesCompanion.insert(
                appId: appId,
                priceCents: priceCents,
                initialPriceCents: initialPriceCents,
                discountPercent: discountPercent,
                priceCurrency: priceCurrency,
                isComingSoon: isComingSoon,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SteamWatchesTable, SteamWatchRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $SteamWatchesTable,
                    SteamWatchRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SteamWatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $SteamWatchesTable,
      SteamWatchRow,
      $$SteamWatchesTableFilterComposer,
      $$SteamWatchesTableOrderingComposer,
      $$SteamWatchesTableAnnotationComposer,
      $$SteamWatchesTableCreateCompanionBuilder,
      $$SteamWatchesTableUpdateCompanionBuilder,
      (
        SteamWatchRow,
        BaseReferences<_$AkashicDatabase, $SteamWatchesTable, SteamWatchRow>,
      ),
      SteamWatchRow,
      PrefetchHooks Function()
    >;
typedef $$SteamKnownDlcsTableCreateCompanionBuilder =
    SteamKnownDlcsCompanion Function({
      required String appId,
      required String dlcIds,
      required DateTime checkedAt,
      Value<int> rowid,
    });
typedef $$SteamKnownDlcsTableUpdateCompanionBuilder =
    SteamKnownDlcsCompanion Function({
      Value<String> appId,
      Value<String> dlcIds,
      Value<DateTime> checkedAt,
      Value<int> rowid,
    });

class $$SteamKnownDlcsTableFilterComposer
    extends Composer<_$AkashicDatabase, $SteamKnownDlcsTable> {
  $$SteamKnownDlcsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dlcIds => $composableBuilder(
    column: $table.dlcIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SteamKnownDlcsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $SteamKnownDlcsTable> {
  $$SteamKnownDlcsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get appId => $composableBuilder(
    column: $table.appId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dlcIds => $composableBuilder(
    column: $table.dlcIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SteamKnownDlcsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $SteamKnownDlcsTable> {
  $$SteamKnownDlcsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get appId =>
      $composableBuilder(column: $table.appId, builder: (column) => column);

  GeneratedColumn<String> get dlcIds =>
      $composableBuilder(column: $table.dlcIds, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);
}

class $$SteamKnownDlcsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $SteamKnownDlcsTable,
          SteamKnownDlcsRow,
          $$SteamKnownDlcsTableFilterComposer,
          $$SteamKnownDlcsTableOrderingComposer,
          $$SteamKnownDlcsTableAnnotationComposer,
          $$SteamKnownDlcsTableCreateCompanionBuilder,
          $$SteamKnownDlcsTableUpdateCompanionBuilder,
          (
            SteamKnownDlcsRow,
            BaseReferences<
              _$AkashicDatabase,
              $SteamKnownDlcsTable,
              SteamKnownDlcsRow
            >,
          ),
          SteamKnownDlcsRow,
          PrefetchHooks Function()
        > {
  $$SteamKnownDlcsTableTableManager(
    _$AkashicDatabase db,
    $SteamKnownDlcsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SteamKnownDlcsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SteamKnownDlcsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SteamKnownDlcsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> appId = const Value.absent(),
                Value<String> dlcIds = const Value.absent(),
                Value<DateTime> checkedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SteamKnownDlcsCompanion(
                appId: appId,
                dlcIds: dlcIds,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String appId,
                required String dlcIds,
                required DateTime checkedAt,
                Value<int> rowid = const Value.absent(),
              }) => SteamKnownDlcsCompanion.insert(
                appId: appId,
                dlcIds: dlcIds,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SteamKnownDlcsTable, SteamKnownDlcsRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $SteamKnownDlcsTable,
                    SteamKnownDlcsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SteamKnownDlcsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $SteamKnownDlcsTable,
      SteamKnownDlcsRow,
      $$SteamKnownDlcsTableFilterComposer,
      $$SteamKnownDlcsTableOrderingComposer,
      $$SteamKnownDlcsTableAnnotationComposer,
      $$SteamKnownDlcsTableCreateCompanionBuilder,
      $$SteamKnownDlcsTableUpdateCompanionBuilder,
      (
        SteamKnownDlcsRow,
        BaseReferences<
          _$AkashicDatabase,
          $SteamKnownDlcsTable,
          SteamKnownDlcsRow
        >,
      ),
      SteamKnownDlcsRow,
      PrefetchHooks Function()
    >;
typedef $$PriceAlertsTableCreateCompanionBuilder =
    PriceAlertsCompanion Function({
      required String itemId,
      required int thresholdCents,
      required bool isAbove,
      Value<DateTime?> notifiedAt,
      Value<int> rowid,
    });
typedef $$PriceAlertsTableUpdateCompanionBuilder =
    PriceAlertsCompanion Function({
      Value<String> itemId,
      Value<int> thresholdCents,
      Value<bool> isAbove,
      Value<DateTime?> notifiedAt,
      Value<int> rowid,
    });

final class $$PriceAlertsTableReferences
    extends
        BaseReferences<_$AkashicDatabase, $PriceAlertsTable, PriceAlertRow> {
  $$PriceAlertsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AkashicDatabase db) =>
      db.items.createAlias('price_alerts__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PriceAlertsTableFilterComposer
    extends Composer<_$AkashicDatabase, $PriceAlertsTable> {
  $$PriceAlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get thresholdCents => $composableBuilder(
    column: $table.thresholdCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAbove => $composableBuilder(
    column: $table.isAbove,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get notifiedAt => $composableBuilder(
    column: $table.notifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PriceAlertsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $PriceAlertsTable> {
  $$PriceAlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get thresholdCents => $composableBuilder(
    column: $table.thresholdCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAbove => $composableBuilder(
    column: $table.isAbove,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get notifiedAt => $composableBuilder(
    column: $table.notifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PriceAlertsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $PriceAlertsTable> {
  $$PriceAlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get thresholdCents => $composableBuilder(
    column: $table.thresholdCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAbove =>
      $composableBuilder(column: $table.isAbove, builder: (column) => column);

  GeneratedColumn<DateTime> get notifiedAt => $composableBuilder(
    column: $table.notifiedAt,
    builder: (column) => column,
  );

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PriceAlertsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $PriceAlertsTable,
          PriceAlertRow,
          $$PriceAlertsTableFilterComposer,
          $$PriceAlertsTableOrderingComposer,
          $$PriceAlertsTableAnnotationComposer,
          $$PriceAlertsTableCreateCompanionBuilder,
          $$PriceAlertsTableUpdateCompanionBuilder,
          (PriceAlertRow, $$PriceAlertsTableReferences),
          PriceAlertRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$PriceAlertsTableTableManager(_$AkashicDatabase db, $PriceAlertsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceAlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceAlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceAlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<int> thresholdCents = const Value.absent(),
                Value<bool> isAbove = const Value.absent(),
                Value<DateTime?> notifiedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceAlertsCompanion(
                itemId: itemId,
                thresholdCents: thresholdCents,
                isAbove: isAbove,
                notifiedAt: notifiedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required int thresholdCents,
                required bool isAbove,
                Value<DateTime?> notifiedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceAlertsCompanion.insert(
                itemId: itemId,
                thresholdCents: thresholdCents,
                isAbove: isAbove,
                notifiedAt: notifiedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PriceAlertsTable, PriceAlertRow>(table),
                  $$PriceAlertsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$PriceAlertsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$PriceAlertsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PriceAlertsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $PriceAlertsTable,
      PriceAlertRow,
      $$PriceAlertsTableFilterComposer,
      $$PriceAlertsTableOrderingComposer,
      $$PriceAlertsTableAnnotationComposer,
      $$PriceAlertsTableCreateCompanionBuilder,
      $$PriceAlertsTableUpdateCompanionBuilder,
      (PriceAlertRow, $$PriceAlertsTableReferences),
      PriceAlertRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$ValueSnapshotsTableCreateCompanionBuilder =
    ValueSnapshotsCompanion Function({
      required String month,
      required String totals,
      required DateTime takenAt,
      Value<int> rowid,
    });
typedef $$ValueSnapshotsTableUpdateCompanionBuilder =
    ValueSnapshotsCompanion Function({
      Value<String> month,
      Value<String> totals,
      Value<DateTime> takenAt,
      Value<int> rowid,
    });

class $$ValueSnapshotsTableFilterComposer
    extends Composer<_$AkashicDatabase, $ValueSnapshotsTable> {
  $$ValueSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get totals => $composableBuilder(
    column: $table.totals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ValueSnapshotsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ValueSnapshotsTable> {
  $$ValueSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get totals => $composableBuilder(
    column: $table.totals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ValueSnapshotsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ValueSnapshotsTable> {
  $$ValueSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get totals =>
      $composableBuilder(column: $table.totals, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);
}

class $$ValueSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ValueSnapshotsTable,
          ValueSnapshotRow,
          $$ValueSnapshotsTableFilterComposer,
          $$ValueSnapshotsTableOrderingComposer,
          $$ValueSnapshotsTableAnnotationComposer,
          $$ValueSnapshotsTableCreateCompanionBuilder,
          $$ValueSnapshotsTableUpdateCompanionBuilder,
          (
            ValueSnapshotRow,
            BaseReferences<
              _$AkashicDatabase,
              $ValueSnapshotsTable,
              ValueSnapshotRow
            >,
          ),
          ValueSnapshotRow,
          PrefetchHooks Function()
        > {
  $$ValueSnapshotsTableTableManager(
    _$AkashicDatabase db,
    $ValueSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ValueSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ValueSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ValueSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> month = const Value.absent(),
                Value<String> totals = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ValueSnapshotsCompanion(
                month: month,
                totals: totals,
                takenAt: takenAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String month,
                required String totals,
                required DateTime takenAt,
                Value<int> rowid = const Value.absent(),
              }) => ValueSnapshotsCompanion.insert(
                month: month,
                totals: totals,
                takenAt: takenAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ValueSnapshotsTable, ValueSnapshotRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $ValueSnapshotsTable,
                    ValueSnapshotRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ValueSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ValueSnapshotsTable,
      ValueSnapshotRow,
      $$ValueSnapshotsTableFilterComposer,
      $$ValueSnapshotsTableOrderingComposer,
      $$ValueSnapshotsTableAnnotationComposer,
      $$ValueSnapshotsTableCreateCompanionBuilder,
      $$ValueSnapshotsTableUpdateCompanionBuilder,
      (
        ValueSnapshotRow,
        BaseReferences<
          _$AkashicDatabase,
          $ValueSnapshotsTable,
          ValueSnapshotRow
        >,
      ),
      ValueSnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$ItemValueSnapshotsTableCreateCompanionBuilder =
    ItemValueSnapshotsCompanion Function({
      required String itemId,
      required String month,
      required int cents,
      required String currency,
      Value<int> rowid,
    });
typedef $$ItemValueSnapshotsTableUpdateCompanionBuilder =
    ItemValueSnapshotsCompanion Function({
      Value<String> itemId,
      Value<String> month,
      Value<int> cents,
      Value<String> currency,
      Value<int> rowid,
    });

final class $$ItemValueSnapshotsTableReferences
    extends
        BaseReferences<
          _$AkashicDatabase,
          $ItemValueSnapshotsTable,
          ItemValueSnapshotRow
        > {
  $$ItemValueSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ItemsTable _itemIdTable(_$AkashicDatabase db) =>
      db.items.createAlias('item_value_snapshots__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemValueSnapshotsTableFilterComposer
    extends Composer<_$AkashicDatabase, $ItemValueSnapshotsTable> {
  $$ItemValueSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cents => $composableBuilder(
    column: $table.cents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemValueSnapshotsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ItemValueSnapshotsTable> {
  $$ItemValueSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cents => $composableBuilder(
    column: $table.cents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemValueSnapshotsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ItemValueSnapshotsTable> {
  $$ItemValueSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get cents =>
      $composableBuilder(column: $table.cents, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemValueSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ItemValueSnapshotsTable,
          ItemValueSnapshotRow,
          $$ItemValueSnapshotsTableFilterComposer,
          $$ItemValueSnapshotsTableOrderingComposer,
          $$ItemValueSnapshotsTableAnnotationComposer,
          $$ItemValueSnapshotsTableCreateCompanionBuilder,
          $$ItemValueSnapshotsTableUpdateCompanionBuilder,
          (ItemValueSnapshotRow, $$ItemValueSnapshotsTableReferences),
          ItemValueSnapshotRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$ItemValueSnapshotsTableTableManager(
    _$AkashicDatabase db,
    $ItemValueSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemValueSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemValueSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemValueSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<int> cents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemValueSnapshotsCompanion(
                itemId: itemId,
                month: month,
                cents: cents,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String month,
                required int cents,
                required String currency,
                Value<int> rowid = const Value.absent(),
              }) => ItemValueSnapshotsCompanion.insert(
                itemId: itemId,
                month: month,
                cents: cents,
                currency: currency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemValueSnapshotsTable, ItemValueSnapshotRow>(
                    table,
                  ),
                  $$ItemValueSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ItemValueSnapshotsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$ItemValueSnapshotsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemValueSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ItemValueSnapshotsTable,
      ItemValueSnapshotRow,
      $$ItemValueSnapshotsTableFilterComposer,
      $$ItemValueSnapshotsTableOrderingComposer,
      $$ItemValueSnapshotsTableAnnotationComposer,
      $$ItemValueSnapshotsTableCreateCompanionBuilder,
      $$ItemValueSnapshotsTableUpdateCompanionBuilder,
      (ItemValueSnapshotRow, $$ItemValueSnapshotsTableReferences),
      ItemValueSnapshotRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$ScanSessionsTableCreateCompanionBuilder =
    ScanSessionsCompanion Function({
      required String id,
      required DateTime startedAt,
      required String mode,
      Value<int> rowid,
    });
typedef $$ScanSessionsTableUpdateCompanionBuilder =
    ScanSessionsCompanion Function({
      Value<String> id,
      Value<DateTime> startedAt,
      Value<String> mode,
      Value<int> rowid,
    });

final class $$ScanSessionsTableReferences
    extends
        BaseReferences<_$AkashicDatabase, $ScanSessionsTable, ScanSessionRow> {
  $$ScanSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $ScanSessionEntriesTable,
    List<ScanSessionEntryRow>
  >
  _scanSessionEntriesRefsTable(_$AkashicDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.scanSessionEntries,
        aliasName: 'scan_sessions__id__scan_session_entries__session_id',
      );

  $$ScanSessionEntriesTableProcessedTableManager get scanSessionEntriesRefs {
    final manager = $$ScanSessionEntriesTableTableManager(
      $_db,
      $_db.scanSessionEntries,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scanSessionEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScanSessionsTableFilterComposer
    extends Composer<_$AkashicDatabase, $ScanSessionsTable> {
  $$ScanSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> scanSessionEntriesRefs(
    Expression<bool> Function($$ScanSessionEntriesTableFilterComposer f) f,
  ) {
    final $$ScanSessionEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scanSessionEntries,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanSessionEntriesTableFilterComposer(
            $db: $db,
            $table: $db.scanSessionEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScanSessionsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ScanSessionsTable> {
  $$ScanSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScanSessionsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ScanSessionsTable> {
  $$ScanSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  Expression<T> scanSessionEntriesRefs<T extends Object>(
    Expression<T> Function($$ScanSessionEntriesTableAnnotationComposer a) f,
  ) {
    final $$ScanSessionEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.scanSessionEntries,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ScanSessionEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.scanSessionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ScanSessionsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ScanSessionsTable,
          ScanSessionRow,
          $$ScanSessionsTableFilterComposer,
          $$ScanSessionsTableOrderingComposer,
          $$ScanSessionsTableAnnotationComposer,
          $$ScanSessionsTableCreateCompanionBuilder,
          $$ScanSessionsTableUpdateCompanionBuilder,
          (ScanSessionRow, $$ScanSessionsTableReferences),
          ScanSessionRow,
          PrefetchHooks Function({bool scanSessionEntriesRefs})
        > {
  $$ScanSessionsTableTableManager(
    _$AkashicDatabase db,
    $ScanSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanSessionsCompanion(
                id: id,
                startedAt: startedAt,
                mode: mode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                required String mode,
                Value<int> rowid = const Value.absent(),
              }) => ScanSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                mode: mode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScanSessionsTable, ScanSessionRow>(table),
                  $$ScanSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scanSessionEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (scanSessionEntriesRefs) db.scanSessionEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scanSessionEntriesRefs)
                    await $_getPrefetchedData<
                      ScanSessionRow,
                      $ScanSessionsTable,
                      ScanSessionEntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$ScanSessionsTableReferences
                          ._scanSessionEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ScanSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).scanSessionEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ScanSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ScanSessionsTable,
      ScanSessionRow,
      $$ScanSessionsTableFilterComposer,
      $$ScanSessionsTableOrderingComposer,
      $$ScanSessionsTableAnnotationComposer,
      $$ScanSessionsTableCreateCompanionBuilder,
      $$ScanSessionsTableUpdateCompanionBuilder,
      (ScanSessionRow, $$ScanSessionsTableReferences),
      ScanSessionRow,
      PrefetchHooks Function({bool scanSessionEntriesRefs})
    >;
typedef $$ScanSessionEntriesTableCreateCompanionBuilder =
    ScanSessionEntriesCompanion Function({
      required String sessionId,
      required int position,
      required String title,
      required String outcome,
      required String source,
      Value<String?> itemId,
      Value<int> rowid,
    });
typedef $$ScanSessionEntriesTableUpdateCompanionBuilder =
    ScanSessionEntriesCompanion Function({
      Value<String> sessionId,
      Value<int> position,
      Value<String> title,
      Value<String> outcome,
      Value<String> source,
      Value<String?> itemId,
      Value<int> rowid,
    });

final class $$ScanSessionEntriesTableReferences
    extends
        BaseReferences<
          _$AkashicDatabase,
          $ScanSessionEntriesTable,
          ScanSessionEntryRow
        > {
  $$ScanSessionEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ScanSessionsTable _sessionIdTable(_$AkashicDatabase db) => db
      .scanSessions
      .createAlias('scan_session_entries__session_id__scan_sessions__id');

  $$ScanSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$ScanSessionsTableTableManager(
      $_db,
      $_db.scanSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScanSessionEntriesTableFilterComposer
    extends Composer<_$AkashicDatabase, $ScanSessionEntriesTable> {
  $$ScanSessionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  $$ScanSessionsTableFilterComposer get sessionId {
    final $$ScanSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.scanSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanSessionsTableFilterComposer(
            $db: $db,
            $table: $db.scanSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanSessionEntriesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ScanSessionEntriesTable> {
  $$ScanSessionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ScanSessionsTableOrderingComposer get sessionId {
    final $$ScanSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.scanSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.scanSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanSessionEntriesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ScanSessionEntriesTable> {
  $$ScanSessionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  $$ScanSessionsTableAnnotationComposer get sessionId {
    final $$ScanSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.scanSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.scanSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanSessionEntriesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ScanSessionEntriesTable,
          ScanSessionEntryRow,
          $$ScanSessionEntriesTableFilterComposer,
          $$ScanSessionEntriesTableOrderingComposer,
          $$ScanSessionEntriesTableAnnotationComposer,
          $$ScanSessionEntriesTableCreateCompanionBuilder,
          $$ScanSessionEntriesTableUpdateCompanionBuilder,
          (ScanSessionEntryRow, $$ScanSessionEntriesTableReferences),
          ScanSessionEntryRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$ScanSessionEntriesTableTableManager(
    _$AkashicDatabase db,
    $ScanSessionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanSessionEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanSessionEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanSessionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanSessionEntriesCompanion(
                sessionId: sessionId,
                position: position,
                title: title,
                outcome: outcome,
                source: source,
                itemId: itemId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required int position,
                required String title,
                required String outcome,
                required String source,
                Value<String?> itemId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanSessionEntriesCompanion.insert(
                sessionId: sessionId,
                position: position,
                title: title,
                outcome: outcome,
                source: source,
                itemId: itemId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScanSessionEntriesTable, ScanSessionEntryRow>(
                    table,
                  ),
                  $$ScanSessionEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$ScanSessionEntriesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$ScanSessionEntriesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScanSessionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ScanSessionEntriesTable,
      ScanSessionEntryRow,
      $$ScanSessionEntriesTableFilterComposer,
      $$ScanSessionEntriesTableOrderingComposer,
      $$ScanSessionEntriesTableAnnotationComposer,
      $$ScanSessionEntriesTableCreateCompanionBuilder,
      $$ScanSessionEntriesTableUpdateCompanionBuilder,
      (ScanSessionEntryRow, $$ScanSessionEntriesTableReferences),
      ScanSessionEntryRow,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$ActivityEventsTableCreateCompanionBuilder =
    ActivityEventsCompanion Function({
      Value<int> id,
      required String kind,
      Value<String?> itemId,
      Value<String?> categoryId,
      required String title,
      Value<int?> amountCents,
      Value<String?> currency,
      Value<String?> detail,
      required DateTime at,
    });
typedef $$ActivityEventsTableUpdateCompanionBuilder =
    ActivityEventsCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<String?> itemId,
      Value<String?> categoryId,
      Value<String> title,
      Value<int?> amountCents,
      Value<String?> currency,
      Value<String?> detail,
      Value<DateTime> at,
    });

class $$ActivityEventsTableFilterComposer
    extends Composer<_$AkashicDatabase, $ActivityEventsTable> {
  $$ActivityEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityEventsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ActivityEventsTable> {
  $$ActivityEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityEventsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ActivityEventsTable> {
  $$ActivityEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$ActivityEventsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ActivityEventsTable,
          ActivityEventRow,
          $$ActivityEventsTableFilterComposer,
          $$ActivityEventsTableOrderingComposer,
          $$ActivityEventsTableAnnotationComposer,
          $$ActivityEventsTableCreateCompanionBuilder,
          $$ActivityEventsTableUpdateCompanionBuilder,
          (
            ActivityEventRow,
            BaseReferences<
              _$AkashicDatabase,
              $ActivityEventsTable,
              ActivityEventRow
            >,
          ),
          ActivityEventRow,
          PrefetchHooks Function()
        > {
  $$ActivityEventsTableTableManager(
    _$AkashicDatabase db,
    $ActivityEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> amountCents = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> detail = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => ActivityEventsCompanion(
                id: id,
                kind: kind,
                itemId: itemId,
                categoryId: categoryId,
                title: title,
                amountCents: amountCents,
                currency: currency,
                detail: detail,
                at: at,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                Value<String?> itemId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required String title,
                Value<int?> amountCents = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> detail = const Value.absent(),
                required DateTime at,
              }) => ActivityEventsCompanion.insert(
                id: id,
                kind: kind,
                itemId: itemId,
                categoryId: categoryId,
                title: title,
                amountCents: amountCents,
                currency: currency,
                detail: detail,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityEventsTable, ActivityEventRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $ActivityEventsTable,
                    ActivityEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ActivityEventsTable,
      ActivityEventRow,
      $$ActivityEventsTableFilterComposer,
      $$ActivityEventsTableOrderingComposer,
      $$ActivityEventsTableAnnotationComposer,
      $$ActivityEventsTableCreateCompanionBuilder,
      $$ActivityEventsTableUpdateCompanionBuilder,
      (
        ActivityEventRow,
        BaseReferences<
          _$AkashicDatabase,
          $ActivityEventsTable,
          ActivityEventRow
        >,
      ),
      ActivityEventRow,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required int year,
  required String measure,
  Value<String?> categoryId,
  required int target,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<int> year,
  Value<String> measure,
  Value<String?> categoryId,
  Value<int> target,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$GoalsTableFilterComposer
    extends Composer<_$AkashicDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measure => $composableBuilder(
    column: $table.measure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measure => $composableBuilder(
    column: $table.measure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get measure =>
      $composableBuilder(column: $table.measure, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $GoalsTable,
          GoalRow,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (GoalRow, BaseReferences<_$AkashicDatabase, $GoalsTable, GoalRow>),
          GoalRow,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AkashicDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> measure = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                year: year,
                measure: measure,
                categoryId: categoryId,
                target: target,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int year,
                required String measure,
                Value<String?> categoryId = const Value.absent(),
                required int target,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                year: year,
                measure: measure,
                categoryId: categoryId,
                target: target,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTable, GoalRow>(table),
                  BaseReferences<_$AkashicDatabase, $GoalsTable, GoalRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $GoalsTable,
      GoalRow,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (GoalRow, BaseReferences<_$AkashicDatabase, $GoalsTable, GoalRow>),
      GoalRow,
      PrefetchHooks Function()
    >;
typedef $$ItemTagsTableCreateCompanionBuilder = ItemTagsCompanion Function({
  required String itemId,
  required String tag,
  Value<int> rowid,
});
typedef $$ItemTagsTableUpdateCompanionBuilder = ItemTagsCompanion Function({
  Value<String> itemId,
  Value<String> tag,
  Value<int> rowid,
});

final class $$ItemTagsTableReferences
    extends BaseReferences<_$AkashicDatabase, $ItemTagsTable, ItemTagRow> {
  $$ItemTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AkashicDatabase db) =>
      db.items.createAlias('item_tags__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemTagsTableFilterComposer
    extends Composer<_$AkashicDatabase, $ItemTagsTable> {
  $$ItemTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemTagsTableOrderingComposer
    extends Composer<_$AkashicDatabase, $ItemTagsTable> {
  $$ItemTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemTagsTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $ItemTagsTable> {
  $$ItemTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemTagsTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $ItemTagsTable,
          ItemTagRow,
          $$ItemTagsTableFilterComposer,
          $$ItemTagsTableOrderingComposer,
          $$ItemTagsTableAnnotationComposer,
          $$ItemTagsTableCreateCompanionBuilder,
          $$ItemTagsTableUpdateCompanionBuilder,
          (ItemTagRow, $$ItemTagsTableReferences),
          ItemTagRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$ItemTagsTableTableManager(_$AkashicDatabase db, $ItemTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> itemId = const Value.absent(),
            Value<String> tag = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ItemTagsCompanion(itemId: itemId, tag: tag, rowid: rowid),
          createCompanionCallback:
              ({
                required String itemId,
                required String tag,
                Value<int> rowid = const Value.absent(),
              }) => ItemTagsCompanion.insert(
                itemId: itemId,
                tag: tag,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemTagsTable, ItemTagRow>(table),
                  $$ItemTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ItemTagsTableReferences._itemIdTable(
                          db,
                        ),
                        referencedColumn: $$ItemTagsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $ItemTagsTable,
      ItemTagRow,
      $$ItemTagsTableFilterComposer,
      $$ItemTagsTableOrderingComposer,
      $$ItemTagsTableAnnotationComposer,
      $$ItemTagsTableCreateCompanionBuilder,
      $$ItemTagsTableUpdateCompanionBuilder,
      (ItemTagRow, $$ItemTagsTableReferences),
      ItemTagRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$SmartShelvesTableCreateCompanionBuilder =
    SmartShelvesCompanion Function({
      required String id,
      required String name,
      Value<String?> categoryId,
      required String filter,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SmartShelvesTableUpdateCompanionBuilder =
    SmartShelvesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> categoryId,
      Value<String> filter,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SmartShelvesTableFilterComposer
    extends Composer<_$AkashicDatabase, $SmartShelvesTable> {
  $$SmartShelvesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filter => $composableBuilder(
    column: $table.filter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SmartShelvesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $SmartShelvesTable> {
  $$SmartShelvesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filter => $composableBuilder(
    column: $table.filter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmartShelvesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $SmartShelvesTable> {
  $$SmartShelvesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filter =>
      $composableBuilder(column: $table.filter, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SmartShelvesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $SmartShelvesTable,
          SmartShelfRow,
          $$SmartShelvesTableFilterComposer,
          $$SmartShelvesTableOrderingComposer,
          $$SmartShelvesTableAnnotationComposer,
          $$SmartShelvesTableCreateCompanionBuilder,
          $$SmartShelvesTableUpdateCompanionBuilder,
          (
            SmartShelfRow,
            BaseReferences<
              _$AkashicDatabase,
              $SmartShelvesTable,
              SmartShelfRow
            >,
          ),
          SmartShelfRow,
          PrefetchHooks Function()
        > {
  $$SmartShelvesTableTableManager(
    _$AkashicDatabase db,
    $SmartShelvesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmartShelvesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmartShelvesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmartShelvesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> filter = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SmartShelvesCompanion(
                id: id,
                name: name,
                categoryId: categoryId,
                filter: filter,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> categoryId = const Value.absent(),
                required String filter,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SmartShelvesCompanion.insert(
                id: id,
                name: name,
                categoryId: categoryId,
                filter: filter,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SmartShelvesTable, SmartShelfRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $SmartShelvesTable,
                    SmartShelfRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmartShelvesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $SmartShelvesTable,
      SmartShelfRow,
      $$SmartShelvesTableFilterComposer,
      $$SmartShelvesTableOrderingComposer,
      $$SmartShelvesTableAnnotationComposer,
      $$SmartShelvesTableCreateCompanionBuilder,
      $$SmartShelvesTableUpdateCompanionBuilder,
      (
        SmartShelfRow,
        BaseReferences<_$AkashicDatabase, $SmartShelvesTable, SmartShelfRow>,
      ),
      SmartShelfRow,
      PrefetchHooks Function()
    >;
typedef $$StoragePlacesTableCreateCompanionBuilder =
    StoragePlacesCompanion Function({
      required String id,
      Value<String?> parentId,
      required String name,
      Value<int> position,
      Value<int> rowid,
    });
typedef $$StoragePlacesTableUpdateCompanionBuilder =
    StoragePlacesCompanion Function({
      Value<String> id,
      Value<String?> parentId,
      Value<String> name,
      Value<int> position,
      Value<int> rowid,
    });

class $$StoragePlacesTableFilterComposer
    extends Composer<_$AkashicDatabase, $StoragePlacesTable> {
  $$StoragePlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoragePlacesTableOrderingComposer
    extends Composer<_$AkashicDatabase, $StoragePlacesTable> {
  $$StoragePlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoragePlacesTableAnnotationComposer
    extends Composer<_$AkashicDatabase, $StoragePlacesTable> {
  $$StoragePlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$StoragePlacesTableTableManager
    extends
        RootTableManager<
          _$AkashicDatabase,
          $StoragePlacesTable,
          StoragePlaceRow,
          $$StoragePlacesTableFilterComposer,
          $$StoragePlacesTableOrderingComposer,
          $$StoragePlacesTableAnnotationComposer,
          $$StoragePlacesTableCreateCompanionBuilder,
          $$StoragePlacesTableUpdateCompanionBuilder,
          (
            StoragePlaceRow,
            BaseReferences<
              _$AkashicDatabase,
              $StoragePlacesTable,
              StoragePlaceRow
            >,
          ),
          StoragePlaceRow,
          PrefetchHooks Function()
        > {
  $$StoragePlacesTableTableManager(
    _$AkashicDatabase db,
    $StoragePlacesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoragePlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoragePlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoragePlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoragePlacesCompanion(
                id: id,
                parentId: parentId,
                name: name,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> parentId = const Value.absent(),
                required String name,
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoragePlacesCompanion.insert(
                id: id,
                parentId: parentId,
                name: name,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoragePlacesTable, StoragePlaceRow>(table),
                  BaseReferences<
                    _$AkashicDatabase,
                    $StoragePlacesTable,
                    StoragePlaceRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoragePlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AkashicDatabase,
      $StoragePlacesTable,
      StoragePlaceRow,
      $$StoragePlacesTableFilterComposer,
      $$StoragePlacesTableOrderingComposer,
      $$StoragePlacesTableAnnotationComposer,
      $$StoragePlacesTableCreateCompanionBuilder,
      $$StoragePlacesTableUpdateCompanionBuilder,
      (
        StoragePlaceRow,
        BaseReferences<_$AkashicDatabase, $StoragePlacesTable, StoragePlaceRow>,
      ),
      StoragePlaceRow,
      PrefetchHooks Function()
    >;

class $AkashicDatabaseManager {
  final _$AkashicDatabase _db;
  $AkashicDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SeriesTableTableTableManager get seriesTable =>
      $$SeriesTableTableTableManager(_db, _db.seriesTable);
  $$SeriesTitlesTableTableManager get seriesTitles =>
      $$SeriesTitlesTableTableManager(_db, _db.seriesTitles);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$ItemTitlesTableTableManager get itemTitles =>
      $$ItemTitlesTableTableManager(_db, _db.itemTitles);
  $$CopiesTableTableManager get copies =>
      $$CopiesTableTableManager(_db, _db.copies);
  $$CopyConditionsTableTableManager get copyConditions =>
      $$CopyConditionsTableTableManager(_db, _db.copyConditions);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
  $$DeckCardsTableTableManager get deckCards =>
      $$DeckCardsTableTableManager(_db, _db.deckCards);
  $$ItemDetailsTableTableManager get itemDetails =>
      $$ItemDetailsTableTableManager(_db, _db.itemDetails);
  $$WishesTableTableManager get wishes =>
      $$WishesTableTableManager(_db, _db.wishes);
  $$DismissedSuggestionsTableTableManager get dismissedSuggestions =>
      $$DismissedSuggestionsTableTableManager(_db, _db.dismissedSuggestions);
  $$DiscoveryCacheTableTableManager get discoveryCache =>
      $$DiscoveryCacheTableTableManager(_db, _db.discoveryCache);
  $$ScanFollowsTableTableManager get scanFollows =>
      $$ScanFollowsTableTableManager(_db, _db.scanFollows);
  $$ReadChaptersTableTableManager get readChapters =>
      $$ReadChaptersTableTableManager(_db, _db.readChapters);
  $$ScanReleasesTableTableManager get scanReleases =>
      $$ScanReleasesTableTableManager(_db, _db.scanReleases);
  $$SourceBlocksTableTableManager get sourceBlocks =>
      $$SourceBlocksTableTableManager(_db, _db.sourceBlocks);
  $$ItemPhotosTableTableManager get itemPhotos =>
      $$ItemPhotosTableTableManager(_db, _db.itemPhotos);
  $$SteamGameStatsTableTableManager get steamGameStats =>
      $$SteamGameStatsTableTableManager(_db, _db.steamGameStats);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SealedPricesTableTableManager get sealedPrices =>
      $$SealedPricesTableTableManager(_db, _db.sealedPrices);
  $$SteamWatchesTableTableManager get steamWatches =>
      $$SteamWatchesTableTableManager(_db, _db.steamWatches);
  $$SteamKnownDlcsTableTableManager get steamKnownDlcs =>
      $$SteamKnownDlcsTableTableManager(_db, _db.steamKnownDlcs);
  $$PriceAlertsTableTableManager get priceAlerts =>
      $$PriceAlertsTableTableManager(_db, _db.priceAlerts);
  $$ValueSnapshotsTableTableManager get valueSnapshots =>
      $$ValueSnapshotsTableTableManager(_db, _db.valueSnapshots);
  $$ItemValueSnapshotsTableTableManager get itemValueSnapshots =>
      $$ItemValueSnapshotsTableTableManager(_db, _db.itemValueSnapshots);
  $$ScanSessionsTableTableManager get scanSessions =>
      $$ScanSessionsTableTableManager(_db, _db.scanSessions);
  $$ScanSessionEntriesTableTableManager get scanSessionEntries =>
      $$ScanSessionEntriesTableTableManager(_db, _db.scanSessionEntries);
  $$ActivityEventsTableTableManager get activityEvents =>
      $$ActivityEventsTableTableManager(_db, _db.activityEvents);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$ItemTagsTableTableManager get itemTags =>
      $$ItemTagsTableTableManager(_db, _db.itemTags);
  $$SmartShelvesTableTableManager get smartShelves =>
      $$SmartShelvesTableTableManager(_db, _db.smartShelves);
  $$StoragePlacesTableTableManager get storagePlaces =>
      $$StoragePlacesTableTableManager(_db, _db.storagePlaces);
}
