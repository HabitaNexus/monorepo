// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'release_funds_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReleaseFundsPayload _$ReleaseFundsPayloadFromJson(Map<String, dynamic> json) {
  return _ReleaseFundsPayload.fromJson(json);
}

/// @nodoc
mixin _$ReleaseFundsPayload {
  String get contractId => throw _privateConstructorUsedError;
  String get releaseSigner => throw _privateConstructorUsedError;

  /// Serializes this ReleaseFundsPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReleaseFundsPayloadCopyWith<ReleaseFundsPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReleaseFundsPayloadCopyWith<$Res> {
  factory $ReleaseFundsPayloadCopyWith(
          ReleaseFundsPayload value, $Res Function(ReleaseFundsPayload) then) =
      _$ReleaseFundsPayloadCopyWithImpl<$Res, ReleaseFundsPayload>;
  @useResult
  $Res call({String contractId, String releaseSigner});
}

/// @nodoc
class _$ReleaseFundsPayloadCopyWithImpl<$Res, $Val extends ReleaseFundsPayload>
    implements $ReleaseFundsPayloadCopyWith<$Res> {
  _$ReleaseFundsPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? releaseSigner = null,
  }) {
    return _then(_value.copyWith(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      releaseSigner: null == releaseSigner
          ? _value.releaseSigner
          : releaseSigner // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReleaseFundsPayloadImplCopyWith<$Res>
    implements $ReleaseFundsPayloadCopyWith<$Res> {
  factory _$$ReleaseFundsPayloadImplCopyWith(_$ReleaseFundsPayloadImpl value,
          $Res Function(_$ReleaseFundsPayloadImpl) then) =
      __$$ReleaseFundsPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String contractId, String releaseSigner});
}

/// @nodoc
class __$$ReleaseFundsPayloadImplCopyWithImpl<$Res>
    extends _$ReleaseFundsPayloadCopyWithImpl<$Res, _$ReleaseFundsPayloadImpl>
    implements _$$ReleaseFundsPayloadImplCopyWith<$Res> {
  __$$ReleaseFundsPayloadImplCopyWithImpl(_$ReleaseFundsPayloadImpl _value,
      $Res Function(_$ReleaseFundsPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? releaseSigner = null,
  }) {
    return _then(_$ReleaseFundsPayloadImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      releaseSigner: null == releaseSigner
          ? _value.releaseSigner
          : releaseSigner // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReleaseFundsPayloadImpl implements _ReleaseFundsPayload {
  const _$ReleaseFundsPayloadImpl(
      {required this.contractId, required this.releaseSigner});

  factory _$ReleaseFundsPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReleaseFundsPayloadImplFromJson(json);

  @override
  final String contractId;
  @override
  final String releaseSigner;

  @override
  String toString() {
    return 'ReleaseFundsPayload(contractId: $contractId, releaseSigner: $releaseSigner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReleaseFundsPayloadImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.releaseSigner, releaseSigner) ||
                other.releaseSigner == releaseSigner));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contractId, releaseSigner);

  /// Create a copy of ReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReleaseFundsPayloadImplCopyWith<_$ReleaseFundsPayloadImpl> get copyWith =>
      __$$ReleaseFundsPayloadImplCopyWithImpl<_$ReleaseFundsPayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReleaseFundsPayloadImplToJson(
      this,
    );
  }
}

abstract class _ReleaseFundsPayload implements ReleaseFundsPayload {
  const factory _ReleaseFundsPayload(
      {required final String contractId,
      required final String releaseSigner}) = _$ReleaseFundsPayloadImpl;

  factory _ReleaseFundsPayload.fromJson(Map<String, dynamic> json) =
      _$ReleaseFundsPayloadImpl.fromJson;

  @override
  String get contractId;
  @override
  String get releaseSigner;

  /// Create a copy of ReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReleaseFundsPayloadImplCopyWith<_$ReleaseFundsPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
