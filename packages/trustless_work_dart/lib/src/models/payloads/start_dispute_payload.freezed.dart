// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_dispute_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StartDisputePayload _$StartDisputePayloadFromJson(Map<String, dynamic> json) {
  return _StartDisputePayload.fromJson(json);
}

/// @nodoc
mixin _$StartDisputePayload {
  String get contractId => throw _privateConstructorUsedError;
  String get signer => throw _privateConstructorUsedError;

  /// Serializes this StartDisputePayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartDisputePayloadCopyWith<StartDisputePayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartDisputePayloadCopyWith<$Res> {
  factory $StartDisputePayloadCopyWith(
          StartDisputePayload value, $Res Function(StartDisputePayload) then) =
      _$StartDisputePayloadCopyWithImpl<$Res, StartDisputePayload>;
  @useResult
  $Res call({String contractId, String signer});
}

/// @nodoc
class _$StartDisputePayloadCopyWithImpl<$Res, $Val extends StartDisputePayload>
    implements $StartDisputePayloadCopyWith<$Res> {
  _$StartDisputePayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? signer = null,
  }) {
    return _then(_value.copyWith(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      signer: null == signer
          ? _value.signer
          : signer // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StartDisputePayloadImplCopyWith<$Res>
    implements $StartDisputePayloadCopyWith<$Res> {
  factory _$$StartDisputePayloadImplCopyWith(_$StartDisputePayloadImpl value,
          $Res Function(_$StartDisputePayloadImpl) then) =
      __$$StartDisputePayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String contractId, String signer});
}

/// @nodoc
class __$$StartDisputePayloadImplCopyWithImpl<$Res>
    extends _$StartDisputePayloadCopyWithImpl<$Res, _$StartDisputePayloadImpl>
    implements _$$StartDisputePayloadImplCopyWith<$Res> {
  __$$StartDisputePayloadImplCopyWithImpl(_$StartDisputePayloadImpl _value,
      $Res Function(_$StartDisputePayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of StartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? signer = null,
  }) {
    return _then(_$StartDisputePayloadImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      signer: null == signer
          ? _value.signer
          : signer // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StartDisputePayloadImpl implements _StartDisputePayload {
  const _$StartDisputePayloadImpl(
      {required this.contractId, required this.signer});

  factory _$StartDisputePayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$StartDisputePayloadImplFromJson(json);

  @override
  final String contractId;
  @override
  final String signer;

  @override
  String toString() {
    return 'StartDisputePayload(contractId: $contractId, signer: $signer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartDisputePayloadImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.signer, signer) || other.signer == signer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contractId, signer);

  /// Create a copy of StartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartDisputePayloadImplCopyWith<_$StartDisputePayloadImpl> get copyWith =>
      __$$StartDisputePayloadImplCopyWithImpl<_$StartDisputePayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StartDisputePayloadImplToJson(
      this,
    );
  }
}

abstract class _StartDisputePayload implements StartDisputePayload {
  const factory _StartDisputePayload(
      {required final String contractId,
      required final String signer}) = _$StartDisputePayloadImpl;

  factory _StartDisputePayload.fromJson(Map<String, dynamic> json) =
      _$StartDisputePayloadImpl.fromJson;

  @override
  String get contractId;
  @override
  String get signer;

  /// Create a copy of StartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartDisputePayloadImplCopyWith<_$StartDisputePayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
