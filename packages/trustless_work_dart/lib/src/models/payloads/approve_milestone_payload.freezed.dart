// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approve_milestone_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApproveMilestonePayload _$ApproveMilestonePayloadFromJson(
    Map<String, dynamic> json) {
  return _ApproveMilestonePayload.fromJson(json);
}

/// @nodoc
mixin _$ApproveMilestonePayload {
  String get contractId => throw _privateConstructorUsedError;
  String get milestoneIndex => throw _privateConstructorUsedError;
  String get approver => throw _privateConstructorUsedError;

  /// Serializes this ApproveMilestonePayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApproveMilestonePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApproveMilestonePayloadCopyWith<ApproveMilestonePayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApproveMilestonePayloadCopyWith<$Res> {
  factory $ApproveMilestonePayloadCopyWith(ApproveMilestonePayload value,
          $Res Function(ApproveMilestonePayload) then) =
      _$ApproveMilestonePayloadCopyWithImpl<$Res, ApproveMilestonePayload>;
  @useResult
  $Res call({String contractId, String milestoneIndex, String approver});
}

/// @nodoc
class _$ApproveMilestonePayloadCopyWithImpl<$Res,
        $Val extends ApproveMilestonePayload>
    implements $ApproveMilestonePayloadCopyWith<$Res> {
  _$ApproveMilestonePayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApproveMilestonePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? milestoneIndex = null,
    Object? approver = null,
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
      approver: null == approver
          ? _value.approver
          : approver // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApproveMilestonePayloadImplCopyWith<$Res>
    implements $ApproveMilestonePayloadCopyWith<$Res> {
  factory _$$ApproveMilestonePayloadImplCopyWith(
          _$ApproveMilestonePayloadImpl value,
          $Res Function(_$ApproveMilestonePayloadImpl) then) =
      __$$ApproveMilestonePayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String contractId, String milestoneIndex, String approver});
}

/// @nodoc
class __$$ApproveMilestonePayloadImplCopyWithImpl<$Res>
    extends _$ApproveMilestonePayloadCopyWithImpl<$Res,
        _$ApproveMilestonePayloadImpl>
    implements _$$ApproveMilestonePayloadImplCopyWith<$Res> {
  __$$ApproveMilestonePayloadImplCopyWithImpl(
      _$ApproveMilestonePayloadImpl _value,
      $Res Function(_$ApproveMilestonePayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApproveMilestonePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? milestoneIndex = null,
    Object? approver = null,
  }) {
    return _then(_$ApproveMilestonePayloadImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneIndex: null == milestoneIndex
          ? _value.milestoneIndex
          : milestoneIndex // ignore: cast_nullable_to_non_nullable
              as String,
      approver: null == approver
          ? _value.approver
          : approver // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApproveMilestonePayloadImpl implements _ApproveMilestonePayload {
  const _$ApproveMilestonePayloadImpl(
      {required this.contractId,
      required this.milestoneIndex,
      required this.approver});

  factory _$ApproveMilestonePayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApproveMilestonePayloadImplFromJson(json);

  @override
  final String contractId;
  @override
  final String milestoneIndex;
  @override
  final String approver;

  @override
  String toString() {
    return 'ApproveMilestonePayload(contractId: $contractId, milestoneIndex: $milestoneIndex, approver: $approver)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApproveMilestonePayloadImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.milestoneIndex, milestoneIndex) ||
                other.milestoneIndex == milestoneIndex) &&
            (identical(other.approver, approver) ||
                other.approver == approver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, contractId, milestoneIndex, approver);

  /// Create a copy of ApproveMilestonePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApproveMilestonePayloadImplCopyWith<_$ApproveMilestonePayloadImpl>
      get copyWith => __$$ApproveMilestonePayloadImplCopyWithImpl<
          _$ApproveMilestonePayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApproveMilestonePayloadImplToJson(
      this,
    );
  }
}

abstract class _ApproveMilestonePayload implements ApproveMilestonePayload {
  const factory _ApproveMilestonePayload(
      {required final String contractId,
      required final String milestoneIndex,
      required final String approver}) = _$ApproveMilestonePayloadImpl;

  factory _ApproveMilestonePayload.fromJson(Map<String, dynamic> json) =
      _$ApproveMilestonePayloadImpl.fromJson;

  @override
  String get contractId;
  @override
  String get milestoneIndex;
  @override
  String get approver;

  /// Create a copy of ApproveMilestonePayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApproveMilestonePayloadImplCopyWith<_$ApproveMilestonePayloadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
