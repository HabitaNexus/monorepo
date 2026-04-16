// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_release_release_funds_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MultiReleaseReleaseFundsPayload _$MultiReleaseReleaseFundsPayloadFromJson(
    Map<String, dynamic> json) {
  return _MultiReleaseReleaseFundsPayload.fromJson(json);
}

/// @nodoc
mixin _$MultiReleaseReleaseFundsPayload {
  String get contractId => throw _privateConstructorUsedError;
  String get releaseSigner => throw _privateConstructorUsedError;
  String get milestoneIndex => throw _privateConstructorUsedError;

  /// Serializes this MultiReleaseReleaseFundsPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MultiReleaseReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultiReleaseReleaseFundsPayloadCopyWith<MultiReleaseReleaseFundsPayload>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultiReleaseReleaseFundsPayloadCopyWith<$Res> {
  factory $MultiReleaseReleaseFundsPayloadCopyWith(
          MultiReleaseReleaseFundsPayload value,
          $Res Function(MultiReleaseReleaseFundsPayload) then) =
      _$MultiReleaseReleaseFundsPayloadCopyWithImpl<$Res,
          MultiReleaseReleaseFundsPayload>;
  @useResult
  $Res call({String contractId, String releaseSigner, String milestoneIndex});
}

/// @nodoc
class _$MultiReleaseReleaseFundsPayloadCopyWithImpl<$Res,
        $Val extends MultiReleaseReleaseFundsPayload>
    implements $MultiReleaseReleaseFundsPayloadCopyWith<$Res> {
  _$MultiReleaseReleaseFundsPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultiReleaseReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? releaseSigner = null,
    Object? milestoneIndex = null,
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
      milestoneIndex: null == milestoneIndex
          ? _value.milestoneIndex
          : milestoneIndex // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MultiReleaseReleaseFundsPayloadImplCopyWith<$Res>
    implements $MultiReleaseReleaseFundsPayloadCopyWith<$Res> {
  factory _$$MultiReleaseReleaseFundsPayloadImplCopyWith(
          _$MultiReleaseReleaseFundsPayloadImpl value,
          $Res Function(_$MultiReleaseReleaseFundsPayloadImpl) then) =
      __$$MultiReleaseReleaseFundsPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String contractId, String releaseSigner, String milestoneIndex});
}

/// @nodoc
class __$$MultiReleaseReleaseFundsPayloadImplCopyWithImpl<$Res>
    extends _$MultiReleaseReleaseFundsPayloadCopyWithImpl<$Res,
        _$MultiReleaseReleaseFundsPayloadImpl>
    implements _$$MultiReleaseReleaseFundsPayloadImplCopyWith<$Res> {
  __$$MultiReleaseReleaseFundsPayloadImplCopyWithImpl(
      _$MultiReleaseReleaseFundsPayloadImpl _value,
      $Res Function(_$MultiReleaseReleaseFundsPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of MultiReleaseReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? releaseSigner = null,
    Object? milestoneIndex = null,
  }) {
    return _then(_$MultiReleaseReleaseFundsPayloadImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      releaseSigner: null == releaseSigner
          ? _value.releaseSigner
          : releaseSigner // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneIndex: null == milestoneIndex
          ? _value.milestoneIndex
          : milestoneIndex // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MultiReleaseReleaseFundsPayloadImpl
    implements _MultiReleaseReleaseFundsPayload {
  const _$MultiReleaseReleaseFundsPayloadImpl(
      {required this.contractId,
      required this.releaseSigner,
      required this.milestoneIndex});

  factory _$MultiReleaseReleaseFundsPayloadImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MultiReleaseReleaseFundsPayloadImplFromJson(json);

  @override
  final String contractId;
  @override
  final String releaseSigner;
  @override
  final String milestoneIndex;

  @override
  String toString() {
    return 'MultiReleaseReleaseFundsPayload(contractId: $contractId, releaseSigner: $releaseSigner, milestoneIndex: $milestoneIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultiReleaseReleaseFundsPayloadImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.releaseSigner, releaseSigner) ||
                other.releaseSigner == releaseSigner) &&
            (identical(other.milestoneIndex, milestoneIndex) ||
                other.milestoneIndex == milestoneIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, contractId, releaseSigner, milestoneIndex);

  /// Create a copy of MultiReleaseReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultiReleaseReleaseFundsPayloadImplCopyWith<
          _$MultiReleaseReleaseFundsPayloadImpl>
      get copyWith => __$$MultiReleaseReleaseFundsPayloadImplCopyWithImpl<
          _$MultiReleaseReleaseFundsPayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MultiReleaseReleaseFundsPayloadImplToJson(
      this,
    );
  }
}

abstract class _MultiReleaseReleaseFundsPayload
    implements MultiReleaseReleaseFundsPayload {
  const factory _MultiReleaseReleaseFundsPayload(
          {required final String contractId,
          required final String releaseSigner,
          required final String milestoneIndex}) =
      _$MultiReleaseReleaseFundsPayloadImpl;

  factory _MultiReleaseReleaseFundsPayload.fromJson(Map<String, dynamic> json) =
      _$MultiReleaseReleaseFundsPayloadImpl.fromJson;

  @override
  String get contractId;
  @override
  String get releaseSigner;
  @override
  String get milestoneIndex;

  /// Create a copy of MultiReleaseReleaseFundsPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultiReleaseReleaseFundsPayloadImplCopyWith<
          _$MultiReleaseReleaseFundsPayloadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
