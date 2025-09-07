// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'palette.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPaletteCollection on Isar {
  IsarCollection<Palette> get palettes => this.collection();
}

const PaletteSchema = CollectionSchema(
  name: r'Palette',
  id: -4117155835907815001,
  properties: {
    r'cols': PropertySchema(
      id: 0,
      name: r'cols',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'rows': PropertySchema(
      id: 2,
      name: r'rows',
      type: IsarType.long,
    )
  },
  estimateSize: _paletteEstimateSize,
  serialize: _paletteSerialize,
  deserialize: _paletteDeserialize,
  deserializeProp: _paletteDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'pads': LinkSchema(
      id: -6833624780533282033,
      name: r'pads',
      target: r'Pad',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _paletteGetId,
  getLinks: _paletteGetLinks,
  attach: _paletteAttach,
  version: '3.1.0+1',
);

int _paletteEstimateSize(
  Palette object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _paletteSerialize(
  Palette object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cols);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.rows);
}

Palette _paletteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Palette();
  object.cols = reader.readLong(offsets[0]);
  object.id = id;
  object.name = reader.readString(offsets[1]);
  object.rows = reader.readLong(offsets[2]);
  return object;
}

P _paletteDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _paletteGetId(Palette object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _paletteGetLinks(Palette object) {
  return [object.pads];
}

void _paletteAttach(IsarCollection<dynamic> col, Id id, Palette object) {
  object.id = id;
  object.pads.attach(col, col.isar.collection<Pad>(), r'pads', id);
}

extension PaletteQueryWhereSort on QueryBuilder<Palette, Palette, QWhere> {
  QueryBuilder<Palette, Palette, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PaletteQueryWhere on QueryBuilder<Palette, Palette, QWhereClause> {
  QueryBuilder<Palette, Palette, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Palette, Palette, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Palette, Palette, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Palette, Palette, QAfterWhereClause> idBetween(
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

extension PaletteQueryFilter
    on QueryBuilder<Palette, Palette, QFilterCondition> {
  QueryBuilder<Palette, Palette, QAfterFilterCondition> colsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cols',
        value: value,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> colsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cols',
        value: value,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> colsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cols',
        value: value,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> colsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cols',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Palette, Palette, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Palette, Palette, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> rowsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rows',
        value: value,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> rowsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rows',
        value: value,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> rowsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rows',
        value: value,
      ));
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> rowsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rows',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PaletteQueryObject
    on QueryBuilder<Palette, Palette, QFilterCondition> {}

extension PaletteQueryLinks
    on QueryBuilder<Palette, Palette, QFilterCondition> {
  QueryBuilder<Palette, Palette, QAfterFilterCondition> pads(
      FilterQuery<Pad> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pads');
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> padsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pads', length, true, length, true);
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> padsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pads', 0, true, 0, true);
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> padsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pads', 0, false, 999999, true);
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> padsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pads', 0, true, length, include);
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> padsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pads', length, include, 999999, true);
    });
  }

  QueryBuilder<Palette, Palette, QAfterFilterCondition> padsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pads', lower, includeLower, upper, includeUpper);
    });
  }
}

extension PaletteQuerySortBy on QueryBuilder<Palette, Palette, QSortBy> {
  QueryBuilder<Palette, Palette, QAfterSortBy> sortByCols() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cols', Sort.asc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> sortByColsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cols', Sort.desc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> sortByRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rows', Sort.asc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> sortByRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rows', Sort.desc);
    });
  }
}

extension PaletteQuerySortThenBy
    on QueryBuilder<Palette, Palette, QSortThenBy> {
  QueryBuilder<Palette, Palette, QAfterSortBy> thenByCols() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cols', Sort.asc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> thenByColsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cols', Sort.desc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> thenByRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rows', Sort.asc);
    });
  }

  QueryBuilder<Palette, Palette, QAfterSortBy> thenByRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rows', Sort.desc);
    });
  }
}

extension PaletteQueryWhereDistinct
    on QueryBuilder<Palette, Palette, QDistinct> {
  QueryBuilder<Palette, Palette, QDistinct> distinctByCols() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cols');
    });
  }

  QueryBuilder<Palette, Palette, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Palette, Palette, QDistinct> distinctByRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rows');
    });
  }
}

extension PaletteQueryProperty
    on QueryBuilder<Palette, Palette, QQueryProperty> {
  QueryBuilder<Palette, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Palette, int, QQueryOperations> colsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cols');
    });
  }

  QueryBuilder<Palette, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Palette, int, QQueryOperations> rowsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rows');
    });
  }
}
