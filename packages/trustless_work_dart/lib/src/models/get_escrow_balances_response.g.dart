// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_escrow_balances_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetEscrowBalancesResponseImpl _$$GetEscrowBalancesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetEscrowBalancesResponseImpl(
      balances: (json['balances'] as List<dynamic>)
          .map((e) => EscrowBalanceEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetEscrowBalancesResponseImplToJson(
        _$GetEscrowBalancesResponseImpl instance) =>
    <String, dynamic>{
      'balances': instance.balances.map((e) => e.toJson()).toList(),
    };

_$EscrowBalanceEntryImpl _$$EscrowBalanceEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$EscrowBalanceEntryImpl(
      address: json['address'] as String,
      balance: json['balance'] as num,
    );

Map<String, dynamic> _$$EscrowBalanceEntryImplToJson(
        _$EscrowBalanceEntryImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'balance': instance.balance,
    };
