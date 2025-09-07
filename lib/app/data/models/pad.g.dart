// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pad.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPadCollection on Isar {
  IsarCollection<Pad> get pads => this.collection();
}

const PadSchema = CollectionSchema(
  name: r'Pad',
  id: 566745804739562807,
  properties: {
    r'color': PropertySchema(
      id: 0,
      name: r'color',
      type: IsarType.long,
    ),
    r'fadeInMs': PropertySchema(
      id: 1,
      name: r'fadeInMs',
      type: IsarType.long,
    ),
    r'fadeOutMs': PropertySchema(
      id: 2,
      name: r'fadeOutMs',
      type: IsarType.long,
    ),
    r'hotkey': PropertySchema(
      id: 3,
      name: r'hotkey',
      type: IsarType.string,
    ),
    r'loop': PropertySchema(
      id: 4,
      name: r'loop',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(
      id: 5,
      name: r'title',
      type: IsarType.string,
    ),
    r'trimEnd': PropertySchema(
      id: 6,
      name: r'trimEnd',
      type: IsarType.double,
    ),
    r'trimStart': PropertySchema(
      id: 7,
      name: r'trimStart',
      type: IsarType.double,
    ),
    r'uri': PropertySchema(
      id: 8,
      name: r'uri',
      type: IsarType.string,
    ),
    r'volume': PropertySchema(
      id: 9,
      name: r'volume',
      type: IsarType.double,
    )
  },
  estimateSize: _padEstimateSize,
  serialize: _padSerialize,
  deserialize: _padDeserialize,
  deserializeProp: _padDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _padGetId,
  getLinks: _padGetLinks,
  attach: _padAttach,
  version: '3.1.0+1',
);

int _padEstimateSize(
  Pad object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.hotkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.uri.length * 3;
  return bytesCount;
}

void _padSerialize(
  Pad object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.color);
  writer.writeLong(offsets[1], object.fadeInMs);
  writer.writeLong(offsets[2], object.fadeOutMs);
  writer.writeString(offsets[3], object.hotkey);
  writer.writeBool(offsets[4], object.loop);
  writer.writeString(offsets[5], object.title);
  writer.writeDouble(offsets[6], object.trimEnd);
  writer.writeDouble(offsets[7], object.trimStart);
  writer.writeString(offsets[8], object.uri);
  writer.writeDouble(offsets[9], object.volume);
}

Pad _padDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Pad();
  object.color = reader.readLong(offsets[0]);
  object.fadeInMs = reader.readLong(offsets[1]);
  object.fadeOutMs = reader.readLong(offsets[2]);
  object.hotkey = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.loop = reader.readBool(offsets[4]);
  object.title = reader.readString(offsets[5]);
  object.trimEnd = reader.readDoubleOrNull(offsets[6]);
  object.trimStart = reader.readDoubleOrNull(offsets[7]);
  object.uri = reader.readString(offsets[8]);
  object.volume = reader.readDouble(offsets[9]);
  return object;
}

