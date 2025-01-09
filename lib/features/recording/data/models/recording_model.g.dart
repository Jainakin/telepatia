// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordingModel _$RecordingModelFromJson(Map<String, dynamic> json) =>
    RecordingModel(
      id: json['id'] as String,
      size: (json['size'] as num?)?.toInt(),
      createdAt: RecordingModel._dateTimeFromJson(json['createdAt']),
      updatedAt: RecordingModel._dateTimeFromJson(json['updatedAt']),
      type: json['type'] as String?,
      downloadUrl: json['downloadUrl'] as String?,
    );

Map<String, dynamic> _$RecordingModelToJson(RecordingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'size': instance.size,
      'createdAt': RecordingModel._dateTimeToJson(instance.createdAt),
      'updatedAt': RecordingModel._dateTimeToJson(instance.updatedAt),
      'type': instance.type,
      'downloadUrl': instance.downloadUrl,
    };
