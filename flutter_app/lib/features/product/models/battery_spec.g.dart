// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatterySpec _$BatterySpecFromJson(Map<String, dynamic> json) => _BatterySpec(
  voltage: json['voltage'] as num,
  ampere_hour: json['ampere_hour'] as num,
  cca: json['cca'] as num,
  battery_type: json['battery_type'] as String,
  terminal_position: json['terminal_position'] as String,
  size_code: json['size_code'] as String,
);

Map<String, dynamic> _$BatterySpecToJson(_BatterySpec instance) =>
    <String, dynamic>{
      'voltage': instance.voltage,
      'ampere_hour': instance.ampere_hour,
      'cca': instance.cca,
      'battery_type': instance.battery_type,
      'terminal_position': instance.terminal_position,
      'size_code': instance.size_code,
    };
