// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trustline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrustlineImpl _$$TrustlineImplFromJson(Map<String, dynamic> json) =>
    _$TrustlineImpl(
      address: json['address'] as String,
      name: json['name'] as String,
      decimals: (json['decimals'] as num).toInt(),
    );

Map<String, dynamic> _$$TrustlineImplToJson(_$TrustlineImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'name': instance.name,
      'decimals': instance.decimals,
    };
