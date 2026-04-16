// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_escrow_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateEscrowPayload _$UpdateEscrowPayloadFromJson(Map<String, dynamic> json) {
  return _UpdateEscrowPayload.fromJson(json);
}

/// @nodoc
mixin _$UpdateEscrowPayload {
  String get signer => throw _privateConstructorUsedError;
  String get contractId => throw _privateConstructorUsedError;
  Map<String, Object?> get escrow => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this UpdateEscrowPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateEscrowPayloadCopyWith<UpdateEscrowPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateEscrowPayloadCopyWith<$Res> {
  factory $UpdateEscrowPayloadCopyWith(
          UpdateEscrowPayload value, $Res Function(UpdateEscrowPayload) then) =
      _$UpdateEscrowPayloadCopyWithImpl<$Res, UpdateEscrowPayload>;
  @useResult
  $Res call(
      {String signer,
      String contractId,
      Map<String, Object?> escrow,
      bool? isActive});
}

/// @nodoc
class _$UpdateEscrowPayloadCopyWithImpl<$Res, $Val extends UpdateEscrowPayload>
    implements $UpdateEscrowPayloadCopyWith<$Res> {
  _$UpdateEscrowPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? signer = null,
    Object? contractId = null,
    Object? escrow = null,
    Object? isActive = freezed,
  }) {
    return _then(_value.copyWith(
      signer: null == signer
          ? _value.signer
          : signer // ignore: cast_nullable_to_non_nullable
              as String,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      escrow: null == escrow
          ? _value.escrow
          : escrow // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateEscrowPayloadImplCopyWith<$Res>
    implements $UpdateEscrowPayloadCopyWith<$Res> {
  factory _$$UpdateEscrowPayloadImplCopyWith(_$UpdateEscrowPayloadImpl value,
          $Res Function(_$UpdateEscrowPayloadImpl) then) =
      __$$UpdateEscrowPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String signer,
      String contractId,
      Map<String, Object?> escrow,
      bool? isActive});
}

/// @nodoc
class __$$UpdateEscrowPayloadImplCopyWithImpl<$Res>
    extends _$UpdateEscrowPayloadCopyWithImpl<$Res, _$UpdateEscrowPayloadImpl>
    implements _$$UpdateEscrowPayloadImplCopyWith<$Res> {
  __$$UpdateEscrowPayloadImplCopyWithImpl(_$UpdateEscrowPayloadImpl _value,
      $Res Function(_$UpdateEscrowPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? signer = null,
    Object? contractId = null,
    Object? escrow = null,
    Object? isActive = freezed,
  }) {
    return _then(_$UpdateEscrowPayloadImpl(
      signer: null == signer
          ? _value.signer
          : signer // ignore: cast_nullable_to_non_nullable
              as String,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      escrow: null == escrow
          ? _value._escrow
          : escrow // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$UpdateEscrowPayloadImpl implements _UpdateEscrowPayload {
  const _$UpdateEscrowPayloadImpl(
      {required this.signer,
      required this.contractId,
      required final Map<String, Object?> escrow,
      this.isActive})
      : _escrow = escrow;

  factory _$UpdateEscrowPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateEscrowPayloadImplFromJson(json);

  @override
  final String signer;
  @override
  final String contractId;
  final Map<String, Object?> _escrow;
  @override
  Map<String, Object?> get escrow {
    if (_escrow is EqualUnmodifiableMapView) return _escrow;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_escrow);
  }

  @override
  final bool? isActive;

  @override
  String toString() {
    return 'UpdateEscrowPayload(signer: $signer, contractId: $contractId, escrow: $escrow, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateEscrowPayloadImpl &&
            (identical(other.signer, signer) || other.signer == signer) &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            const DeepCollectionEquality().equals(other._escrow, _escrow) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, signer, contractId,
      const DeepCollectionEquality().hash(_escrow), isActive);

  /// Create a copy of UpdateEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateEscrowPayloadImplCopyWith<_$UpdateEscrowPayloadImpl> get copyWith =>
      __$$UpdateEscrowPayloadImplCopyWithImpl<_$UpdateEscrowPayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateEscrowPayloadImplToJson(
      this,
    );
  }
}

abstract class _UpdateEscrowPayload implements UpdateEscrowPayload {
  const factory _UpdateEscrowPayload(
      {required final String signer,
      required final String contractId,
      required final Map<String, Object?> escrow,
      final bool? isActive}) = _$UpdateEscrowPayloadImpl;

  factory _UpdateEscrowPayload.fromJson(Map<String, dynamic> json) =
      _$UpdateEscrowPayloadImpl.fromJson;

  @override
  String get signer;
  @override
  String get contractId;
  @override
  Map<String, Object?> get escrow;
  @override
  bool? get isActive;

  /// Create a copy of UpdateEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateEscrowPayloadImplCopyWith<_$UpdateEscrowPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
