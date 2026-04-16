// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund_escrow_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FundEscrowPayload _$FundEscrowPayloadFromJson(Map<String, dynamic> json) {
  return _FundEscrowPayload.fromJson(json);
}

/// @nodoc
mixin _$FundEscrowPayload {
  String get contractId => throw _privateConstructorUsedError;
  String get signer => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;

  /// Serializes this FundEscrowPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FundEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FundEscrowPayloadCopyWith<FundEscrowPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FundEscrowPayloadCopyWith<$Res> {
  factory $FundEscrowPayloadCopyWith(
          FundEscrowPayload value, $Res Function(FundEscrowPayload) then) =
      _$FundEscrowPayloadCopyWithImpl<$Res, FundEscrowPayload>;
  @useResult
  $Res call({String contractId, String signer, String amount});
}

/// @nodoc
class _$FundEscrowPayloadCopyWithImpl<$Res, $Val extends FundEscrowPayload>
    implements $FundEscrowPayloadCopyWith<$Res> {
  _$FundEscrowPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FundEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? signer = null,
    Object? amount = null,
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
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FundEscrowPayloadImplCopyWith<$Res>
    implements $FundEscrowPayloadCopyWith<$Res> {
  factory _$$FundEscrowPayloadImplCopyWith(_$FundEscrowPayloadImpl value,
          $Res Function(_$FundEscrowPayloadImpl) then) =
      __$$FundEscrowPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String contractId, String signer, String amount});
}

/// @nodoc
class __$$FundEscrowPayloadImplCopyWithImpl<$Res>
    extends _$FundEscrowPayloadCopyWithImpl<$Res, _$FundEscrowPayloadImpl>
    implements _$$FundEscrowPayloadImplCopyWith<$Res> {
  __$$FundEscrowPayloadImplCopyWithImpl(_$FundEscrowPayloadImpl _value,
      $Res Function(_$FundEscrowPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of FundEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? signer = null,
    Object? amount = null,
  }) {
    return _then(_$FundEscrowPayloadImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      signer: null == signer
          ? _value.signer
          : signer // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FundEscrowPayloadImpl implements _FundEscrowPayload {
  const _$FundEscrowPayloadImpl(
      {required this.contractId, required this.signer, required this.amount});

  factory _$FundEscrowPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$FundEscrowPayloadImplFromJson(json);

  @override
  final String contractId;
  @override
  final String signer;
  @override
  final String amount;

  @override
  String toString() {
    return 'FundEscrowPayload(contractId: $contractId, signer: $signer, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FundEscrowPayloadImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.signer, signer) || other.signer == signer) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contractId, signer, amount);

  /// Create a copy of FundEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FundEscrowPayloadImplCopyWith<_$FundEscrowPayloadImpl> get copyWith =>
      __$$FundEscrowPayloadImplCopyWithImpl<_$FundEscrowPayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FundEscrowPayloadImplToJson(
      this,
    );
  }
}

abstract class _FundEscrowPayload implements FundEscrowPayload {
  const factory _FundEscrowPayload(
      {required final String contractId,
      required final String signer,
      required final String amount}) = _$FundEscrowPayloadImpl;

  factory _FundEscrowPayload.fromJson(Map<String, dynamic> json) =
      _$FundEscrowPayloadImpl.fromJson;

  @override
  String get contractId;
  @override
  String get signer;
  @override
  String get amount;

  /// Create a copy of FundEscrowPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FundEscrowPayloadImplCopyWith<_$FundEscrowPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
