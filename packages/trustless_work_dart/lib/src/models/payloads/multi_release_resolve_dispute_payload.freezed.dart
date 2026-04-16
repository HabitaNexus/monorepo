// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_release_resolve_dispute_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MultiReleaseResolveDisputePayload _$MultiReleaseResolveDisputePayloadFromJson(
    Map<String, dynamic> json) {
  return _MultiReleaseResolveDisputePayload.fromJson(json);
}

/// @nodoc
mixin _$MultiReleaseResolveDisputePayload {
  String get contractId => throw _privateConstructorUsedError;
  String get disputeResolver => throw _privateConstructorUsedError;
  String get milestoneIndex => throw _privateConstructorUsedError;
  List<DisputeDistribution> get distributions =>
      throw _privateConstructorUsedError;

  /// Serializes this MultiReleaseResolveDisputePayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MultiReleaseResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultiReleaseResolveDisputePayloadCopyWith<MultiReleaseResolveDisputePayload>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultiReleaseResolveDisputePayloadCopyWith<$Res> {
  factory $MultiReleaseResolveDisputePayloadCopyWith(
          MultiReleaseResolveDisputePayload value,
          $Res Function(MultiReleaseResolveDisputePayload) then) =
      _$MultiReleaseResolveDisputePayloadCopyWithImpl<$Res,
          MultiReleaseResolveDisputePayload>;
  @useResult
  $Res call(
      {String contractId,
      String disputeResolver,
      String milestoneIndex,
      List<DisputeDistribution> distributions});
}

/// @nodoc
class _$MultiReleaseResolveDisputePayloadCopyWithImpl<$Res,
        $Val extends MultiReleaseResolveDisputePayload>
    implements $MultiReleaseResolveDisputePayloadCopyWith<$Res> {
  _$MultiReleaseResolveDisputePayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultiReleaseResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? disputeResolver = null,
    Object? milestoneIndex = null,
    Object? distributions = null,
  }) {
    return _then(_value.copyWith(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      disputeResolver: null == disputeResolver
          ? _value.disputeResolver
          : disputeResolver // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneIndex: null == milestoneIndex
          ? _value.milestoneIndex
          : milestoneIndex // ignore: cast_nullable_to_non_nullable
              as String,
      distributions: null == distributions
          ? _value.distributions
          : distributions // ignore: cast_nullable_to_non_nullable
              as List<DisputeDistribution>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MultiReleaseResolveDisputePayloadImplCopyWith<$Res>
    implements $MultiReleaseResolveDisputePayloadCopyWith<$Res> {
  factory _$$MultiReleaseResolveDisputePayloadImplCopyWith(
          _$MultiReleaseResolveDisputePayloadImpl value,
          $Res Function(_$MultiReleaseResolveDisputePayloadImpl) then) =
      __$$MultiReleaseResolveDisputePayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contractId,
      String disputeResolver,
      String milestoneIndex,
      List<DisputeDistribution> distributions});
}

/// @nodoc
class __$$MultiReleaseResolveDisputePayloadImplCopyWithImpl<$Res>
    extends _$MultiReleaseResolveDisputePayloadCopyWithImpl<$Res,
        _$MultiReleaseResolveDisputePayloadImpl>
    implements _$$MultiReleaseResolveDisputePayloadImplCopyWith<$Res> {
  __$$MultiReleaseResolveDisputePayloadImplCopyWithImpl(
      _$MultiReleaseResolveDisputePayloadImpl _value,
      $Res Function(_$MultiReleaseResolveDisputePayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of MultiReleaseResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? disputeResolver = null,
    Object? milestoneIndex = null,
    Object? distributions = null,
  }) {
    return _then(_$MultiReleaseResolveDisputePayloadImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      disputeResolver: null == disputeResolver
          ? _value.disputeResolver
          : disputeResolver // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneIndex: null == milestoneIndex
          ? _value.milestoneIndex
          : milestoneIndex // ignore: cast_nullable_to_non_nullable
              as String,
      distributions: null == distributions
          ? _value._distributions
          : distributions // ignore: cast_nullable_to_non_nullable
              as List<DisputeDistribution>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MultiReleaseResolveDisputePayloadImpl
    implements _MultiReleaseResolveDisputePayload {
  const _$MultiReleaseResolveDisputePayloadImpl(
      {required this.contractId,
      required this.disputeResolver,
      required this.milestoneIndex,
      required final List<DisputeDistribution> distributions})
      : _distributions = distributions;

  factory _$MultiReleaseResolveDisputePayloadImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MultiReleaseResolveDisputePayloadImplFromJson(json);

  @override
  final String contractId;
  @override
  final String disputeResolver;
  @override
  final String milestoneIndex;
  final List<DisputeDistribution> _distributions;
  @override
  List<DisputeDistribution> get distributions {
    if (_distributions is EqualUnmodifiableListView) return _distributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_distributions);
  }

  @override
  String toString() {
    return 'MultiReleaseResolveDisputePayload(contractId: $contractId, disputeResolver: $disputeResolver, milestoneIndex: $milestoneIndex, distributions: $distributions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultiReleaseResolveDisputePayloadImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.disputeResolver, disputeResolver) ||
                other.disputeResolver == disputeResolver) &&
            (identical(other.milestoneIndex, milestoneIndex) ||
                other.milestoneIndex == milestoneIndex) &&
            const DeepCollectionEquality()
                .equals(other._distributions, _distributions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contractId, disputeResolver,
      milestoneIndex, const DeepCollectionEquality().hash(_distributions));

  /// Create a copy of MultiReleaseResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultiReleaseResolveDisputePayloadImplCopyWith<
          _$MultiReleaseResolveDisputePayloadImpl>
      get copyWith => __$$MultiReleaseResolveDisputePayloadImplCopyWithImpl<
          _$MultiReleaseResolveDisputePayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MultiReleaseResolveDisputePayloadImplToJson(
      this,
    );
  }
}

abstract class _MultiReleaseResolveDisputePayload
    implements MultiReleaseResolveDisputePayload {
  const factory _MultiReleaseResolveDisputePayload(
          {required final String contractId,
          required final String disputeResolver,
          required final String milestoneIndex,
          required final List<DisputeDistribution> distributions}) =
      _$MultiReleaseResolveDisputePayloadImpl;

  factory _MultiReleaseResolveDisputePayload.fromJson(
          Map<String, dynamic> json) =
      _$MultiReleaseResolveDisputePayloadImpl.fromJson;

  @override
  String get contractId;
  @override
  String get disputeResolver;
  @override
  String get milestoneIndex;
  @override
  List<DisputeDistribution> get distributions;

  /// Create a copy of MultiReleaseResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultiReleaseResolveDisputePayloadImplCopyWith<
          _$MultiReleaseResolveDisputePayloadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
