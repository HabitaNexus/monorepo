// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_escrows_from_indexer_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetEscrowsFromIndexerResponse _$GetEscrowsFromIndexerResponseFromJson(
    Map<String, dynamic> json) {
  return _GetEscrowsFromIndexerResponse.fromJson(json);
}

/// @nodoc
mixin _$GetEscrowsFromIndexerResponse {
  List<IndexerEscrow> get escrows => throw _privateConstructorUsedError;

  /// Serializes this GetEscrowsFromIndexerResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetEscrowsFromIndexerResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetEscrowsFromIndexerResponseCopyWith<GetEscrowsFromIndexerResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetEscrowsFromIndexerResponseCopyWith<$Res> {
  factory $GetEscrowsFromIndexerResponseCopyWith(
          GetEscrowsFromIndexerResponse value,
          $Res Function(GetEscrowsFromIndexerResponse) then) =
      _$GetEscrowsFromIndexerResponseCopyWithImpl<$Res,
          GetEscrowsFromIndexerResponse>;
  @useResult
  $Res call({List<IndexerEscrow> escrows});
}

/// @nodoc
class _$GetEscrowsFromIndexerResponseCopyWithImpl<$Res,
        $Val extends GetEscrowsFromIndexerResponse>
    implements $GetEscrowsFromIndexerResponseCopyWith<$Res> {
  _$GetEscrowsFromIndexerResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetEscrowsFromIndexerResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? escrows = null,
  }) {
    return _then(_value.copyWith(
      escrows: null == escrows
          ? _value.escrows
          : escrows // ignore: cast_nullable_to_non_nullable
              as List<IndexerEscrow>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetEscrowsFromIndexerResponseImplCopyWith<$Res>
    implements $GetEscrowsFromIndexerResponseCopyWith<$Res> {
  factory _$$GetEscrowsFromIndexerResponseImplCopyWith(
          _$GetEscrowsFromIndexerResponseImpl value,
          $Res Function(_$GetEscrowsFromIndexerResponseImpl) then) =
      __$$GetEscrowsFromIndexerResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<IndexerEscrow> escrows});
}

/// @nodoc
class __$$GetEscrowsFromIndexerResponseImplCopyWithImpl<$Res>
    extends _$GetEscrowsFromIndexerResponseCopyWithImpl<$Res,
        _$GetEscrowsFromIndexerResponseImpl>
    implements _$$GetEscrowsFromIndexerResponseImplCopyWith<$Res> {
  __$$GetEscrowsFromIndexerResponseImplCopyWithImpl(
      _$GetEscrowsFromIndexerResponseImpl _value,
      $Res Function(_$GetEscrowsFromIndexerResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetEscrowsFromIndexerResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? escrows = null,
  }) {
    return _then(_$GetEscrowsFromIndexerResponseImpl(
      escrows: null == escrows
          ? _value._escrows
          : escrows // ignore: cast_nullable_to_non_nullable
              as List<IndexerEscrow>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetEscrowsFromIndexerResponseImpl
    implements _GetEscrowsFromIndexerResponse {
  const _$GetEscrowsFromIndexerResponseImpl(
      {required final List<IndexerEscrow> escrows})
      : _escrows = escrows;

  factory _$GetEscrowsFromIndexerResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GetEscrowsFromIndexerResponseImplFromJson(json);

  final List<IndexerEscrow> _escrows;
  @override
  List<IndexerEscrow> get escrows {
    if (_escrows is EqualUnmodifiableListView) return _escrows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_escrows);
  }

  @override
  String toString() {
    return 'GetEscrowsFromIndexerResponse(escrows: $escrows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetEscrowsFromIndexerResponseImpl &&
            const DeepCollectionEquality().equals(other._escrows, _escrows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_escrows));

  /// Create a copy of GetEscrowsFromIndexerResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetEscrowsFromIndexerResponseImplCopyWith<
          _$GetEscrowsFromIndexerResponseImpl>
      get copyWith => __$$GetEscrowsFromIndexerResponseImplCopyWithImpl<
          _$GetEscrowsFromIndexerResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetEscrowsFromIndexerResponseImplToJson(
      this,
    );
  }
}

abstract class _GetEscrowsFromIndexerResponse
    implements GetEscrowsFromIndexerResponse {
  const factory _GetEscrowsFromIndexerResponse(
          {required final List<IndexerEscrow> escrows}) =
      _$GetEscrowsFromIndexerResponseImpl;

  factory _GetEscrowsFromIndexerResponse.fromJson(Map<String, dynamic> json) =
      _$GetEscrowsFromIndexerResponseImpl.fromJson;

  @override
  List<IndexerEscrow> get escrows;

  /// Create a copy of GetEscrowsFromIndexerResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetEscrowsFromIndexerResponseImplCopyWith<
          _$GetEscrowsFromIndexerResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

IndexerEscrow _$IndexerEscrowFromJson(Map<String, dynamic> json) {
  return _IndexerEscrow.fromJson(json);
}

/// @nodoc
mixin _$IndexerEscrow {
  String get contractId => throw _privateConstructorUsedError;
  String get engagementId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get platformFee => throw _privateConstructorUsedError;
  int get receiverMemo => throw _privateConstructorUsedError;
  IndexerEscrowRoles get roles => throw _privateConstructorUsedError;
  List<IndexerMilestone> get milestones => throw _privateConstructorUsedError;
  IndexerTrustline get trustline => throw _privateConstructorUsedError;
  IndexerEscrowFlags get flags => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get signer => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  num? get balance => throw _privateConstructorUsedError;
  IndexerTimestamp? get createdAt => throw _privateConstructorUsedError;
  IndexerTimestamp? get updatedAt =>
      throw _privateConstructorUsedError; // Optional indexer-surfaced metadata called out in HAB-61. These are
// not present in the OpenAPI example but the prompt explicitly lists
// them, so we model them as nullable pass-through fields.
  String? get fundedBy => throw _privateConstructorUsedError;
  num? get approverFunds => throw _privateConstructorUsedError;
  num? get receiverFunds => throw _privateConstructorUsedError;
  String? get user => throw _privateConstructorUsedError;
  String? get disputeStartedBy => throw _privateConstructorUsedError;

  /// Serializes this IndexerEscrow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexerEscrowCopyWith<IndexerEscrow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexerEscrowCopyWith<$Res> {
  factory $IndexerEscrowCopyWith(
          IndexerEscrow value, $Res Function(IndexerEscrow) then) =
      _$IndexerEscrowCopyWithImpl<$Res, IndexerEscrow>;
  @useResult
  $Res call(
      {String contractId,
      String engagementId,
      String title,
      String description,
      double platformFee,
      int receiverMemo,
      IndexerEscrowRoles roles,
      List<IndexerMilestone> milestones,
      IndexerTrustline trustline,
      IndexerEscrowFlags flags,
      bool isActive,
      String? signer,
      String? type,
      num? balance,
      IndexerTimestamp? createdAt,
      IndexerTimestamp? updatedAt,
      String? fundedBy,
      num? approverFunds,
      num? receiverFunds,
      String? user,
      String? disputeStartedBy});

  $IndexerEscrowRolesCopyWith<$Res> get roles;
  $IndexerTrustlineCopyWith<$Res> get trustline;
  $IndexerEscrowFlagsCopyWith<$Res> get flags;
  $IndexerTimestampCopyWith<$Res>? get createdAt;
  $IndexerTimestampCopyWith<$Res>? get updatedAt;
}

/// @nodoc
class _$IndexerEscrowCopyWithImpl<$Res, $Val extends IndexerEscrow>
    implements $IndexerEscrowCopyWith<$Res> {
  _$IndexerEscrowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? engagementId = null,
    Object? title = null,
    Object? description = null,
    Object? platformFee = null,
    Object? receiverMemo = null,
    Object? roles = null,
    Object? milestones = null,
    Object? trustline = null,
    Object? flags = null,
    Object? isActive = null,
    Object? signer = freezed,
    Object? type = freezed,
    Object? balance = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? fundedBy = freezed,
    Object? approverFunds = freezed,
    Object? receiverFunds = freezed,
    Object? user = freezed,
    Object? disputeStartedBy = freezed,
  }) {
    return _then(_value.copyWith(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      engagementId: null == engagementId
          ? _value.engagementId
          : engagementId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      platformFee: null == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double,
      receiverMemo: null == receiverMemo
          ? _value.receiverMemo
          : receiverMemo // ignore: cast_nullable_to_non_nullable
              as int,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as IndexerEscrowRoles,
      milestones: null == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<IndexerMilestone>,
      trustline: null == trustline
          ? _value.trustline
          : trustline // ignore: cast_nullable_to_non_nullable
              as IndexerTrustline,
      flags: null == flags
          ? _value.flags
          : flags // ignore: cast_nullable_to_non_nullable
              as IndexerEscrowFlags,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      signer: freezed == signer
          ? _value.signer
          : signer // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as num?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as IndexerTimestamp?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as IndexerTimestamp?,
      fundedBy: freezed == fundedBy
          ? _value.fundedBy
          : fundedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approverFunds: freezed == approverFunds
          ? _value.approverFunds
          : approverFunds // ignore: cast_nullable_to_non_nullable
              as num?,
      receiverFunds: freezed == receiverFunds
          ? _value.receiverFunds
          : receiverFunds // ignore: cast_nullable_to_non_nullable
              as num?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
      disputeStartedBy: freezed == disputeStartedBy
          ? _value.disputeStartedBy
          : disputeStartedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndexerEscrowRolesCopyWith<$Res> get roles {
    return $IndexerEscrowRolesCopyWith<$Res>(_value.roles, (value) {
      return _then(_value.copyWith(roles: value) as $Val);
    });
  }

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndexerTrustlineCopyWith<$Res> get trustline {
    return $IndexerTrustlineCopyWith<$Res>(_value.trustline, (value) {
      return _then(_value.copyWith(trustline: value) as $Val);
    });
  }

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndexerEscrowFlagsCopyWith<$Res> get flags {
    return $IndexerEscrowFlagsCopyWith<$Res>(_value.flags, (value) {
      return _then(_value.copyWith(flags: value) as $Val);
    });
  }

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndexerTimestampCopyWith<$Res>? get createdAt {
    if (_value.createdAt == null) {
      return null;
    }

    return $IndexerTimestampCopyWith<$Res>(_value.createdAt!, (value) {
      return _then(_value.copyWith(createdAt: value) as $Val);
    });
  }

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndexerTimestampCopyWith<$Res>? get updatedAt {
    if (_value.updatedAt == null) {
      return null;
    }

    return $IndexerTimestampCopyWith<$Res>(_value.updatedAt!, (value) {
      return _then(_value.copyWith(updatedAt: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IndexerEscrowImplCopyWith<$Res>
    implements $IndexerEscrowCopyWith<$Res> {
  factory _$$IndexerEscrowImplCopyWith(
          _$IndexerEscrowImpl value, $Res Function(_$IndexerEscrowImpl) then) =
      __$$IndexerEscrowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contractId,
      String engagementId,
      String title,
      String description,
      double platformFee,
      int receiverMemo,
      IndexerEscrowRoles roles,
      List<IndexerMilestone> milestones,
      IndexerTrustline trustline,
      IndexerEscrowFlags flags,
      bool isActive,
      String? signer,
      String? type,
      num? balance,
      IndexerTimestamp? createdAt,
      IndexerTimestamp? updatedAt,
      String? fundedBy,
      num? approverFunds,
      num? receiverFunds,
      String? user,
      String? disputeStartedBy});

  @override
  $IndexerEscrowRolesCopyWith<$Res> get roles;
  @override
  $IndexerTrustlineCopyWith<$Res> get trustline;
  @override
  $IndexerEscrowFlagsCopyWith<$Res> get flags;
  @override
  $IndexerTimestampCopyWith<$Res>? get createdAt;
  @override
  $IndexerTimestampCopyWith<$Res>? get updatedAt;
}

/// @nodoc
class __$$IndexerEscrowImplCopyWithImpl<$Res>
    extends _$IndexerEscrowCopyWithImpl<$Res, _$IndexerEscrowImpl>
    implements _$$IndexerEscrowImplCopyWith<$Res> {
  __$$IndexerEscrowImplCopyWithImpl(
      _$IndexerEscrowImpl _value, $Res Function(_$IndexerEscrowImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? engagementId = null,
    Object? title = null,
    Object? description = null,
    Object? platformFee = null,
    Object? receiverMemo = null,
    Object? roles = null,
    Object? milestones = null,
    Object? trustline = null,
    Object? flags = null,
    Object? isActive = null,
    Object? signer = freezed,
    Object? type = freezed,
    Object? balance = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? fundedBy = freezed,
    Object? approverFunds = freezed,
    Object? receiverFunds = freezed,
    Object? user = freezed,
    Object? disputeStartedBy = freezed,
  }) {
    return _then(_$IndexerEscrowImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as String,
      engagementId: null == engagementId
          ? _value.engagementId
          : engagementId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      platformFee: null == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double,
      receiverMemo: null == receiverMemo
          ? _value.receiverMemo
          : receiverMemo // ignore: cast_nullable_to_non_nullable
              as int,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as IndexerEscrowRoles,
      milestones: null == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<IndexerMilestone>,
      trustline: null == trustline
          ? _value.trustline
          : trustline // ignore: cast_nullable_to_non_nullable
              as IndexerTrustline,
      flags: null == flags
          ? _value.flags
          : flags // ignore: cast_nullable_to_non_nullable
              as IndexerEscrowFlags,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      signer: freezed == signer
          ? _value.signer
          : signer // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as num?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as IndexerTimestamp?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as IndexerTimestamp?,
      fundedBy: freezed == fundedBy
          ? _value.fundedBy
          : fundedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approverFunds: freezed == approverFunds
          ? _value.approverFunds
          : approverFunds // ignore: cast_nullable_to_non_nullable
              as num?,
      receiverFunds: freezed == receiverFunds
          ? _value.receiverFunds
          : receiverFunds // ignore: cast_nullable_to_non_nullable
              as num?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
      disputeStartedBy: freezed == disputeStartedBy
          ? _value.disputeStartedBy
          : disputeStartedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexerEscrowImpl implements _IndexerEscrow {
  const _$IndexerEscrowImpl(
      {required this.contractId,
      required this.engagementId,
      required this.title,
      required this.description,
      required this.platformFee,
      required this.receiverMemo,
      required this.roles,
      required final List<IndexerMilestone> milestones,
      required this.trustline,
      required this.flags,
      required this.isActive,
      this.signer,
      this.type,
      this.balance,
      this.createdAt,
      this.updatedAt,
      this.fundedBy,
      this.approverFunds,
      this.receiverFunds,
      this.user,
      this.disputeStartedBy})
      : _milestones = milestones;

  factory _$IndexerEscrowImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexerEscrowImplFromJson(json);

  @override
  final String contractId;
  @override
  final String engagementId;
  @override
  final String title;
  @override
  final String description;
  @override
  final double platformFee;
  @override
  final int receiverMemo;
  @override
  final IndexerEscrowRoles roles;
  final List<IndexerMilestone> _milestones;
  @override
  List<IndexerMilestone> get milestones {
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestones);
  }

  @override
  final IndexerTrustline trustline;
  @override
  final IndexerEscrowFlags flags;
  @override
  final bool isActive;
  @override
  final String? signer;
  @override
  final String? type;
  @override
  final num? balance;
  @override
  final IndexerTimestamp? createdAt;
  @override
  final IndexerTimestamp? updatedAt;
// Optional indexer-surfaced metadata called out in HAB-61. These are
// not present in the OpenAPI example but the prompt explicitly lists
// them, so we model them as nullable pass-through fields.
  @override
  final String? fundedBy;
  @override
  final num? approverFunds;
  @override
  final num? receiverFunds;
  @override
  final String? user;
  @override
  final String? disputeStartedBy;

  @override
  String toString() {
    return 'IndexerEscrow(contractId: $contractId, engagementId: $engagementId, title: $title, description: $description, platformFee: $platformFee, receiverMemo: $receiverMemo, roles: $roles, milestones: $milestones, trustline: $trustline, flags: $flags, isActive: $isActive, signer: $signer, type: $type, balance: $balance, createdAt: $createdAt, updatedAt: $updatedAt, fundedBy: $fundedBy, approverFunds: $approverFunds, receiverFunds: $receiverFunds, user: $user, disputeStartedBy: $disputeStartedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexerEscrowImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.engagementId, engagementId) ||
                other.engagementId == engagementId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.platformFee, platformFee) ||
                other.platformFee == platformFee) &&
            (identical(other.receiverMemo, receiverMemo) ||
                other.receiverMemo == receiverMemo) &&
            (identical(other.roles, roles) || other.roles == roles) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones) &&
            (identical(other.trustline, trustline) ||
                other.trustline == trustline) &&
            (identical(other.flags, flags) || other.flags == flags) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.signer, signer) || other.signer == signer) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.fundedBy, fundedBy) ||
                other.fundedBy == fundedBy) &&
            (identical(other.approverFunds, approverFunds) ||
                other.approverFunds == approverFunds) &&
            (identical(other.receiverFunds, receiverFunds) ||
                other.receiverFunds == receiverFunds) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.disputeStartedBy, disputeStartedBy) ||
                other.disputeStartedBy == disputeStartedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        contractId,
        engagementId,
        title,
        description,
        platformFee,
        receiverMemo,
        roles,
        const DeepCollectionEquality().hash(_milestones),
        trustline,
        flags,
        isActive,
        signer,
        type,
        balance,
        createdAt,
        updatedAt,
        fundedBy,
        approverFunds,
        receiverFunds,
        user,
        disputeStartedBy
      ]);

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexerEscrowImplCopyWith<_$IndexerEscrowImpl> get copyWith =>
      __$$IndexerEscrowImplCopyWithImpl<_$IndexerEscrowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexerEscrowImplToJson(
      this,
    );
  }
}

abstract class _IndexerEscrow implements IndexerEscrow {
  const factory _IndexerEscrow(
      {required final String contractId,
      required final String engagementId,
      required final String title,
      required final String description,
      required final double platformFee,
      required final int receiverMemo,
      required final IndexerEscrowRoles roles,
      required final List<IndexerMilestone> milestones,
      required final IndexerTrustline trustline,
      required final IndexerEscrowFlags flags,
      required final bool isActive,
      final String? signer,
      final String? type,
      final num? balance,
      final IndexerTimestamp? createdAt,
      final IndexerTimestamp? updatedAt,
      final String? fundedBy,
      final num? approverFunds,
      final num? receiverFunds,
      final String? user,
      final String? disputeStartedBy}) = _$IndexerEscrowImpl;

  factory _IndexerEscrow.fromJson(Map<String, dynamic> json) =
      _$IndexerEscrowImpl.fromJson;

  @override
  String get contractId;
  @override
  String get engagementId;
  @override
  String get title;
  @override
  String get description;
  @override
  double get platformFee;
  @override
  int get receiverMemo;
  @override
  IndexerEscrowRoles get roles;
  @override
  List<IndexerMilestone> get milestones;
  @override
  IndexerTrustline get trustline;
  @override
  IndexerEscrowFlags get flags;
  @override
  bool get isActive;
  @override
  String? get signer;
  @override
  String? get type;
  @override
  num? get balance;
  @override
  IndexerTimestamp? get createdAt;
  @override
  IndexerTimestamp?
      get updatedAt; // Optional indexer-surfaced metadata called out in HAB-61. These are
// not present in the OpenAPI example but the prompt explicitly lists
// them, so we model them as nullable pass-through fields.
  @override
  String? get fundedBy;
  @override
  num? get approverFunds;
  @override
  num? get receiverFunds;
  @override
  String? get user;
  @override
  String? get disputeStartedBy;

  /// Create a copy of IndexerEscrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexerEscrowImplCopyWith<_$IndexerEscrowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IndexerEscrowRoles _$IndexerEscrowRolesFromJson(Map<String, dynamic> json) {
  return _IndexerEscrowRoles.fromJson(json);
}

/// @nodoc
mixin _$IndexerEscrowRoles {
  String? get approver => throw _privateConstructorUsedError;
  String? get serviceProvider => throw _privateConstructorUsedError;
  String? get platformAddress => throw _privateConstructorUsedError;
  String? get releaseSigner => throw _privateConstructorUsedError;
  String? get disputeResolver => throw _privateConstructorUsedError;
  String? get receiver => throw _privateConstructorUsedError;
  String? get issuer => throw _privateConstructorUsedError;

  /// Serializes this IndexerEscrowRoles to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexerEscrowRoles
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexerEscrowRolesCopyWith<IndexerEscrowRoles> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexerEscrowRolesCopyWith<$Res> {
  factory $IndexerEscrowRolesCopyWith(
          IndexerEscrowRoles value, $Res Function(IndexerEscrowRoles) then) =
      _$IndexerEscrowRolesCopyWithImpl<$Res, IndexerEscrowRoles>;
  @useResult
  $Res call(
      {String? approver,
      String? serviceProvider,
      String? platformAddress,
      String? releaseSigner,
      String? disputeResolver,
      String? receiver,
      String? issuer});
}

/// @nodoc
class _$IndexerEscrowRolesCopyWithImpl<$Res, $Val extends IndexerEscrowRoles>
    implements $IndexerEscrowRolesCopyWith<$Res> {
  _$IndexerEscrowRolesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexerEscrowRoles
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? approver = freezed,
    Object? serviceProvider = freezed,
    Object? platformAddress = freezed,
    Object? releaseSigner = freezed,
    Object? disputeResolver = freezed,
    Object? receiver = freezed,
    Object? issuer = freezed,
  }) {
    return _then(_value.copyWith(
      approver: freezed == approver
          ? _value.approver
          : approver // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceProvider: freezed == serviceProvider
          ? _value.serviceProvider
          : serviceProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      platformAddress: freezed == platformAddress
          ? _value.platformAddress
          : platformAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseSigner: freezed == releaseSigner
          ? _value.releaseSigner
          : releaseSigner // ignore: cast_nullable_to_non_nullable
              as String?,
      disputeResolver: freezed == disputeResolver
          ? _value.disputeResolver
          : disputeResolver // ignore: cast_nullable_to_non_nullable
              as String?,
      receiver: freezed == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String?,
      issuer: freezed == issuer
          ? _value.issuer
          : issuer // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndexerEscrowRolesImplCopyWith<$Res>
    implements $IndexerEscrowRolesCopyWith<$Res> {
  factory _$$IndexerEscrowRolesImplCopyWith(_$IndexerEscrowRolesImpl value,
          $Res Function(_$IndexerEscrowRolesImpl) then) =
      __$$IndexerEscrowRolesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? approver,
      String? serviceProvider,
      String? platformAddress,
      String? releaseSigner,
      String? disputeResolver,
      String? receiver,
      String? issuer});
}

/// @nodoc
class __$$IndexerEscrowRolesImplCopyWithImpl<$Res>
    extends _$IndexerEscrowRolesCopyWithImpl<$Res, _$IndexerEscrowRolesImpl>
    implements _$$IndexerEscrowRolesImplCopyWith<$Res> {
  __$$IndexerEscrowRolesImplCopyWithImpl(_$IndexerEscrowRolesImpl _value,
      $Res Function(_$IndexerEscrowRolesImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndexerEscrowRoles
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? approver = freezed,
    Object? serviceProvider = freezed,
    Object? platformAddress = freezed,
    Object? releaseSigner = freezed,
    Object? disputeResolver = freezed,
    Object? receiver = freezed,
    Object? issuer = freezed,
  }) {
    return _then(_$IndexerEscrowRolesImpl(
      approver: freezed == approver
          ? _value.approver
          : approver // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceProvider: freezed == serviceProvider
          ? _value.serviceProvider
          : serviceProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      platformAddress: freezed == platformAddress
          ? _value.platformAddress
          : platformAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseSigner: freezed == releaseSigner
          ? _value.releaseSigner
          : releaseSigner // ignore: cast_nullable_to_non_nullable
              as String?,
      disputeResolver: freezed == disputeResolver
          ? _value.disputeResolver
          : disputeResolver // ignore: cast_nullable_to_non_nullable
              as String?,
      receiver: freezed == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String?,
      issuer: freezed == issuer
          ? _value.issuer
          : issuer // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexerEscrowRolesImpl implements _IndexerEscrowRoles {
  const _$IndexerEscrowRolesImpl(
      {this.approver,
      this.serviceProvider,
      this.platformAddress,
      this.releaseSigner,
      this.disputeResolver,
      this.receiver,
      this.issuer});

  factory _$IndexerEscrowRolesImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexerEscrowRolesImplFromJson(json);

  @override
  final String? approver;
  @override
  final String? serviceProvider;
  @override
  final String? platformAddress;
  @override
  final String? releaseSigner;
  @override
  final String? disputeResolver;
  @override
  final String? receiver;
  @override
  final String? issuer;

  @override
  String toString() {
    return 'IndexerEscrowRoles(approver: $approver, serviceProvider: $serviceProvider, platformAddress: $platformAddress, releaseSigner: $releaseSigner, disputeResolver: $disputeResolver, receiver: $receiver, issuer: $issuer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexerEscrowRolesImpl &&
            (identical(other.approver, approver) ||
                other.approver == approver) &&
            (identical(other.serviceProvider, serviceProvider) ||
                other.serviceProvider == serviceProvider) &&
            (identical(other.platformAddress, platformAddress) ||
                other.platformAddress == platformAddress) &&
            (identical(other.releaseSigner, releaseSigner) ||
                other.releaseSigner == releaseSigner) &&
            (identical(other.disputeResolver, disputeResolver) ||
                other.disputeResolver == disputeResolver) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.issuer, issuer) || other.issuer == issuer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, approver, serviceProvider,
      platformAddress, releaseSigner, disputeResolver, receiver, issuer);

  /// Create a copy of IndexerEscrowRoles
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexerEscrowRolesImplCopyWith<_$IndexerEscrowRolesImpl> get copyWith =>
      __$$IndexerEscrowRolesImplCopyWithImpl<_$IndexerEscrowRolesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexerEscrowRolesImplToJson(
      this,
    );
  }
}

abstract class _IndexerEscrowRoles implements IndexerEscrowRoles {
  const factory _IndexerEscrowRoles(
      {final String? approver,
      final String? serviceProvider,
      final String? platformAddress,
      final String? releaseSigner,
      final String? disputeResolver,
      final String? receiver,
      final String? issuer}) = _$IndexerEscrowRolesImpl;

  factory _IndexerEscrowRoles.fromJson(Map<String, dynamic> json) =
      _$IndexerEscrowRolesImpl.fromJson;

  @override
  String? get approver;
  @override
  String? get serviceProvider;
  @override
  String? get platformAddress;
  @override
  String? get releaseSigner;
  @override
  String? get disputeResolver;
  @override
  String? get receiver;
  @override
  String? get issuer;

  /// Create a copy of IndexerEscrowRoles
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexerEscrowRolesImplCopyWith<_$IndexerEscrowRolesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IndexerMilestone _$IndexerMilestoneFromJson(Map<String, dynamic> json) {
  return _IndexerMilestone.fromJson(json);
}

/// @nodoc
mixin _$IndexerMilestone {
  String get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  IndexerMilestoneFlags get flags => throw _privateConstructorUsedError;
  num? get amount => throw _privateConstructorUsedError;
  String? get evidence => throw _privateConstructorUsedError;
  String? get receiver => throw _privateConstructorUsedError;

  /// Serializes this IndexerMilestone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexerMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexerMilestoneCopyWith<IndexerMilestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexerMilestoneCopyWith<$Res> {
  factory $IndexerMilestoneCopyWith(
          IndexerMilestone value, $Res Function(IndexerMilestone) then) =
      _$IndexerMilestoneCopyWithImpl<$Res, IndexerMilestone>;
  @useResult
  $Res call(
      {String description,
      String status,
      IndexerMilestoneFlags flags,
      num? amount,
      String? evidence,
      String? receiver});

  $IndexerMilestoneFlagsCopyWith<$Res> get flags;
}

/// @nodoc
class _$IndexerMilestoneCopyWithImpl<$Res, $Val extends IndexerMilestone>
    implements $IndexerMilestoneCopyWith<$Res> {
  _$IndexerMilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexerMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? status = null,
    Object? flags = null,
    Object? amount = freezed,
    Object? evidence = freezed,
    Object? receiver = freezed,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      flags: null == flags
          ? _value.flags
          : flags // ignore: cast_nullable_to_non_nullable
              as IndexerMilestoneFlags,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num?,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
      receiver: freezed == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of IndexerMilestone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndexerMilestoneFlagsCopyWith<$Res> get flags {
    return $IndexerMilestoneFlagsCopyWith<$Res>(_value.flags, (value) {
      return _then(_value.copyWith(flags: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IndexerMilestoneImplCopyWith<$Res>
    implements $IndexerMilestoneCopyWith<$Res> {
  factory _$$IndexerMilestoneImplCopyWith(_$IndexerMilestoneImpl value,
          $Res Function(_$IndexerMilestoneImpl) then) =
      __$$IndexerMilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String description,
      String status,
      IndexerMilestoneFlags flags,
      num? amount,
      String? evidence,
      String? receiver});

  @override
  $IndexerMilestoneFlagsCopyWith<$Res> get flags;
}

/// @nodoc
class __$$IndexerMilestoneImplCopyWithImpl<$Res>
    extends _$IndexerMilestoneCopyWithImpl<$Res, _$IndexerMilestoneImpl>
    implements _$$IndexerMilestoneImplCopyWith<$Res> {
  __$$IndexerMilestoneImplCopyWithImpl(_$IndexerMilestoneImpl _value,
      $Res Function(_$IndexerMilestoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndexerMilestone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? status = null,
    Object? flags = null,
    Object? amount = freezed,
    Object? evidence = freezed,
    Object? receiver = freezed,
  }) {
    return _then(_$IndexerMilestoneImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      flags: null == flags
          ? _value.flags
          : flags // ignore: cast_nullable_to_non_nullable
              as IndexerMilestoneFlags,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num?,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
      receiver: freezed == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexerMilestoneImpl implements _IndexerMilestone {
  const _$IndexerMilestoneImpl(
      {required this.description,
      this.status = 'pending',
      required this.flags,
      this.amount,
      this.evidence,
      this.receiver});

  factory _$IndexerMilestoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexerMilestoneImplFromJson(json);

  @override
  final String description;
  @override
  @JsonKey()
  final String status;
  @override
  final IndexerMilestoneFlags flags;
  @override
  final num? amount;
  @override
  final String? evidence;
  @override
  final String? receiver;

  @override
  String toString() {
    return 'IndexerMilestone(description: $description, status: $status, flags: $flags, amount: $amount, evidence: $evidence, receiver: $receiver)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexerMilestoneImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.flags, flags) || other.flags == flags) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.evidence, evidence) ||
                other.evidence == evidence) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, description, status, flags, amount, evidence, receiver);

  /// Create a copy of IndexerMilestone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexerMilestoneImplCopyWith<_$IndexerMilestoneImpl> get copyWith =>
      __$$IndexerMilestoneImplCopyWithImpl<_$IndexerMilestoneImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexerMilestoneImplToJson(
      this,
    );
  }
}

abstract class _IndexerMilestone implements IndexerMilestone {
  const factory _IndexerMilestone(
      {required final String description,
      final String status,
      required final IndexerMilestoneFlags flags,
      final num? amount,
      final String? evidence,
      final String? receiver}) = _$IndexerMilestoneImpl;

  factory _IndexerMilestone.fromJson(Map<String, dynamic> json) =
      _$IndexerMilestoneImpl.fromJson;

  @override
  String get description;
  @override
  String get status;
  @override
  IndexerMilestoneFlags get flags;
  @override
  num? get amount;
  @override
  String? get evidence;
  @override
  String? get receiver;

  /// Create a copy of IndexerMilestone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexerMilestoneImplCopyWith<_$IndexerMilestoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IndexerMilestoneFlags _$IndexerMilestoneFlagsFromJson(
    Map<String, dynamic> json) {
  return _IndexerMilestoneFlags.fromJson(json);
}

/// @nodoc
mixin _$IndexerMilestoneFlags {
  bool get approved => throw _privateConstructorUsedError;
  bool get disputed => throw _privateConstructorUsedError;
  bool get released => throw _privateConstructorUsedError;
  bool get resolved => throw _privateConstructorUsedError;

  /// Serializes this IndexerMilestoneFlags to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexerMilestoneFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexerMilestoneFlagsCopyWith<IndexerMilestoneFlags> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexerMilestoneFlagsCopyWith<$Res> {
  factory $IndexerMilestoneFlagsCopyWith(IndexerMilestoneFlags value,
          $Res Function(IndexerMilestoneFlags) then) =
      _$IndexerMilestoneFlagsCopyWithImpl<$Res, IndexerMilestoneFlags>;
  @useResult
  $Res call({bool approved, bool disputed, bool released, bool resolved});
}

/// @nodoc
class _$IndexerMilestoneFlagsCopyWithImpl<$Res,
        $Val extends IndexerMilestoneFlags>
    implements $IndexerMilestoneFlagsCopyWith<$Res> {
  _$IndexerMilestoneFlagsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexerMilestoneFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? approved = null,
    Object? disputed = null,
    Object? released = null,
    Object? resolved = null,
  }) {
    return _then(_value.copyWith(
      approved: null == approved
          ? _value.approved
          : approved // ignore: cast_nullable_to_non_nullable
              as bool,
      disputed: null == disputed
          ? _value.disputed
          : disputed // ignore: cast_nullable_to_non_nullable
              as bool,
      released: null == released
          ? _value.released
          : released // ignore: cast_nullable_to_non_nullable
              as bool,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndexerMilestoneFlagsImplCopyWith<$Res>
    implements $IndexerMilestoneFlagsCopyWith<$Res> {
  factory _$$IndexerMilestoneFlagsImplCopyWith(
          _$IndexerMilestoneFlagsImpl value,
          $Res Function(_$IndexerMilestoneFlagsImpl) then) =
      __$$IndexerMilestoneFlagsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool approved, bool disputed, bool released, bool resolved});
}

/// @nodoc
class __$$IndexerMilestoneFlagsImplCopyWithImpl<$Res>
    extends _$IndexerMilestoneFlagsCopyWithImpl<$Res,
        _$IndexerMilestoneFlagsImpl>
    implements _$$IndexerMilestoneFlagsImplCopyWith<$Res> {
  __$$IndexerMilestoneFlagsImplCopyWithImpl(_$IndexerMilestoneFlagsImpl _value,
      $Res Function(_$IndexerMilestoneFlagsImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndexerMilestoneFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? approved = null,
    Object? disputed = null,
    Object? released = null,
    Object? resolved = null,
  }) {
    return _then(_$IndexerMilestoneFlagsImpl(
      approved: null == approved
          ? _value.approved
          : approved // ignore: cast_nullable_to_non_nullable
              as bool,
      disputed: null == disputed
          ? _value.disputed
          : disputed // ignore: cast_nullable_to_non_nullable
              as bool,
      released: null == released
          ? _value.released
          : released // ignore: cast_nullable_to_non_nullable
              as bool,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexerMilestoneFlagsImpl implements _IndexerMilestoneFlags {
  const _$IndexerMilestoneFlagsImpl(
      {this.approved = false,
      this.disputed = false,
      this.released = false,
      this.resolved = false});

  factory _$IndexerMilestoneFlagsImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexerMilestoneFlagsImplFromJson(json);

  @override
  @JsonKey()
  final bool approved;
  @override
  @JsonKey()
  final bool disputed;
  @override
  @JsonKey()
  final bool released;
  @override
  @JsonKey()
  final bool resolved;

  @override
  String toString() {
    return 'IndexerMilestoneFlags(approved: $approved, disputed: $disputed, released: $released, resolved: $resolved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexerMilestoneFlagsImpl &&
            (identical(other.approved, approved) ||
                other.approved == approved) &&
            (identical(other.disputed, disputed) ||
                other.disputed == disputed) &&
            (identical(other.released, released) ||
                other.released == released) &&
            (identical(other.resolved, resolved) ||
                other.resolved == resolved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, approved, disputed, released, resolved);

  /// Create a copy of IndexerMilestoneFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexerMilestoneFlagsImplCopyWith<_$IndexerMilestoneFlagsImpl>
      get copyWith => __$$IndexerMilestoneFlagsImplCopyWithImpl<
          _$IndexerMilestoneFlagsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexerMilestoneFlagsImplToJson(
      this,
    );
  }
}

abstract class _IndexerMilestoneFlags implements IndexerMilestoneFlags {
  const factory _IndexerMilestoneFlags(
      {final bool approved,
      final bool disputed,
      final bool released,
      final bool resolved}) = _$IndexerMilestoneFlagsImpl;

  factory _IndexerMilestoneFlags.fromJson(Map<String, dynamic> json) =
      _$IndexerMilestoneFlagsImpl.fromJson;

  @override
  bool get approved;
  @override
  bool get disputed;
  @override
  bool get released;
  @override
  bool get resolved;

  /// Create a copy of IndexerMilestoneFlags
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexerMilestoneFlagsImplCopyWith<_$IndexerMilestoneFlagsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

IndexerEscrowFlags _$IndexerEscrowFlagsFromJson(Map<String, dynamic> json) {
  return _IndexerEscrowFlags.fromJson(json);
}

/// @nodoc
mixin _$IndexerEscrowFlags {
  bool get disputed => throw _privateConstructorUsedError;
  bool get released => throw _privateConstructorUsedError;
  bool get resolved => throw _privateConstructorUsedError;

  /// Serializes this IndexerEscrowFlags to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexerEscrowFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexerEscrowFlagsCopyWith<IndexerEscrowFlags> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexerEscrowFlagsCopyWith<$Res> {
  factory $IndexerEscrowFlagsCopyWith(
          IndexerEscrowFlags value, $Res Function(IndexerEscrowFlags) then) =
      _$IndexerEscrowFlagsCopyWithImpl<$Res, IndexerEscrowFlags>;
  @useResult
  $Res call({bool disputed, bool released, bool resolved});
}

/// @nodoc
class _$IndexerEscrowFlagsCopyWithImpl<$Res, $Val extends IndexerEscrowFlags>
    implements $IndexerEscrowFlagsCopyWith<$Res> {
  _$IndexerEscrowFlagsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexerEscrowFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disputed = null,
    Object? released = null,
    Object? resolved = null,
  }) {
    return _then(_value.copyWith(
      disputed: null == disputed
          ? _value.disputed
          : disputed // ignore: cast_nullable_to_non_nullable
              as bool,
      released: null == released
          ? _value.released
          : released // ignore: cast_nullable_to_non_nullable
              as bool,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndexerEscrowFlagsImplCopyWith<$Res>
    implements $IndexerEscrowFlagsCopyWith<$Res> {
  factory _$$IndexerEscrowFlagsImplCopyWith(_$IndexerEscrowFlagsImpl value,
          $Res Function(_$IndexerEscrowFlagsImpl) then) =
      __$$IndexerEscrowFlagsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool disputed, bool released, bool resolved});
}

/// @nodoc
class __$$IndexerEscrowFlagsImplCopyWithImpl<$Res>
    extends _$IndexerEscrowFlagsCopyWithImpl<$Res, _$IndexerEscrowFlagsImpl>
    implements _$$IndexerEscrowFlagsImplCopyWith<$Res> {
  __$$IndexerEscrowFlagsImplCopyWithImpl(_$IndexerEscrowFlagsImpl _value,
      $Res Function(_$IndexerEscrowFlagsImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndexerEscrowFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disputed = null,
    Object? released = null,
    Object? resolved = null,
  }) {
    return _then(_$IndexerEscrowFlagsImpl(
      disputed: null == disputed
          ? _value.disputed
          : disputed // ignore: cast_nullable_to_non_nullable
              as bool,
      released: null == released
          ? _value.released
          : released // ignore: cast_nullable_to_non_nullable
              as bool,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexerEscrowFlagsImpl implements _IndexerEscrowFlags {
  const _$IndexerEscrowFlagsImpl(
      {this.disputed = false, this.released = false, this.resolved = false});

  factory _$IndexerEscrowFlagsImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexerEscrowFlagsImplFromJson(json);

  @override
  @JsonKey()
  final bool disputed;
  @override
  @JsonKey()
  final bool released;
  @override
  @JsonKey()
  final bool resolved;

  @override
  String toString() {
    return 'IndexerEscrowFlags(disputed: $disputed, released: $released, resolved: $resolved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexerEscrowFlagsImpl &&
            (identical(other.disputed, disputed) ||
                other.disputed == disputed) &&
            (identical(other.released, released) ||
                other.released == released) &&
            (identical(other.resolved, resolved) ||
                other.resolved == resolved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, disputed, released, resolved);

  /// Create a copy of IndexerEscrowFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexerEscrowFlagsImplCopyWith<_$IndexerEscrowFlagsImpl> get copyWith =>
      __$$IndexerEscrowFlagsImplCopyWithImpl<_$IndexerEscrowFlagsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexerEscrowFlagsImplToJson(
      this,
    );
  }
}

abstract class _IndexerEscrowFlags implements IndexerEscrowFlags {
  const factory _IndexerEscrowFlags(
      {final bool disputed,
      final bool released,
      final bool resolved}) = _$IndexerEscrowFlagsImpl;

  factory _IndexerEscrowFlags.fromJson(Map<String, dynamic> json) =
      _$IndexerEscrowFlagsImpl.fromJson;

  @override
  bool get disputed;
  @override
  bool get released;
  @override
  bool get resolved;

  /// Create a copy of IndexerEscrowFlags
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexerEscrowFlagsImplCopyWith<_$IndexerEscrowFlagsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IndexerTrustline _$IndexerTrustlineFromJson(Map<String, dynamic> json) {
  return _IndexerTrustline.fromJson(json);
}

/// @nodoc
mixin _$IndexerTrustline {
  String get address => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this IndexerTrustline to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexerTrustline
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexerTrustlineCopyWith<IndexerTrustline> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexerTrustlineCopyWith<$Res> {
  factory $IndexerTrustlineCopyWith(
          IndexerTrustline value, $Res Function(IndexerTrustline) then) =
      _$IndexerTrustlineCopyWithImpl<$Res, IndexerTrustline>;
  @useResult
  $Res call({String address, String name});
}

/// @nodoc
class _$IndexerTrustlineCopyWithImpl<$Res, $Val extends IndexerTrustline>
    implements $IndexerTrustlineCopyWith<$Res> {
  _$IndexerTrustlineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexerTrustline
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndexerTrustlineImplCopyWith<$Res>
    implements $IndexerTrustlineCopyWith<$Res> {
  factory _$$IndexerTrustlineImplCopyWith(_$IndexerTrustlineImpl value,
          $Res Function(_$IndexerTrustlineImpl) then) =
      __$$IndexerTrustlineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String address, String name});
}

/// @nodoc
class __$$IndexerTrustlineImplCopyWithImpl<$Res>
    extends _$IndexerTrustlineCopyWithImpl<$Res, _$IndexerTrustlineImpl>
    implements _$$IndexerTrustlineImplCopyWith<$Res> {
  __$$IndexerTrustlineImplCopyWithImpl(_$IndexerTrustlineImpl _value,
      $Res Function(_$IndexerTrustlineImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndexerTrustline
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? name = null,
  }) {
    return _then(_$IndexerTrustlineImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexerTrustlineImpl implements _IndexerTrustline {
  const _$IndexerTrustlineImpl({required this.address, required this.name});

  factory _$IndexerTrustlineImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexerTrustlineImplFromJson(json);

  @override
  final String address;
  @override
  final String name;

  @override
  String toString() {
    return 'IndexerTrustline(address: $address, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexerTrustlineImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, address, name);

  /// Create a copy of IndexerTrustline
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexerTrustlineImplCopyWith<_$IndexerTrustlineImpl> get copyWith =>
      __$$IndexerTrustlineImplCopyWithImpl<_$IndexerTrustlineImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexerTrustlineImplToJson(
      this,
    );
  }
}

abstract class _IndexerTrustline implements IndexerTrustline {
  const factory _IndexerTrustline(
      {required final String address,
      required final String name}) = _$IndexerTrustlineImpl;

  factory _IndexerTrustline.fromJson(Map<String, dynamic> json) =
      _$IndexerTrustlineImpl.fromJson;

  @override
  String get address;
  @override
  String get name;

  /// Create a copy of IndexerTrustline
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexerTrustlineImplCopyWith<_$IndexerTrustlineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IndexerTimestamp _$IndexerTimestampFromJson(Map<String, dynamic> json) {
  return _IndexerTimestamp.fromJson(json);
}

/// @nodoc
mixin _$IndexerTimestamp {
  @JsonKey(name: '_seconds')
  int get seconds => throw _privateConstructorUsedError;
  @JsonKey(name: '_nanoseconds')
  int get nanoseconds => throw _privateConstructorUsedError;

  /// Serializes this IndexerTimestamp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexerTimestamp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexerTimestampCopyWith<IndexerTimestamp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexerTimestampCopyWith<$Res> {
  factory $IndexerTimestampCopyWith(
          IndexerTimestamp value, $Res Function(IndexerTimestamp) then) =
      _$IndexerTimestampCopyWithImpl<$Res, IndexerTimestamp>;
  @useResult
  $Res call(
      {@JsonKey(name: '_seconds') int seconds,
      @JsonKey(name: '_nanoseconds') int nanoseconds});
}

/// @nodoc
class _$IndexerTimestampCopyWithImpl<$Res, $Val extends IndexerTimestamp>
    implements $IndexerTimestampCopyWith<$Res> {
  _$IndexerTimestampCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexerTimestamp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seconds = null,
    Object? nanoseconds = null,
  }) {
    return _then(_value.copyWith(
      seconds: null == seconds
          ? _value.seconds
          : seconds // ignore: cast_nullable_to_non_nullable
              as int,
      nanoseconds: null == nanoseconds
          ? _value.nanoseconds
          : nanoseconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndexerTimestampImplCopyWith<$Res>
    implements $IndexerTimestampCopyWith<$Res> {
  factory _$$IndexerTimestampImplCopyWith(_$IndexerTimestampImpl value,
          $Res Function(_$IndexerTimestampImpl) then) =
      __$$IndexerTimestampImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_seconds') int seconds,
      @JsonKey(name: '_nanoseconds') int nanoseconds});
}

/// @nodoc
class __$$IndexerTimestampImplCopyWithImpl<$Res>
    extends _$IndexerTimestampCopyWithImpl<$Res, _$IndexerTimestampImpl>
    implements _$$IndexerTimestampImplCopyWith<$Res> {
  __$$IndexerTimestampImplCopyWithImpl(_$IndexerTimestampImpl _value,
      $Res Function(_$IndexerTimestampImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndexerTimestamp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seconds = null,
    Object? nanoseconds = null,
  }) {
    return _then(_$IndexerTimestampImpl(
      seconds: null == seconds
          ? _value.seconds
          : seconds // ignore: cast_nullable_to_non_nullable
              as int,
      nanoseconds: null == nanoseconds
          ? _value.nanoseconds
          : nanoseconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexerTimestampImpl implements _IndexerTimestamp {
  const _$IndexerTimestampImpl(
      {@JsonKey(name: '_seconds') required this.seconds,
      @JsonKey(name: '_nanoseconds') required this.nanoseconds});

  factory _$IndexerTimestampImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexerTimestampImplFromJson(json);

  @override
  @JsonKey(name: '_seconds')
  final int seconds;
  @override
  @JsonKey(name: '_nanoseconds')
  final int nanoseconds;

  @override
  String toString() {
    return 'IndexerTimestamp(seconds: $seconds, nanoseconds: $nanoseconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexerTimestampImpl &&
            (identical(other.seconds, seconds) || other.seconds == seconds) &&
            (identical(other.nanoseconds, nanoseconds) ||
                other.nanoseconds == nanoseconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, seconds, nanoseconds);

  /// Create a copy of IndexerTimestamp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexerTimestampImplCopyWith<_$IndexerTimestampImpl> get copyWith =>
      __$$IndexerTimestampImplCopyWithImpl<_$IndexerTimestampImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexerTimestampImplToJson(
      this,
    );
  }
}

abstract class _IndexerTimestamp implements IndexerTimestamp {
  const factory _IndexerTimestamp(
          {@JsonKey(name: '_seconds') required final int seconds,
          @JsonKey(name: '_nanoseconds') required final int nanoseconds}) =
      _$IndexerTimestampImpl;

  factory _IndexerTimestamp.fromJson(Map<String, dynamic> json) =
      _$IndexerTimestampImpl.fromJson;

  @override
  @JsonKey(name: '_seconds')
  int get seconds;
  @override
  @JsonKey(name: '_nanoseconds')
  int get nanoseconds;

  /// Create a copy of IndexerTimestamp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexerTimestampImplCopyWith<_$IndexerTimestampImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
