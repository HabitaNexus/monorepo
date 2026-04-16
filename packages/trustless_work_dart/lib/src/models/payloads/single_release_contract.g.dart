// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_release_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SingleReleaseContractImpl _$$SingleReleaseContractImplFromJson(
        Map<String, dynamic> json) =>
    _$SingleReleaseContractImpl(
      signer: json['signer'] as String,
      engagementId: json['engagementId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toInt(),
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

Map<String, dynamic> _$$SingleReleaseContractImplToJson(
        _$SingleReleaseContractImpl instance) =>
    <String, dynamic>{
      'signer': instance.signer,
      'engagementId': instance.engagementId,
      'title': instance.title,
      'description': instance.description,
      'amount': instance.amount,
      'platformFee': instance.platformFee,
      'roles': instance.roles,
      'milestones': instance.milestones,
      'trustline': instance.trustline,
    };
