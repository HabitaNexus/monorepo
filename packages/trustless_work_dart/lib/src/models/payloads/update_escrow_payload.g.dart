// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_escrow_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateEscrowPayloadImpl _$$UpdateEscrowPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateEscrowPayloadImpl(
      signer: json['signer'] as String,
      contractId: json['contractId'] as String,
      escrow: json['escrow'] as Map<String, dynamic>,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$$UpdateEscrowPayloadImplToJson(
        _$UpdateEscrowPayloadImpl instance) =>
    <String, dynamic>{
      'signer': instance.signer,
      'contractId': instance.contractId,
      'escrow': instance.escrow,
      if (instance.isActive case final value?) 'isActive': value,
    };
