// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_release_resolve_dispute_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MultiReleaseResolveDisputePayloadImpl
    _$$MultiReleaseResolveDisputePayloadImplFromJson(
            Map<String, dynamic> json) =>
        _$MultiReleaseResolveDisputePayloadImpl(
          contractId: json['contractId'] as String,
          disputeResolver: json['disputeResolver'] as String,
          milestoneIndex: json['milestoneIndex'] as String,
          distributions: (json['distributions'] as List<dynamic>)
              .map((e) =>
                  DisputeDistribution.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$MultiReleaseResolveDisputePayloadImplToJson(
        _$MultiReleaseResolveDisputePayloadImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'disputeResolver': instance.disputeResolver,
      'milestoneIndex': instance.milestoneIndex,
      'distributions': instance.distributions.map((e) => e.toJson()).toList(),
    };
