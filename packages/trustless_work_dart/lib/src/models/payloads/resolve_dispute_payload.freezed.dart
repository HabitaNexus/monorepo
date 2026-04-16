// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolve_dispute_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DisputeDistribution _$DisputeDistributionFromJson(Map<String, dynamic> json) {
  return _DisputeDistribution.fromJson(json);
}

/// @nodoc
mixin _$DisputeDistribution {
  String get address => throw _privateConstructorUsedError;
  num get amount => throw _privateConstructorUsedError;

  /// Serializes this DisputeDistribution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DisputeDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DisputeDistributionCopyWith<DisputeDistribution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DisputeDistributionCopyWith<$Res> {
  factory $DisputeDistributionCopyWith(
          DisputeDistribution value, $Res Function(DisputeDistribution) then) =
      _$DisputeDistributionCopyWithImpl<$Res, DisputeDistribution>;
  @useResult
  $Res call({String address, num amount});
}

/// @nodoc
class _$DisputeDistributionCopyWithImpl<$Res, $Val extends DisputeDistribution>
    implements $DisputeDistributionCopyWith<$Res> {
  _$DisputeDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DisputeDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DisputeDistributionImplCopyWith<$Res>
    implements $DisputeDistributionCopyWith<$Res> {
  factory _$$DisputeDistributionImplCopyWith(_$DisputeDistributionImpl value,
          $Res Function(_$DisputeDistributionImpl) then) =
      __$$DisputeDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String address, num amount});
}

/// @nodoc
class __$$DisputeDistributionImplCopyWithImpl<$Res>
    extends _$DisputeDistributionCopyWithImpl<$Res, _$DisputeDistributionImpl>
    implements _$$DisputeDistributionImplCopyWith<$Res> {
  __$$DisputeDistributionImplCopyWithImpl(_$DisputeDistributionImpl _value,
      $Res Function(_$DisputeDistributionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DisputeDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? amount = null,
  }) {
    return _then(_$DisputeDistributionImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DisputeDistributionImpl implements _DisputeDistribution {
  const _$DisputeDistributionImpl(
      {required this.address, required this.amount});

  factory _$DisputeDistributionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DisputeDistributionImplFromJson(json);

  @override
  final String address;
  @override
  final num amount;

  @override
  String toString() {
    return 'DisputeDistribution(address: $address, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DisputeDistributionImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, address, amount);

  /// Create a copy of DisputeDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DisputeDistributionImplCopyWith<_$DisputeDistributionImpl> get copyWith =>
      __$$DisputeDistributionImplCopyWithImpl<_$DisputeDistributionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DisputeDistributionImplToJson(
      this,
    );
  }
}

abstract class _DisputeDistribution implements DisputeDistribution {
  const factory _DisputeDistribution(
      {required final String address,
      required final num amount}) = _$DisputeDistributionImpl;

  factory _DisputeDistribution.fromJson(Map<String, dynamic> json) =
      _$DisputeDistributionImpl.fromJson;

  @override
  String get address;
  @override
  num get amount;

  /// Create a copy of DisputeDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DisputeDistributionImplCopyWith<_$DisputeDistributionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResolveDisputePayload _$ResolveDisputePayloadFromJson(
    Map<String, dynamic> json) {
  return _ResolveDisputePayload.fromJson(json);
}

/// @nodoc
mixin _$ResolveDisputePayload {
  String get contractId => throw _privateConstructorUsedError;
  String get disputeResolver => throw _privateConstructorUsedError;
  List<DisputeDistribution> get distributions =>
      throw _privateConstructorUsedError;

  /// Serializes this ResolveDisputePayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResolveDisputePayloadCopyWith<ResolveDisputePayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResolveDisputePayloadCopyWith<$Res> {
  factory $ResolveDisputePayloadCopyWith(ResolveDisputePayload value,
          $Res Function(ResolveDisputePayload) then) =
      _$ResolveDisputePayloadCopyWithImpl<$Res, ResolveDisputePayload>;
  @useResult
  $Res call(
      {String contractId,
      String disputeResolver,
      List<DisputeDistribution> distributions});
}

/// @nodoc
class _$ResolveDisputePayloadCopyWithImpl<$Res,
        $Val extends ResolveDisputePayload>
    implements $ResolveDisputePayloadCopyWith<$Res> {
  _$ResolveDisputePayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? disputeResolver = null,
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
      distributions: null == distributions
          ? _value.distributions
          : distributions // ignore: cast_nullable_to_non_nullable
              as List<DisputeDistribution>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResolveDisputePayloadImplCopyWith<$Res>
    implements $ResolveDisputePayloadCopyWith<$Res> {
  factory _$$ResolveDisputePayloadImplCopyWith(
          _$ResolveDisputePayloadImpl value,
          $Res Function(_$ResolveDisputePayloadImpl) then) =
      __$$ResolveDisputePayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contractId,
      String disputeResolver,
      List<DisputeDistribution> distributions});
}

/// @nodoc
class __$$ResolveDisputePayloadImplCopyWithImpl<$Res>
    extends _$ResolveDisputePayloadCopyWithImpl<$Res,
        _$ResolveDisputePayloadImpl>
    implements _$$ResolveDisputePayloadImplCopyWith<$Res> {
  __$$ResolveDisputePayloadImplCopyWithImpl(_$ResolveDisputePayloadImpl _value,
      $Res Function(_$ResolveDisputePayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? disputeResolver = null,
    Object? distributions = null,
  }) {
    return _then(_$ResolveDisputePayloadImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      disputeResolver: null == disputeResolver
          ? _value.disputeResolver
          : disputeResolver // ignore: cast_nullable_to_non_nullable
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
class _$ResolveDisputePayloadImpl implements _ResolveDisputePayload {
  const _$ResolveDisputePayloadImpl(
      {required this.contractId,
      required this.disputeResolver,
      required final List<DisputeDistribution> distributions})
      : _distributions = distributions;

  factory _$ResolveDisputePayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResolveDisputePayloadImplFromJson(json);

  @override
  final String contractId;
  @override
  final String disputeResolver;
  final List<DisputeDistribution> _distributions;
  @override
  List<DisputeDistribution> get distributions {
    if (_distributions is EqualUnmodifiableListView) return _distributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_distributions);
  }

  @override
  String toString() {
    return 'ResolveDisputePayload(contractId: $contractId, disputeResolver: $disputeResolver, distributions: $distributions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResolveDisputePayloadImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.disputeResolver, disputeResolver) ||
                other.disputeResolver == disputeResolver) &&
            const DeepCollectionEquality()
                .equals(other._distributions, _distributions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contractId, disputeResolver,
      const DeepCollectionEquality().hash(_distributions));

  /// Create a copy of ResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResolveDisputePayloadImplCopyWith<_$ResolveDisputePayloadImpl>
      get copyWith => __$$ResolveDisputePayloadImplCopyWithImpl<
          _$ResolveDisputePayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResolveDisputePayloadImplToJson(
      this,
    );
  }
}

abstract class _ResolveDisputePayload implements ResolveDisputePayload {
  const factory _ResolveDisputePayload(
          {required final String contractId,
          required final String disputeResolver,
          required final List<DisputeDistribution> distributions}) =
      _$ResolveDisputePayloadImpl;

  factory _ResolveDisputePayload.fromJson(Map<String, dynamic> json) =
      _$ResolveDisputePayloadImpl.fromJson;

  @override
  String get contractId;
  @override
  String get disputeResolver;
  @override
  List<DisputeDistribution> get distributions;

  /// Create a copy of ResolveDisputePayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResolveDisputePayloadImplCopyWith<_$ResolveDisputePayloadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
