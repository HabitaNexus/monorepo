// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_dispute_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StartDisputePayloadImpl _$$StartDisputePayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$StartDisputePayloadImpl(
      contractId: json['contractId'] as String,
      signer: json['signer'] as String,
    );

Map<String, dynamic> _$$StartDisputePayloadImplToJson(
        _$StartDisputePayloadImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'signer': instance.signer,
    };
