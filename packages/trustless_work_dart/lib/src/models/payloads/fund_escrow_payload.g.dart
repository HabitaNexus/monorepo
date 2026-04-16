// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_escrow_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FundEscrowPayloadImpl _$$FundEscrowPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$FundEscrowPayloadImpl(
      contractId: json['contractId'] as String,
      signer: json['signer'] as String,
      amount: json['amount'] as String,
    );

Map<String, dynamic> _$$FundEscrowPayloadImplToJson(
        _$FundEscrowPayloadImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'signer': instance.signer,
      'amount': instance.amount,
    };