P _padDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _padGetId(Pad object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _padGetLinks(Pad object) {
  return [];
}

void _padAttach(IsarCollection<dynamic> col, Id id, Pad object) {
  object.id = id;
}

extension PadQueryWhereSort on QueryBuilder<Pad, Pad, QWhere> {
  QueryBuilder<Pad, Pad, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PadQueryWhere on QueryBuilder<Pad, Pad, QWhereClause> {
  QueryBuilder<Pad, Pad, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Pad, Pad, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Pad, Pad, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Pad, Pad, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PadQueryFilter on QueryBuilder<Pad, Pad, QFilterCondition> {
  QueryBuilder<Pad, Pad, QAfterFilterCondition> colorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> colorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> colorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> colorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> fadeInMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fadeInMs',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> fadeInMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fadeInMs',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> fadeInMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fadeInMs',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> fadeInMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fadeInMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> fadeOutMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fadeOutMs',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> fadeOutMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fadeOutMs',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> fadeOutMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fadeOutMs',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> fadeOutMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fadeOutMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hotkey',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hotkey',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hotkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hotkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hotkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hotkey',
        value: '',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> hotkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hotkey',
        value: '',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> loopEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loop',
        value: value,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimEndIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trimEnd',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimEndIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trimEnd',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimEndEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trimEnd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimEndGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trimEnd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimEndLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trimEnd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimEndBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trimEnd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimStartIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trimStart',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimStartIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trimStart',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimStartEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trimStart',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimStartGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trimStart',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimStartLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trimStart',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> trimStartBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trimStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uri',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uri',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uri',
        value: '',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> uriIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uri',
        value: '',
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> volumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> volumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'volume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> volumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'volume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Pad, Pad, QAfterFilterCondition> volumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'volume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PadQueryObject on QueryBuilder<Pad, Pad, QFilterCondition> {}

extension PadQueryLinks on QueryBuilder<Pad, Pad, QFilterCondition> {}

extension PadQuerySortBy on QueryBuilder<Pad, Pad, QSortBy> {
  QueryBuilder<Pad, Pad, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByFadeInMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fadeInMs', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByFadeInMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fadeInMs', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByFadeOutMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fadeOutMs', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByFadeOutMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fadeOutMs', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByHotkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hotkey', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByHotkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hotkey', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByLoop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loop', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByLoopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loop', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByTrimEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trimEnd', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByTrimEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trimEnd', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByTrimStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trimStart', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByTrimStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trimStart', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volume', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> sortByVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volume', Sort.desc);
    });
  }
}

extension PadQuerySortThenBy on QueryBuilder<Pad, Pad, QSortThenBy> {
  QueryBuilder<Pad, Pad, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByFadeInMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fadeInMs', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByFadeInMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fadeInMs', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByFadeOutMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fadeOutMs', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByFadeOutMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fadeOutMs', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByHotkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hotkey', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByHotkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hotkey', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByLoop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loop', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByLoopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loop', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByTrimEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trimEnd', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByTrimEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trimEnd', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByTrimStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trimStart', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByTrimStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trimStart', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.desc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volume', Sort.asc);
    });
  }

  QueryBuilder<Pad, Pad, QAfterSortBy> thenByVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volume', Sort.desc);
    });
  }
}

extension PadQueryWhereDistinct on QueryBuilder<Pad, Pad, QDistinct> {
  QueryBuilder<Pad, Pad, QDistinct> distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color');
    });
  }

  QueryBuilder<Pad, Pad, QDistinct> distinctByFadeInMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fadeInMs');
    });
  }

  QueryBuilder<Pad, Pad, QDistinct> distinctByFadeOutMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fadeOutMs');
    });
  }

  QueryBuilder<Pad, Pad, QDistinct> distinctByHotkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hotkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Pad, Pad, QDistinct> distinctByLoop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loop');
    });
  }

  QueryBuilder<Pad, Pad, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Pad, Pad, QDistinct> distinctByTrimEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trimEnd');
    });
  }

  QueryBuilder<Pad, Pad, QDistinct> distinctByTrimStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trimStart');
    });
  }

  QueryBuilder<Pad, Pad, QDistinct> distinctByUri({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uri', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Pad, Pad, QDistinct> distinctByVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volume');
    });
  }
}

extension PadQueryProperty on QueryBuilder<Pad, Pad, QQueryProperty> {
  QueryBuilder<Pad, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Pad, int, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<Pad, int, QQueryOperations> fadeInMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fadeInMs');
    });
  }

  QueryBuilder<Pad, int, QQueryOperations> fadeOutMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fadeOutMs');
    });
  }

  QueryBuilder<Pad, String?, QQueryOperations> hotkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hotkey');
    });
  }

  QueryBuilder<Pad, bool, QQueryOperations> loopProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loop');
    });
  }

  QueryBuilder<Pad, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Pad, double?, QQueryOperations> trimEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trimEnd');
    });
  }

  QueryBuilder<Pad, double?, QQueryOperations> trimStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trimStart');
    });
  }

  QueryBuilder<Pad, String, QQueryOperations> uriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uri');
    });
  }

  QueryBuilder<Pad, double, QQueryOperations> volumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volume');
    });
  }
}
