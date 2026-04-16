// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_milestone_status_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChangeMilestoneStatusPayload _$ChangeMilestoneStatusPayloadFromJson(
    Map<String, dynamic> json) {
  return _ChangeMilestoneStatusPayload.fromJson(json);
}

/// @nodoc
mixin _$ChangeMilestoneStatusPayload {
  String get contractId => throw _privateConstructorUsedError;
  String get milestoneIndex => throw _privateConstructorUsedError;
  String get newEvidence => throw _privateConstructorUsedError;
  String get newStatus => throw _privateConstructorUsedError;
  String get serviceProvider => throw _privateConstructorUsedError;

  /// Serializes this ChangeMilestoneStatusPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangeMilestoneStatusPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangeMilestoneStatusPayloadCopyWith<ChangeMilestoneStatusPayload>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeMilestoneStatusPayloadCopyWith<$Res> {
  factory $ChangeMilestoneStatusPayloadCopyWith(
          ChangeMilestoneStatusPayload value,
          $Res Function(ChangeMilestoneStatusPayload) then) =
      _$ChangeMilestoneStatusPayloadCopyWithImpl<$Res,
          ChangeMilestoneStatusPayload>;
  @useResult
  $Res call(
      {String contractId,
      String milestoneIndex,
      String newEvidence,
      String newStatus,
      String serviceProvider});
}

/// @nodoc
class _$ChangeMilestoneStatusPayloadCopyWithImpl<$Res,
        $Val extends ChangeMilestoneStatusPayload>
    implements $ChangeMilestoneStatusPayloadCopyWith<$Res> {
  _$ChangeMilestoneStatusPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangeMilestoneStatusPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? milestoneIndex = null,
    Object? newEvidence = null,
    Object? newStatus = null,
    Object? serviceProvider = null,
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
      newEvidence: null == newEvidence
          ? _value.newEvidence
          : newEvidence // ignore: cast_nullable_to_non_nullable
              as String,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      serviceProvider: null == serviceProvider
          ? _value.serviceProvider
          : serviceProvider // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangeMilestoneStatusPayloadImplCopyWith<$Res>
    implements $ChangeMilestoneStatusPayloadCopyWith<$Res> {
  factory _$$ChangeMilestoneStatusPayloadImplCopyWith(
          _$ChangeMilestoneStatusPayloadImpl value,
          $Res Function(_$ChangeMilestoneStatusPayloadImpl) then) =
      __$$ChangeMilestoneStatusPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contractId,
      String milestoneIndex,
      String newEvidence,
      String newStatus,
      String serviceProvider});
}

/// @nodoc
class __$$ChangeMilestoneStatusPayloadImplCopyWithImpl<$Res>
    extends _$ChangeMilestoneStatusPayloadCopyWithImpl<$Res,
        _$ChangeMilestoneStatusPayloadImpl>
    implements _$$ChangeMilestoneStatusPayloadImplCopyWith<$Res> {
  __$$ChangeMilestoneStatusPayloadImplCopyWithImpl(
      _$ChangeMilestoneStatusPayloadImpl _value,
      $Res Function(_$ChangeMilestoneStatusPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChangeMilestoneStatusPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? milestoneIndex = null,
    Object? newEvidence = null,
    Object? newStatus = null,
    Object? serviceProvider = null,
  }) {
    return _then(_$ChangeMilestoneStatusPayloadImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneIndex: null == milestoneIndex
          ? _value.milestoneIndex
          : milestoneIndex // ignore: cast_nullable_to_non_nullable
              as String,
      newEvidence: null == newEvidence
          ? _value.newEvidence
          : newEvidence // ignore: cast_nullable_to_non_nullable
              as String,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      serviceProvider: null == serviceProvider
          ? _value.serviceProvider
          : serviceProvider // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangeMilestoneStatusPayloadImpl
    implements _ChangeMilestoneStatusPayload {
  const _$ChangeMilestoneStatusPayloadImpl(
      {required this.contractId,
      required this.milestoneIndex,
      required this.newEvidence,
      required this.newStatus,
      required this.serviceProvider});

  factory _$ChangeMilestoneStatusPayloadImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ChangeMilestoneStatusPayloadImplFromJson(json);

  @override
  final String contractId;
  @override
  final String milestoneIndex;
  @override
  final String newEvidence;
  @override
  final String newStatus;
  @override
  final String serviceProvider;

  @override
  String toString() {
    return 'ChangeMilestoneStatusPayload(contractId: $contractId, milestoneIndex: $milestoneIndex, newEvidence: $newEvidence, newStatus: $newStatus, serviceProvider: $serviceProvider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeMilestoneStatusPayloadImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.milestoneIndex, milestoneIndex) ||
                other.milestoneIndex == milestoneIndex) &&
            (identical(other.newEvidence, newEvidence) ||
                other.newEvidence == newEvidence) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.serviceProvider, serviceProvider) ||
                other.serviceProvider == serviceProvider));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contractId, milestoneIndex,
      newEvidence, newStatus, serviceProvider);

  /// Create a copy of ChangeMilestoneStatusPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeMilestoneStatusPayloadImplCopyWith<
          _$ChangeMilestoneStatusPayloadImpl>
      get copyWith => __$$ChangeMilestoneStatusPayloadImplCopyWithImpl<
          _$ChangeMilestoneStatusPayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangeMilestoneStatusPayloadImplToJson(
      this,
    );
  }
}

abstract class _ChangeMilestoneStatusPayload
    implements ChangeMilestoneStatusPayload {
  const factory _ChangeMilestoneStatusPayload(
          {required final String contractId,
          required final String milestoneIndex,
          required final String newEvidence,
          required final String newStatus,
          required final String serviceProvider}) =
      _$ChangeMilestoneStatusPayloadImpl;

  factory _ChangeMilestoneStatusPayload.fromJson(Map<String, dynamic> json) =
      _$ChangeMilestoneStatusPayloadImpl.fromJson;

  @override
  String get contractId;
  @override
  String get milestoneIndex;
  @override
  String get newEvidence;
  @override
  String get newStatus;
  @override
  String get serviceProvider;

  /// Create a copy of ChangeMilestoneStatusPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeMilestoneStatusPayloadImplCopyWith<
          _$ChangeMilestoneStatusPayloadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
