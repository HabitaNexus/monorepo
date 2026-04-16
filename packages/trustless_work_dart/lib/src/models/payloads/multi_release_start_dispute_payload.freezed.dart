// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_release_start_dispute_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MultiReleaseStartDisputePayload _$MultiReleaseStartDisputePayloadFromJson(
    Map<String, dynamic> json) {
  return _MultiReleaseStartDisputePayload.fromJson(json);
}

/// @nodoc
mixin _$MultiReleaseStartDisputePayload {
  String get contractId => throw _privateConstructorUsedError;
  String get milestoneIndex => throw _privateConstructorUsedError;
  String get signer => throw _privateConstructorUsedError;

  /// Serializes this MultiReleaseStartDisputePayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MultiReleaseStartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultiReleaseStartDisputePayloadCopyWith<MultiReleaseStartDisputePayload>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultiReleaseStartDisputePayloadCopyWith<$Res> {
  factory $MultiReleaseStartDisputePayloadCopyWith(
          MultiReleaseStartDisputePayload value,
          $Res Function(MultiReleaseStartDisputePayload) then) =
      _$MultiReleaseStartDisputePayloadCopyWithImpl<$Res,
          MultiReleaseStartDisputePayload>;
  @useResult
  $Res call({String contractId, String milestoneIndex, String signer});
}

/// @nodoc
class _$MultiReleaseStartDisputePayloadCopyWithImpl<$Res,
        $Val extends MultiReleaseStartDisputePayload>
    implements $MultiReleaseStartDisputePayloadCopyWith<$Res> {
  _$MultiReleaseStartDisputePayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultiReleaseStartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? milestoneIndex = null,
    Object? signer = null,
  }) {
    return _then(_value.copyWith(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneIndex: null == milestoneIndex
          ? _value.milestoneIndex
          : milestoneIndex // ignore: cast_nullable_to_non_nullable
              as String,
      signer: null == signer
          ? _value.signer
          : signer // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MultiReleaseStartDisputePayloadImplCopyWith<$Res>
    implements $MultiReleaseStartDisputePayloadCopyWith<$Res> {
  factory _$$MultiReleaseStartDisputePayloadImplCopyWith(
          _$MultiReleaseStartDisputePayloadImpl value,
          $Res Function(_$MultiReleaseStartDisputePayloadImpl) then) =
      __$$MultiReleaseStartDisputePayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String contractId, String milestoneIndex, String signer});
}

/// @nodoc
class __$$MultiReleaseStartDisputePayloadImplCopyWithImpl<$Res>
    extends _$MultiReleaseStartDisputePayloadCopyWithImpl<$Res,
        _$MultiReleaseStartDisputePayloadImpl>
    implements _$$MultiReleaseStartDisputePayloadImplCopyWith<$Res> {
  __$$MultiReleaseStartDisputePayloadImplCopyWithImpl(
      _$MultiReleaseStartDisputePayloadImpl _value,
      $Res Function(_$MultiReleaseStartDisputePayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of MultiReleaseStartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? milestoneIndex = null,
    Object? signer = null,
  }) {
    return _then(_$MultiReleaseStartDisputePayloadImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneIndex: null == milestoneIndex
          ? _value.milestoneIndex
          : milestoneIndex // ignore: cast_nullable_to_non_nullable
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
class _$MultiReleaseStartDisputePayloadImpl
    implements _MultiReleaseStartDisputePayload {
  const _$MultiReleaseStartDisputePayloadImpl(
      {required this.contractId,
      required this.milestoneIndex,
      required this.signer});

  factory _$MultiReleaseStartDisputePayloadImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MultiReleaseStartDisputePayloadImplFromJson(json);

  @override
  final String contractId;
  @override
  final String milestoneIndex;
  @override
  final String signer;

  @override
  String toString() {
    return 'MultiReleaseStartDisputePayload(contractId: $contractId, milestoneIndex: $milestoneIndex, signer: $signer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultiReleaseStartDisputePayloadImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.milestoneIndex, milestoneIndex) ||
                other.milestoneIndex == milestoneIndex) &&
            (identical(other.signer, signer) || other.signer == signer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, contractId, milestoneIndex, signer);

  /// Create a copy of MultiReleaseStartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultiReleaseStartDisputePayloadImplCopyWith<
          _$MultiReleaseStartDisputePayloadImpl>
      get copyWith => __$$MultiReleaseStartDisputePayloadImplCopyWithImpl<
          _$MultiReleaseStartDisputePayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MultiReleaseStartDisputePayloadImplToJson(
      this,
    );
  }
}

abstract class _MultiReleaseStartDisputePayload
    implements MultiReleaseStartDisputePayload {
  const factory _MultiReleaseStartDisputePayload(
      {required final String contractId,
      required final String milestoneIndex,
      required final String signer}) = _$MultiReleaseStartDisputePayloadImpl;

  factory _MultiReleaseStartDisputePayload.fromJson(Map<String, dynamic> json) =
      _$MultiReleaseStartDisputePayloadImpl.fromJson;

  @override
  String get contractId;
  @override
  String get milestoneIndex;
  @override
  String get signer;

  /// Create a copy of MultiReleaseStartDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultiReleaseStartDisputePayloadImplCopyWith<
          _$MultiReleaseStartDisputePayloadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
