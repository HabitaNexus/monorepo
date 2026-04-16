// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_funds_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReleaseFundsPayloadImpl _$$ReleaseFundsPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$ReleaseFundsPayloadImpl(
      contractId: json['contractId'] as String,
      releaseSigner: json['releaseSigner'] as String,
    );

Map<String, dynamic> _$$ReleaseFundsPayloadImplToJson(
        _$ReleaseFundsPayloadImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'releaseSigner': instance.releaseSigner,
    };
