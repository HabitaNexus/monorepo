// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_dispute_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DisputeDistributionImpl _$$DisputeDistributionImplFromJson(
        Map<String, dynamic> json) =>
    _$DisputeDistributionImpl(
      address: json['address'] as String,
      amount: json['amount'] as num,
    );

Map<String, dynamic> _$$DisputeDistributionImplToJson(
        _$DisputeDistributionImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'amount': instance.amount,
    };

_$ResolveDisputePayloadImpl _$$ResolveDisputePayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$ResolveDisputePayloadImpl(
      contractId: json['contractId'] as String,
      disputeResolver: json['disputeResolver'] as String,
      distributions: (json['distributions'] as List<dynamic>)
          .map((e) => DisputeDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ResolveDisputePayloadImplToJson(
        _$ResolveDisputePayloadImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'disputeResolver': instance.disputeResolver,
      'distributions': instance.distributions.map((e) => e.toJson()).toList(),
    };
