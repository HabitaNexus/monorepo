// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_escrow_balances_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetEscrowBalancesResponse _$GetEscrowBalancesResponseFromJson(
    Map<String, dynamic> json) {
  return _GetEscrowBalancesResponse.fromJson(json);
}

/// @nodoc
mixin _$GetEscrowBalancesResponse {
  List<EscrowBalanceEntry> get balances => throw _privateConstructorUsedError;

  /// Serializes this GetEscrowBalancesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetEscrowBalancesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetEscrowBalancesResponseCopyWith<GetEscrowBalancesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetEscrowBalancesResponseCopyWith<$Res> {
  factory $GetEscrowBalancesResponseCopyWith(GetEscrowBalancesResponse value,
          $Res Function(GetEscrowBalancesResponse) then) =
      _$GetEscrowBalancesResponseCopyWithImpl<$Res, GetEscrowBalancesResponse>;
  @useResult
  $Res call({List<EscrowBalanceEntry> balances});
}

/// @nodoc
class _$GetEscrowBalancesResponseCopyWithImpl<$Res,
        $Val extends GetEscrowBalancesResponse>
    implements $GetEscrowBalancesResponseCopyWith<$Res> {
  _$GetEscrowBalancesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetEscrowBalancesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balances = null,
  }) {
    return _then(_value.copyWith(
      balances: null == balances
          ? _value.balances
          : balances // ignore: cast_nullable_to_non_nullable
              as List<EscrowBalanceEntry>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetEscrowBalancesResponseImplCopyWith<$Res>
    implements $GetEscrowBalancesResponseCopyWith<$Res> {
  factory _$$GetEscrowBalancesResponseImplCopyWith(
          _$GetEscrowBalancesResponseImpl value,
          $Res Function(_$GetEscrowBalancesResponseImpl) then) =
      __$$GetEscrowBalancesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<EscrowBalanceEntry> balances});
}

/// @nodoc
class __$$GetEscrowBalancesResponseImplCopyWithImpl<$Res>
    extends _$GetEscrowBalancesResponseCopyWithImpl<$Res,
        _$GetEscrowBalancesResponseImpl>
    implements _$$GetEscrowBalancesResponseImplCopyWith<$Res> {
  __$$GetEscrowBalancesResponseImplCopyWithImpl(
      _$GetEscrowBalancesResponseImpl _value,
      $Res Function(_$GetEscrowBalancesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetEscrowBalancesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balances = null,
  }) {
    return _then(_$GetEscrowBalancesResponseImpl(
      balances: null == balances
          ? _value._balances
          : balances // ignore: cast_nullable_to_non_nullable
              as List<EscrowBalanceEntry>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetEscrowBalancesResponseImpl implements _GetEscrowBalancesResponse {
  const _$GetEscrowBalancesResponseImpl(
      {required final List<EscrowBalanceEntry> balances})
      : _balances = balances;

  factory _$GetEscrowBalancesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetEscrowBalancesResponseImplFromJson(json);

  final List<EscrowBalanceEntry> _balances;
  @override
  List<EscrowBalanceEntry> get balances {
    if (_balances is EqualUnmodifiableListView) return _balances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_balances);
  }

  @override
  String toString() {
    return 'GetEscrowBalancesResponse(balances: $balances)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetEscrowBalancesResponseImpl &&
            const DeepCollectionEquality().equals(other._balances, _balances));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_balances));

  /// Create a copy of GetEscrowBalancesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetEscrowBalancesResponseImplCopyWith<_$GetEscrowBalancesResponseImpl>
      get copyWith => __$$GetEscrowBalancesResponseImplCopyWithImpl<
          _$GetEscrowBalancesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetEscrowBalancesResponseImplToJson(
      this,
    );
  }
}

abstract class _GetEscrowBalancesResponse implements GetEscrowBalancesResponse {
  const factory _GetEscrowBalancesResponse(
          {required final List<EscrowBalanceEntry> balances}) =
      _$GetEscrowBalancesResponseImpl;

  factory _GetEscrowBalancesResponse.fromJson(Map<String, dynamic> json) =
      _$GetEscrowBalancesResponseImpl.fromJson;

  @override
  List<EscrowBalanceEntry> get balances;

  /// Create a copy of GetEscrowBalancesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetEscrowBalancesResponseImplCopyWith<_$GetEscrowBalancesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EscrowBalanceEntry _$EscrowBalanceEntryFromJson(Map<String, dynamic> json) {
  return _EscrowBalanceEntry.fromJson(json);
}

/// @nodoc
mixin _$EscrowBalanceEntry {
  String get address => throw _privateConstructorUsedError;
  num get balance => throw _privateConstructorUsedError;

  /// Serializes this EscrowBalanceEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EscrowBalanceEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EscrowBalanceEntryCopyWith<EscrowBalanceEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EscrowBalanceEntryCopyWith<$Res> {
  factory $EscrowBalanceEntryCopyWith(
          EscrowBalanceEntry value, $Res Function(EscrowBalanceEntry) then) =
      _$EscrowBalanceEntryCopyWithImpl<$Res, EscrowBalanceEntry>;
  @useResult
  $Res call({String address, num balance});
}

/// @nodoc
class _$EscrowBalanceEntryCopyWithImpl<$Res, $Val extends EscrowBalanceEntry>
    implements $EscrowBalanceEntryCopyWith<$Res> {
  _$EscrowBalanceEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EscrowBalanceEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EscrowBalanceEntryImplCopyWith<$Res>
    implements $EscrowBalanceEntryCopyWith<$Res> {
  factory _$$EscrowBalanceEntryImplCopyWith(_$EscrowBalanceEntryImpl value,
          $Res Function(_$EscrowBalanceEntryImpl) then) =
      __$$EscrowBalanceEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String address, num balance});
}

/// @nodoc
class __$$EscrowBalanceEntryImplCopyWithImpl<$Res>
    extends _$EscrowBalanceEntryCopyWithImpl<$Res, _$EscrowBalanceEntryImpl>
    implements _$$EscrowBalanceEntryImplCopyWith<$Res> {
  __$$EscrowBalanceEntryImplCopyWithImpl(_$EscrowBalanceEntryImpl _value,
      $Res Function(_$EscrowBalanceEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of EscrowBalanceEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? balance = null,
  }) {
    return _then(_$EscrowBalanceEntryImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EscrowBalanceEntryImpl implements _EscrowBalanceEntry {
  const _$EscrowBalanceEntryImpl(
      {required this.address, required this.balance});

  factory _$EscrowBalanceEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EscrowBalanceEntryImplFromJson(json);

  @override
  final String address;
  @override
  final num balance;

  @override
  String toString() {
    return 'EscrowBalanceEntry(address: $address, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EscrowBalanceEntryImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, address, balance);

  /// Create a copy of EscrowBalanceEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EscrowBalanceEntryImplCopyWith<_$EscrowBalanceEntryImpl> get copyWith =>
      __$$EscrowBalanceEntryImplCopyWithImpl<_$EscrowBalanceEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EscrowBalanceEntryImplToJson(
      this,
    );
  }
}

abstract class _EscrowBalanceEntry implements EscrowBalanceEntry {
  const factory _EscrowBalanceEntry(
      {required final String address,
      required final num balance}) = _$EscrowBalanceEntryImpl;

  factory _EscrowBalanceEntry.fromJson(Map<String, dynamic> json) =
      _$EscrowBalanceEntryImpl.fromJson;

  @override
  String get address;
  @override
  num get balance;

  /// Create a copy of EscrowBalanceEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EscrowBalanceEntryImplCopyWith<_$EscrowBalanceEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
