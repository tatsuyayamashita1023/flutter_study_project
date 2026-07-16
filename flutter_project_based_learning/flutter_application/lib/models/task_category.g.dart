// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskCategoryImpl _$$TaskCategoryImplFromJson(Map<String, dynamic> json) =>
    _$TaskCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      colorValue: (json['colorValue'] as num).toInt(),
    );

Map<String, dynamic> _$$TaskCategoryImplToJson(_$TaskCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colorValue': instance.colorValue,
    };
