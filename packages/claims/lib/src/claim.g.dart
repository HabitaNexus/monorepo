// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClaimTransitionImpl _$$ClaimTransitionImplFromJson(
        Map<String, dynamic> json) =>
    _$ClaimTransitionImpl(
      from: $enumDecode(_$ClaimStatusEnumMap, json['from']),
      to: $enumDecode(_$ClaimStatusEnumMap, json['to']),
      at: DateTime.parse(json['at'] as String),
      actor: $enumDecode(_$ClaimActorEnumMap, json['actor']),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$ClaimTransitionImplToJson(
        _$ClaimTransitionImpl instance) =>
    <String, dynamic>{
      'from': _$ClaimStatusEnumMap[instance.from]!,
      'to': _$ClaimStatusEnumMap[instance.to]!,
      'at': instance.at.toIso8601String(),
      'actor': _$ClaimActorEnumMap[instance.actor]!,
      'reason': instance.reason,
    };

const _$ClaimStatusEnumMap = {
  ClaimStatus.creado: 'creado',
  ClaimStatus.enRevision: 'enRevision',
  ClaimStatus.aceptado: 'aceptado',
  ClaimStatus.disputado: 'disputado',
  ClaimStatus.mediacion: 'mediacion',
  ClaimStatus.escalado: 'escalado',
  ClaimStatus.resuelto: 'resuelto',
  ClaimStatus.calificacionNegativa: 'calificacionNegativa',
};

const _$ClaimActorEnumMap = {
  ClaimActor.reclamante: 'reclamante',
  ClaimActor.contraparte: 'contraparte',
  ClaimActor.sistema: 'sistema',
  ClaimActor.mediador: 'mediador',
};

_$ClaimImpl _$$ClaimImplFromJson(Map<String, dynamic> json) => _$ClaimImpl(
      id: json['id'] as String,
      trackingCode: json['trackingCode'] as String,
      direction: $enumDecode(_$ClaimDirectionEnumMap, json['direction']),
      cause: json['cause'] as String,
      description: json['description'] as String,
      status: $enumDecodeNullable(_$ClaimStatusEnumMap, json['status']) ??
          ClaimStatus.creado,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      resolutionPhotos: (json['resolutionPhotos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewStartedAt: json['reviewStartedAt'] == null
          ? null
          : DateTime.parse(json['reviewStartedAt'] as String),
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => ClaimTransition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ClaimImplToJson(_$ClaimImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trackingCode': instance.trackingCode,
      'direction': _$ClaimDirectionEnumMap[instance.direction]!,
      'cause': instance.cause,
      'description': instance.description,
      'status': _$ClaimStatusEnumMap[instance.status]!,
      'photos': instance.photos,
      'resolutionPhotos': instance.resolutionPhotos,
      'createdAt': instance.createdAt.toIso8601String(),
      'reviewStartedAt': instance.reviewStartedAt?.toIso8601String(),
      'closedAt': instance.closedAt?.toIso8601String(),
      'history': instance.history.map((e) => e.toJson()).toList(),
    };

const _$ClaimDirectionEnumMap = {
  ClaimDirection.inquilinoAPropietario: 'inquilinoAPropietario',
  ClaimDirection.propietarioAInquilino: 'propietarioAInquilino',
};
