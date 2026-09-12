// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClaimTransition _$ClaimTransitionFromJson(Map<String, dynamic> json) {
  return _ClaimTransition.fromJson(json);
}

/// @nodoc
mixin _$ClaimTransition {
  ClaimStatus get from => throw _privateConstructorUsedError;
  ClaimStatus get to => throw _privateConstructorUsedError;
  DateTime get at => throw _privateConstructorUsedError;
  ClaimActor get actor => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this ClaimTransition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClaimTransition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClaimTransitionCopyWith<ClaimTransition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClaimTransitionCopyWith<$Res> {
  factory $ClaimTransitionCopyWith(
          ClaimTransition value, $Res Function(ClaimTransition) then) =
      _$ClaimTransitionCopyWithImpl<$Res, ClaimTransition>;
  @useResult
  $Res call(
      {ClaimStatus from,
      ClaimStatus to,
      DateTime at,
      ClaimActor actor,
      String? reason});
}

/// @nodoc
class _$ClaimTransitionCopyWithImpl<$Res, $Val extends ClaimTransition>
    implements $ClaimTransitionCopyWith<$Res> {
  _$ClaimTransitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClaimTransition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? at = null,
    Object? actor = null,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as ClaimStatus,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as ClaimStatus,
      at: null == at
          ? _value.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actor: null == actor
          ? _value.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as ClaimActor,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClaimTransitionImplCopyWith<$Res>
    implements $ClaimTransitionCopyWith<$Res> {
  factory _$$ClaimTransitionImplCopyWith(_$ClaimTransitionImpl value,
          $Res Function(_$ClaimTransitionImpl) then) =
      __$$ClaimTransitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ClaimStatus from,
      ClaimStatus to,
      DateTime at,
      ClaimActor actor,
      String? reason});
}

