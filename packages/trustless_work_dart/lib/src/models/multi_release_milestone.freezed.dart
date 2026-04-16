// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_release_milestone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MultiReleaseMilestone _$MultiReleaseMilestoneFromJson(
    Map<String, dynamic> json) {
  return _MultiReleaseMilestone.fromJson(json);
}

/// @nodoc
mixin _$MultiReleaseMilestone {
  String get description => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get approvedFlag => throw _privateConstructorUsedError;
  String? get evidence => throw _privateConstructorUsedError;
  Role? get disputeStartedBy => throw _privateConstructorUsedError;

  /// Serializes this MultiReleaseMilestone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MultiReleaseMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultiReleaseMilestoneCopyWith<MultiReleaseMilestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultiReleaseMilestoneCopyWith<$Res> {
  factory $MultiReleaseMilestoneCopyWith(MultiReleaseMilestone value,
          $Res Function(MultiReleaseMilestone) then) =
      _$MultiReleaseMilestoneCopyWithImpl<$Res, MultiReleaseMilestone>;
  @useResult
  $Res call(
      {String description,
      int amount,
      String status,
      bool approvedFlag,
      String? evidence,
      Role? disputeStartedBy});

  $RoleCopyWith<$Res>? get disputeStartedBy;
}

/// @nodoc
class _$MultiReleaseMilestoneCopyWithImpl<$Res,
        $Val extends MultiReleaseMilestone>
    implements $MultiReleaseMilestoneCopyWith<$Res> {
  _$MultiReleaseMilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultiReleaseMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? amount = null,
    Object? status = null,
    Object? approvedFlag = null,
    Object? evidence = freezed,
    Object? disputeStartedBy = freezed,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      approvedFlag: null == approvedFlag
          ? _value.approvedFlag
          : approvedFlag // ignore: cast_nullable_to_non_nullable
              as bool,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
      disputeStartedBy: freezed == disputeStartedBy
          ? _value.disputeStartedBy
          : disputeStartedBy // ignore: cast_nullable_to_non_nullable
              as Role?,
    ) as $Val);
  }

  /// Create a copy of MultiReleaseMilestone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoleCopyWith<$Res>? get disputeStartedBy {
    if (_value.disputeStartedBy == null) {
      return null;
    }

    return $RoleCopyWith<$Res>(_value.disputeStartedBy!, (value) {
      return _then(_value.copyWith(disputeStartedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MultiReleaseMilestoneImplCopyWith<$Res>
    implements $MultiReleaseMilestoneCopyWith<$Res> {
  factory _$$MultiReleaseMilestoneImplCopyWith(
          _$MultiReleaseMilestoneImpl value,
          $Res Function(_$MultiReleaseMilestoneImpl) then) =
      __$$MultiReleaseMilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String description,
      int amount,
      String status,
      bool approvedFlag,
      String? evidence,
      Role? disputeStartedBy});

  @override
  $RoleCopyWith<$Res>? get disputeStartedBy;
}

/// @nodoc
class __$$MultiReleaseMilestoneImplCopyWithImpl<$Res>
    extends _$MultiReleaseMilestoneCopyWithImpl<$Res,
        _$MultiReleaseMilestoneImpl>
    implements _$$MultiReleaseMilestoneImplCopyWith<$Res> {
  __$$MultiReleaseMilestoneImplCopyWithImpl(_$MultiReleaseMilestoneImpl _value,
      $Res Function(_$MultiReleaseMilestoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of MultiReleaseMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? amount = null,
    Object? status = null,
    Object? approvedFlag = null,
    Object? evidence = freezed,
    Object? disputeStartedBy = freezed,
  }) {
    return _then(_$MultiReleaseMilestoneImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      approvedFlag: null == approvedFlag
          ? _value.approvedFlag
          : approvedFlag // ignore: cast_nullable_to_non_nullable
              as bool,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
      disputeStartedBy: freezed == disputeStartedBy
          ? _value.disputeStartedBy
          : disputeStartedBy // ignore: cast_nullable_to_non_nullable
              as Role?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MultiReleaseMilestoneImpl implements _MultiReleaseMilestone {
  const _$MultiReleaseMilestoneImpl(
      {required this.description,
      required this.amount,
      this.status = 'pending',
      this.approvedFlag = false,
      this.evidence,
      this.disputeStartedBy});

  factory _$MultiReleaseMilestoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$MultiReleaseMilestoneImplFromJson(json);

  @override
  final String description;
  @override
  final int amount;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool approvedFlag;
  @override
  final String? evidence;
  @override
  final Role? disputeStartedBy;

  @override
  String toString() {
    return 'MultiReleaseMilestone(description: $description, amount: $amount, status: $status, approvedFlag: $approvedFlag, evidence: $evidence, disputeStartedBy: $disputeStartedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultiReleaseMilestoneImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.approvedFlag, approvedFlag) ||
                other.approvedFlag == approvedFlag) &&
            (identical(other.evidence, evidence) ||
                other.evidence == evidence) &&
            (identical(other.disputeStartedBy, disputeStartedBy) ||
                other.disputeStartedBy == disputeStartedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, description, amount, status,
      approvedFlag, evidence, disputeStartedBy);

  /// Create a copy of MultiReleaseMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultiReleaseMilestoneImplCopyWith<_$MultiReleaseMilestoneImpl>
      get copyWith => __$$MultiReleaseMilestoneImplCopyWithImpl<
          _$MultiReleaseMilestoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MultiReleaseMilestoneImplToJson(
      this,
    );
  }
}

abstract class _MultiReleaseMilestone implements MultiReleaseMilestone {
  const factory _MultiReleaseMilestone(
      {required final String description,
      required final int amount,
      final String status,
      final bool approvedFlag,
      final String? evidence,
      final Role? disputeStartedBy}) = _$MultiReleaseMilestoneImpl;

  factory _MultiReleaseMilestone.fromJson(Map<String, dynamic> json) =
      _$MultiReleaseMilestoneImpl.fromJson;

  @override
  String get description;
  @override
  int get amount;
  @override
  String get status;
  @override
  bool get approvedFlag;
  @override
  String? get evidence;
  @override
  Role? get disputeStartedBy;

  /// Create a copy of MultiReleaseMilestone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultiReleaseMilestoneImplCopyWith<_$MultiReleaseMilestoneImpl>
      get copyWith => throw _privateConstructorUsedError;
}
