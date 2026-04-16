// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_release_escrow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MultiReleaseEscrowImpl _$$MultiReleaseEscrowImplFromJson(
        Map<String, dynamic> json) =>
    _$MultiReleaseEscrowImpl(
      contractId: json['contractId'] as String,
      engagementId: json['engagementId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      platformFee: (json['platformFee'] as num).toDouble(),
      receiverMemo: (json['receiverMemo'] as num).toInt(),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => MultiReleaseMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      trustline: Trustline.fromJson(json['trustline'] as Map<String, dynamic>),
      flags: Flags.fromJson(json['flags'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$MultiReleaseEscrowImplToJson(
        _$MultiReleaseEscrowImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'engagementId': instance.engagementId,
      'title': instance.title,
      'description': instance.description,
      'platformFee': instance.platformFee,
      'receiverMemo': instance.receiverMemo,
      'roles': instance.roles.map((e) => e.toJson()).toList(),
      'milestones': instance.milestones.map((e) => e.toJson()).toList(),
      'trustline': instance.trustline.toJson(),
      'flags': instance.flags.toJson(),
      'isActive': instance.isActive,
    };
