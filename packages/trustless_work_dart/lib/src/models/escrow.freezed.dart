// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escrow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Escrow _$EscrowFromJson(Map<String, dynamic> json) {
  return _Escrow.fromJson(json);
}

/// @nodoc
mixin _$Escrow {
  String get contractId => throw _privateConstructorUsedError;
  String get engagementId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  double get platformFee => throw _privateConstructorUsedError;
  int get receiverMemo => throw _privateConstructorUsedError;
  List<Role> get roles => throw _privateConstructorUsedError;
  List<Milestone> get milestones => throw _privateConstructorUsedError;
  Trustline get trustline => throw _privateConstructorUsedError;
  Flags get flags => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this Escrow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Escrow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EscrowCopyWith<Escrow> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EscrowCopyWith<$Res> {
  factory $EscrowCopyWith(Escrow value, $Res Function(Escrow) then) =
      _$EscrowCopyWithImpl<$Res, Escrow>;
  @useResult
  $Res call(
      {String contractId,
      String engagementId,
      String title,
      String description,
      int amount,
      double platformFee,
      int receiverMemo,
      List<Role> roles,
      List<Milestone> milestones,
      Trustline trustline,
      Flags flags,
      bool isActive});

  $TrustlineCopyWith<$Res> get trustline;
  $FlagsCopyWith<$Res> get flags;
}

/// @nodoc
class _$EscrowCopyWithImpl<$Res, $Val extends Escrow>
    implements $EscrowCopyWith<$Res> {
  _$EscrowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Escrow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? engagementId = null,
    Object? title = null,
    Object? description = null,
    Object? amount = null,
    Object? platformFee = null,
    Object? receiverMemo = null,
    Object? roles = null,
    Object? milestones = null,
    Object? trustline = null,
    Object? flags = null,
    Object? isActive = null,
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
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
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
              as List<Role>,
      milestones: null == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<Milestone>,
      trustline: null == trustline
          ? _value.trustline
          : trustline // ignore: cast_nullable_to_non_nullable
              as Trustline,
      flags: null == flags
          ? _value.flags
          : flags // ignore: cast_nullable_to_non_nullable
              as Flags,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Escrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrustlineCopyWith<$Res> get trustline {
    return $TrustlineCopyWith<$Res>(_value.trustline, (value) {
      return _then(_value.copyWith(trustline: value) as $Val);
    });
  }

  /// Create a copy of Escrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlagsCopyWith<$Res> get flags {
    return $FlagsCopyWith<$Res>(_value.flags, (value) {
      return _then(_value.copyWith(flags: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EscrowImplCopyWith<$Res> implements $EscrowCopyWith<$Res> {
  factory _$$EscrowImplCopyWith(
          _$EscrowImpl value, $Res Function(_$EscrowImpl) then) =
      __$$EscrowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contractId,
      String engagementId,
      String title,
      String description,
      int amount,
      double platformFee,
      int receiverMemo,
      List<Role> roles,
      List<Milestone> milestones,
      Trustline trustline,
      Flags flags,
      bool isActive});

  @override
  $TrustlineCopyWith<$Res> get trustline;
  @override
  $FlagsCopyWith<$Res> get flags;
}

/// @nodoc
class __$$EscrowImplCopyWithImpl<$Res>
    extends _$EscrowCopyWithImpl<$Res, _$EscrowImpl>
    implements _$$EscrowImplCopyWith<$Res> {
  __$$EscrowImplCopyWithImpl(
      _$EscrowImpl _value, $Res Function(_$EscrowImpl) _then)
      : super(_value, _then);

  /// Create a copy of Escrow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? engagementId = null,
    Object? title = null,
    Object? description = null,
    Object? amount = null,
    Object? platformFee = null,
    Object? receiverMemo = null,
    Object? roles = null,
    Object? milestones = null,
    Object? trustline = null,
    Object? flags = null,
    Object? isActive = null,
  }) {
    return _then(_$EscrowImpl(
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
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      platformFee: null == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double,
      receiverMemo: null == receiverMemo
          ? _value.receiverMemo
          : receiverMemo // ignore: cast_nullable_to_non_nullable
              as int,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<Role>,
      milestones: null == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<Milestone>,
      trustline: null == trustline
          ? _value.trustline
          : trustline // ignore: cast_nullable_to_non_nullable
              as Trustline,
      flags: null == flags
          ? _value.flags
          : flags // ignore: cast_nullable_to_non_nullable
              as Flags,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EscrowImpl implements _Escrow {
  const _$EscrowImpl(
      {required this.contractId,
      required this.engagementId,
      required this.title,
      required this.description,
      required this.amount,
      required this.platformFee,
      required this.receiverMemo,
      required final List<Role> roles,
      required final List<Milestone> milestones,
      required this.trustline,
      required this.flags,
      required this.isActive})
      : _roles = roles,
        _milestones = milestones;

  factory _$EscrowImpl.fromJson(Map<String, dynamic> json) =>
      _$$EscrowImplFromJson(json);

  @override
  final String contractId;
  @override
  final String engagementId;
  @override
  final String title;
  @override
  final String description;
  @override
  final int amount;
  @override
  final double platformFee;
  @override
  final int receiverMemo;
  final List<Role> _roles;
  @override
  List<Role> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  final List<Milestone> _milestones;
  @override
  List<Milestone> get milestones {
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestones);
  }

  @override
  final Trustline trustline;
  @override
  final Flags flags;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'Escrow(contractId: $contractId, engagementId: $engagementId, title: $title, description: $description, amount: $amount, platformFee: $platformFee, receiverMemo: $receiverMemo, roles: $roles, milestones: $milestones, trustline: $trustline, flags: $flags, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EscrowImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.engagementId, engagementId) ||
                other.engagementId == engagementId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.platformFee, platformFee) ||
                other.platformFee == platformFee) &&
            (identical(other.receiverMemo, receiverMemo) ||
                other.receiverMemo == receiverMemo) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones) &&
            (identical(other.trustline, trustline) ||
                other.trustline == trustline) &&
            (identical(other.flags, flags) || other.flags == flags) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      contractId,
      engagementId,
      title,
      description,
      amount,
      platformFee,
      receiverMemo,
      const DeepCollectionEquality().hash(_roles),
      const DeepCollectionEquality().hash(_milestones),
      trustline,
      flags,
      isActive);

  /// Create a copy of Escrow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EscrowImplCopyWith<_$EscrowImpl> get copyWith =>
      __$$EscrowImplCopyWithImpl<_$EscrowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EscrowImplToJson(
      this,
    );
  }
}

abstract class _Escrow implements Escrow {
  const factory _Escrow(
      {required final String contractId,
      required final String engagementId,
      required final String title,
      required final String description,
      required final int amount,
      required final double platformFee,
      required final int receiverMemo,
      required final List<Role> roles,
      required final List<Milestone> milestones,
      required final Trustline trustline,
      required final Flags flags,
      required final bool isActive}) = _$EscrowImpl;

  factory _Escrow.fromJson(Map<String, dynamic> json) = _$EscrowImpl.fromJson;

  @override
  String get contractId;
  @override
  String get engagementId;
  @override
  String get title;
  @override
  String get description;
  @override
  int get amount;
  @override
  double get platformFee;
  @override
  int get receiverMemo;
  @override
  List<Role> get roles;
  @override
  List<Milestone> get milestones;
  @override
  Trustline get trustline;
  @override
  Flags get flags;
  @override
  bool get isActive;

  /// Create a copy of Escrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EscrowImplCopyWith<_$EscrowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
