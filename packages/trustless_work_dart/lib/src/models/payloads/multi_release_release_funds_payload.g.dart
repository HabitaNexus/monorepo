// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_release_release_funds_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MultiReleaseReleaseFundsPayloadImpl
    _$$MultiReleaseReleaseFundsPayloadImplFromJson(Map<String, dynamic> json) =>
        _$MultiReleaseReleaseFundsPayloadImpl(
          contractId: json['contractId'] as String,
          releaseSigner: json['releaseSigner'] as String,
          milestoneIndex: json['milestoneIndex'] as String,
        );

Map<String, dynamic> _$$MultiReleaseReleaseFundsPayloadImplToJson(
        _$MultiReleaseReleaseFundsPayloadImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'releaseSigner': instance.releaseSigner,
      'milestoneIndex': instance.milestoneIndex,
    };
