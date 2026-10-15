// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppCreate extends AppCreate {
  @override
  final String name;
  @override
  final String? description;

  factory _$AppCreate([void Function(AppCreateBuilder)? updates]) =>
      (AppCreateBuilder()..update(updates))._build();

  _$AppCreate._({required this.name, this.description}) : super._();
  @override
  AppCreate rebuild(void Function(AppCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppCreateBuilder toBuilder() => AppCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppCreate &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppCreate')
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class AppCreateBuilder implements Builder<AppCreate, AppCreateBuilder> {
  _$AppCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AppCreateBuilder() {
    AppCreate._defaults(this);
  }

  AppCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppCreate other) {
    _$v = other as _$AppCreate;
  }

  @override
  void update(void Function(AppCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppCreate build() => _build();

  _$AppCreate _build() {
    final _$result = _$v ??
        _$AppCreate._(
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'AppCreate', 'name'),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
