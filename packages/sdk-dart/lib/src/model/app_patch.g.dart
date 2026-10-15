// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppPatch extends AppPatch {
  @override
  final Optional<String?> name;
  @override
  final Optional<String?> description;

  factory _$AppPatch([void Function(AppPatchBuilder)? updates]) =>
      (AppPatchBuilder()..update(updates))._build();

  _$AppPatch._({required this.name, required this.description}) : super._();
  @override
  AppPatch rebuild(void Function(AppPatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppPatchBuilder toBuilder() => AppPatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppPatch &&
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
    return (newBuiltValueToStringHelper(r'AppPatch')
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class AppPatchBuilder implements Builder<AppPatch, AppPatchBuilder> {
  _$AppPatch? _$v;

  Optional<String?>? _name;
  Optional<String?>? get name => _$this._name;
  set name(Optional<String?>? name) => _$this._name = name;

  Optional<String?>? _description;
  Optional<String?>? get description => _$this._description;
  set description(Optional<String?>? description) =>
      _$this._description = description;

  AppPatchBuilder() {
    AppPatch._defaults(this);
  }

  AppPatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppPatch other) {
    _$v = other as _$AppPatch;
  }

  @override
  void update(void Function(AppPatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppPatch build() => _build();

  _$AppPatch _build() {
    final _$result = _$v ??
        _$AppPatch._(
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'AppPatch', 'name'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'AppPatch', 'description'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
