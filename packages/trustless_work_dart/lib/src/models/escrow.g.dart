// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escrow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EscrowImpl _$$EscrowImplFromJson(Map<String, dynamic> json) => _$EscrowImpl(
      contractId: json['contractId'] as String,
      engagementId: json['engagementId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toInt(),
      platformFee: (json['platformFee'] as num).toDouble(),
      receiverMemo: (json['receiverMemo'] as num).toInt(),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => Milestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      trustline: Trustline.fromJson(json['trustline'] as Map<String, dynamic>),
      flags: Flags.fromJson(json['flags'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$EscrowImplToJson(_$EscrowImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'engagementId': instance.engagementId,
      'title': instance.title,
      'description': instance.description,
      'amount': instance.amount,
      'platformFee': instance.platformFee,
      'receiverMemo': instance.receiverMemo,
      'roles': instance.roles.map((e) => e.toJson()).toList(),
      'milestones': instance.milestones.map((e) => e.toJson()).toList(),
      'trustline': instance.trustline.toJson(),
      'flags': instance.flags.toJson(),
      'isActive': instance.isActive,
    };
