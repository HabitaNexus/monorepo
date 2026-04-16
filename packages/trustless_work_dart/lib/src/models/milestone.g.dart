// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MilestoneImpl _$$MilestoneImplFromJson(Map<String, dynamic> json) =>
    _$MilestoneImpl(
      description: json['description'] as String,
      status: json['status'] as String? ?? 'pending',
      approvedFlag: json['approvedFlag'] as bool? ?? false,
    );

Map<String, dynamic> _$$MilestoneImplToJson(_$MilestoneImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'status': instance.status,
      'approvedFlag': instance.approvedFlag,
    };