/// @nodoc
class __$$ClaimTransitionImplCopyWithImpl<$Res>
    extends _$ClaimTransitionCopyWithImpl<$Res, _$ClaimTransitionImpl>
    implements _$$ClaimTransitionImplCopyWith<$Res> {
  __$$ClaimTransitionImplCopyWithImpl(
      _$ClaimTransitionImpl _value, $Res Function(_$ClaimTransitionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClaimTransition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? at = null,
    Object? actor = null,
    Object? reason = freezed,
  }) {
    return _then(_$ClaimTransitionImpl(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as ClaimStatus,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as ClaimStatus,
      at: null == at
          ? _value.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actor: null == actor
          ? _value.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as ClaimActor,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClaimTransitionImpl implements _ClaimTransition {
  const _$ClaimTransitionImpl(
      {required this.from,
      required this.to,
      required this.at,
      required this.actor,
      this.reason});

  factory _$ClaimTransitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClaimTransitionImplFromJson(json);

  @override
  final ClaimStatus from;
  @override
  final ClaimStatus to;
  @override
  final DateTime at;
  @override
  final ClaimActor actor;
  @override
  final String? reason;

  @override
  String toString() {
    return 'ClaimTransition(from: $from, to: $to, at: $at, actor: $actor, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClaimTransitionImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.at, at) || other.at == at) &&
            (identical(other.actor, actor) || other.actor == actor) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, from, to, at, actor, reason);

  /// Create a copy of ClaimTransition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClaimTransitionImplCopyWith<_$ClaimTransitionImpl> get copyWith =>
      __$$ClaimTransitionImplCopyWithImpl<_$ClaimTransitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClaimTransitionImplToJson(
      this,
    );
  }
}

abstract class _ClaimTransition implements ClaimTransition {
  const factory _ClaimTransition(
      {required final ClaimStatus from,
      required final ClaimStatus to,
      required final DateTime at,
      required final ClaimActor actor,
      final String? reason}) = _$ClaimTransitionImpl;

  factory _ClaimTransition.fromJson(Map<String, dynamic> json) =
      _$ClaimTransitionImpl.fromJson;

  @override
  ClaimStatus get from;
  @override
  ClaimStatus get to;
  @override
  DateTime get at;
  @override
  ClaimActor get actor;
  @override
  String? get reason;

  /// Create a copy of ClaimTransition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClaimTransitionImplCopyWith<_$ClaimTransitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Claim _$ClaimFromJson(Map<String, dynamic> json) {
  return _Claim.fromJson(json);
}

/// @nodoc
mixin _$Claim {
  /// Identificador interno (uuid de la capa de persistencia).
  String get id => throw _privateConstructorUsedError;

  /// Código de seguimiento único y legible ([ClaimTrackingCode]).
  String get trackingCode => throw _privateConstructorUsedError;

  /// Dirección del reclamo.
  ClaimDirection get direction => throw _privateConstructorUsedError;

  /// Causa del catálogo correspondiente a [direction].
  String get cause => throw _privateConstructorUsedError;

  /// Descripción del problema.
  String get description => throw _privateConstructorUsedError;

  /// Estado actual de la máquina.
  ClaimStatus get status => throw _privateConstructorUsedError;

  /// Fotos adjuntadas al crear (obligatorias).
  List<String> get photos => throw _privateConstructorUsedError;

  /// Evidencia fotográfica de la reparación (obligatoria al resolver).
  List<String> get resolutionPhotos => throw _privateConstructorUsedError;

  /// Creación del reclamo.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Inicio de EN_REVISION (contraparte notificada). Base del plazo.
  DateTime? get reviewStartedAt => throw _privateConstructorUsedError;

  /// Cierre (RESUELTO o CALIFICACION_NEGATIVA).
  DateTime? get closedAt => throw _privateConstructorUsedError;

  /// Historial de transiciones aplicadas, en orden.
  List<ClaimTransition> get history => throw _privateConstructorUsedError;

  /// Serializes this Claim to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Claim
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClaimCopyWith<Claim> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClaimCopyWith<$Res> {
  factory $ClaimCopyWith(Claim value, $Res Function(Claim) then) =
      _$ClaimCopyWithImpl<$Res, Claim>;
  @useResult
  $Res call(
      {String id,
      String trackingCode,
      ClaimDirection direction,
      String cause,
      String description,
      ClaimStatus status,
      List<String> photos,
      List<String> resolutionPhotos,
      DateTime createdAt,
      DateTime? reviewStartedAt,
      DateTime? closedAt,
      List<ClaimTransition> history});
}

/// @nodoc
class _$ClaimCopyWithImpl<$Res, $Val extends Claim>
    implements $ClaimCopyWith<$Res> {
  _$ClaimCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Claim
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackingCode = null,
    Object? direction = null,
    Object? cause = null,
    Object? description = null,
    Object? status = null,
    Object? photos = null,
    Object? resolutionPhotos = null,
    Object? createdAt = null,
    Object? reviewStartedAt = freezed,
    Object? closedAt = freezed,
    Object? history = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trackingCode: null == trackingCode
          ? _value.trackingCode
          : trackingCode // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as ClaimDirection,
      cause: null == cause
          ? _value.cause
          : cause // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ClaimStatus,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      resolutionPhotos: null == resolutionPhotos
          ? _value.resolutionPhotos
          : resolutionPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewStartedAt: freezed == reviewStartedAt
          ? _value.reviewStartedAt
          : reviewStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<ClaimTransition>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClaimImplCopyWith<$Res> implements $ClaimCopyWith<$Res> {
  factory _$$ClaimImplCopyWith(
          _$ClaimImpl value, $Res Function(_$ClaimImpl) then) =
      __$$ClaimImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String trackingCode,
      ClaimDirection direction,
      String cause,
      String description,
      ClaimStatus status,
      List<String> photos,
      List<String> resolutionPhotos,
      DateTime createdAt,
      DateTime? reviewStartedAt,
      DateTime? closedAt,
      List<ClaimTransition> history});
}

/// @nodoc
class __$$ClaimImplCopyWithImpl<$Res>
    extends _$ClaimCopyWithImpl<$Res, _$ClaimImpl>
    implements _$$ClaimImplCopyWith<$Res> {
  __$$ClaimImplCopyWithImpl(
      _$ClaimImpl _value, $Res Function(_$ClaimImpl) _then)
      : super(_value, _then);

  /// Create a copy of Claim
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackingCode = null,
    Object? direction = null,
    Object? cause = null,
    Object? description = null,
    Object? status = null,
    Object? photos = null,
    Object? resolutionPhotos = null,
    Object? createdAt = null,
    Object? reviewStartedAt = freezed,
    Object? closedAt = freezed,
    Object? history = null,
  }) {
    return _then(_$ClaimImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trackingCode: null == trackingCode
          ? _value.trackingCode
          : trackingCode // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as ClaimDirection,
      cause: null == cause
          ? _value.cause
          : cause // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ClaimStatus,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      resolutionPhotos: null == resolutionPhotos
          ? _value._resolutionPhotos
          : resolutionPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewStartedAt: freezed == reviewStartedAt
          ? _value.reviewStartedAt
          : reviewStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<ClaimTransition>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ClaimImpl extends _Claim {
  const _$ClaimImpl(
      {required this.id,
      required this.trackingCode,
      required this.direction,
      required this.cause,
      required this.description,
      this.status = ClaimStatus.creado,
      final List<String> photos = const [],
      final List<String> resolutionPhotos = const [],
      required this.createdAt,
      this.reviewStartedAt,
      this.closedAt,
      final List<ClaimTransition> history = const []})
      : _photos = photos,
        _resolutionPhotos = resolutionPhotos,
        _history = history,
        super._();

  factory _$ClaimImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClaimImplFromJson(json);

  /// Identificador interno (uuid de la capa de persistencia).
  @override
  final String id;

  /// Código de seguimiento único y legible ([ClaimTrackingCode]).
  @override
  final String trackingCode;

  /// Dirección del reclamo.
  @override
  final ClaimDirection direction;

  /// Causa del catálogo correspondiente a [direction].
  @override
  final String cause;

  /// Descripción del problema.
  @override
  final String description;

  /// Estado actual de la máquina.
  @override
  @JsonKey()
  final ClaimStatus status;

  /// Fotos adjuntadas al crear (obligatorias).
  final List<String> _photos;

  /// Fotos adjuntadas al crear (obligatorias).
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  /// Evidencia fotográfica de la reparación (obligatoria al resolver).
  final List<String> _resolutionPhotos;

  /// Evidencia fotográfica de la reparación (obligatoria al resolver).
  @override
  @JsonKey()
  List<String> get resolutionPhotos {
    if (_resolutionPhotos is EqualUnmodifiableListView)
      return _resolutionPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resolutionPhotos);
  }

  /// Creación del reclamo.
  @override
  final DateTime createdAt;

  /// Inicio de EN_REVISION (contraparte notificada). Base del plazo.
  @override
  final DateTime? reviewStartedAt;

  /// Cierre (RESUELTO o CALIFICACION_NEGATIVA).
  @override
  final DateTime? closedAt;

  /// Historial de transiciones aplicadas, en orden.
  final List<ClaimTransition> _history;

  /// Historial de transiciones aplicadas, en orden.
  @override
  @JsonKey()
  List<ClaimTransition> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'Claim(id: $id, trackingCode: $trackingCode, direction: $direction, cause: $cause, description: $description, status: $status, photos: $photos, resolutionPhotos: $resolutionPhotos, createdAt: $createdAt, reviewStartedAt: $reviewStartedAt, closedAt: $closedAt, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClaimImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trackingCode, trackingCode) ||
                other.trackingCode == trackingCode) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.cause, cause) || other.cause == cause) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality()
                .equals(other._resolutionPhotos, _resolutionPhotos) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reviewStartedAt, reviewStartedAt) ||
                other.reviewStartedAt == reviewStartedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      trackingCode,
      direction,
      cause,
      description,
      status,
      const DeepCollectionEquality().hash(_photos),
      const DeepCollectionEquality().hash(_resolutionPhotos),
      createdAt,
      reviewStartedAt,
      closedAt,
      const DeepCollectionEquality().hash(_history));

  /// Create a copy of Claim
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClaimImplCopyWith<_$ClaimImpl> get copyWith =>
      __$$ClaimImplCopyWithImpl<_$ClaimImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClaimImplToJson(
      this,
    );
  }
}

