// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_release_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MultiReleaseContractImpl _$$MultiReleaseContractImplFromJson(
        Map<String, dynamic> json) =>
    _$MultiReleaseContractImpl(
      signer: json['signer'] as String,
      engagementId: json['engagementId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      platformFee: (json['platformFee'] as num).toDouble(),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      trustline: (json['trustline'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$MultiReleaseContractImplToJson(
        _$MultiReleaseContractImpl instance) =>
    <String, dynamic>{
      'signer': instance.signer,
      'engagementId': instance.engagementId,
      'title': instance.title,
      'description': instance.description,
      'platformFee': instance.platformFee,
      'roles': instance.roles,
      'milestones': instance.milestones,
      'trustline': instance.trustline,
    };
