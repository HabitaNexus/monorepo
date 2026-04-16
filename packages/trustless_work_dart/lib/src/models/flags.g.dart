// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlagsImpl _$$FlagsImplFromJson(Map<String, dynamic> json) => _$FlagsImpl(
      approved: json['approved'] as bool? ?? false,
      disputed: json['disputed'] as bool? ?? false,
      released: json['released'] as bool? ?? false,
    );

Map<String, dynamic> _$$FlagsImplToJson(_$FlagsImpl instance) =>
    <String, dynamic>{
      'approved': instance.approved,
      'disputed': instance.disputed,
      'released': instance.released,
    };
