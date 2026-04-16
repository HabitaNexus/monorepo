// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_milestone_status_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChangeMilestoneStatusPayloadImpl _$$ChangeMilestoneStatusPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangeMilestoneStatusPayloadImpl(
      contractId: json['contractId'] as String,
      milestoneIndex: json['milestoneIndex'] as String,
      newEvidence: json['newEvidence'] as String,
      newStatus: json['newStatus'] as String,
      serviceProvider: json['serviceProvider'] as String,
    );

Map<String, dynamic> _$$ChangeMilestoneStatusPayloadImplToJson(
        _$ChangeMilestoneStatusPayloadImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'milestoneIndex': instance.milestoneIndex,
      'newEvidence': instance.newEvidence,
      'newStatus': instance.newStatus,
      'serviceProvider': instance.serviceProvider,
    };
