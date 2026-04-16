// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_release_milestone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MultiReleaseMilestoneImpl _$$MultiReleaseMilestoneImplFromJson(
        Map<String, dynamic> json) =>
    _$MultiReleaseMilestoneImpl(
      description: json['description'] as String,
      amount: (json['amount'] as num).toInt(),
      status: json['status'] as String? ?? 'pending',
      approvedFlag: json['approvedFlag'] as bool? ?? false,
      evidence: json['evidence'] as String?,
      disputeStartedBy: json['disputeStartedBy'] == null
          ? null
          : Role.fromJson(json['disputeStartedBy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MultiReleaseMilestoneImplToJson(
        _$MultiReleaseMilestoneImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'amount': instance.amount,
      'status': instance.status,
      'approvedFlag': instance.approvedFlag,
      'evidence': instance.evidence,
      'disputeStartedBy': instance.disputeStartedBy?.toJson(),
    };
