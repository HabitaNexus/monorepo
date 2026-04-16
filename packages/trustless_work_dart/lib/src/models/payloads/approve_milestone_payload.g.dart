// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approve_milestone_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApproveMilestonePayloadImpl _$$ApproveMilestonePayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$ApproveMilestonePayloadImpl(
      contractId: json['contractId'] as String,
      milestoneIndex: json['milestoneIndex'] as String,
      approver: json['approver'] as String,
    );

Map<String, dynamic> _$$ApproveMilestonePayloadImplToJson(
        _$ApproveMilestonePayloadImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'milestoneIndex': instance.milestoneIndex,
      'approver': instance.approver,
    };
