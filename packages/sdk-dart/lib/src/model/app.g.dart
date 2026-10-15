// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$App extends App {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final DateTime createdAt;

  factory _$App([void Function(AppBuilder)? updates]) =>
      (AppBuilder()..update(updates))._build();

  _$App._(
      {required this.id,
      required this.name,
      this.description,
      required this.createdAt})
      : super._();
  @override
  App rebuild(void Function(AppBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppBuilder toBuilder() => AppBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is App &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'App')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AppBuilder implements Builder<App, AppBuilder> {
  _$App? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AppBuilder() {
    App._defaults(this);
  }

  AppBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(App other) {
    _$v = other as _$App;
  }

  @override
  void update(void Function(AppBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  App build() => _build();

  _$App _build() {
    final _$result = _$v ??
        _$App._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'App', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'App', 'name'),
          description: description,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'App', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