abstract class _Claim extends Claim {
  const factory _Claim(
      {required final String id,
      required final String trackingCode,
      required final ClaimDirection direction,
      required final String cause,
      required final String description,
      final ClaimStatus status,
      final List<String> photos,
      final List<String> resolutionPhotos,
      required final DateTime createdAt,
      final DateTime? reviewStartedAt,
      final DateTime? closedAt,
      final List<ClaimTransition> history}) = _$ClaimImpl;
  const _Claim._() : super._();

  factory _Claim.fromJson(Map<String, dynamic> json) = _$ClaimImpl.fromJson;

  /// Identificador interno (uuid de la capa de persistencia).
  @override
  String get id;

  /// Código de seguimiento único y legible ([ClaimTrackingCode]).
  @override
  String get trackingCode;

  /// Dirección del reclamo.
  @override
  ClaimDirection get direction;

  /// Causa del catálogo correspondiente a [direction].
  @override
  String get cause;

  /// Descripción del problema.
  @override
  String get description;

  /// Estado actual de la máquina.
  @override
  ClaimStatus get status;

  /// Fotos adjuntadas al crear (obligatorias).
  @override
  List<String> get photos;

  /// Evidencia fotográfica de la reparación (obligatoria al resolver).
  @override
  List<String> get resolutionPhotos;

  /// Creación del reclamo.
  @override
  DateTime get createdAt;

  /// Inicio de EN_REVISION (contraparte notificada). Base del plazo.
  @override
  DateTime? get reviewStartedAt;

  /// Cierre (RESUELTO o CALIFICACION_NEGATIVA).
  @override
  DateTime? get closedAt;

  /// Historial de transiciones aplicadas, en orden.
  @override
  List<ClaimTransition> get history;

  /// Create a copy of Claim
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClaimImplCopyWith<_$ClaimImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
