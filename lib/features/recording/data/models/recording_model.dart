import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_model.g.dart';

@JsonSerializable()
class RecordingModel {
  final String id;
  final int? size;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdAt;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? updatedAt;

  final String? type;

  final String? downloadUrl;

  RecordingModel({
    required this.id,
    this.size,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.downloadUrl,
  });

  factory RecordingModel.fromJson(Map<String, dynamic> json) =>
      _$RecordingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecordingModelToJson(this);

  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    }
    return null;
  }

  static dynamic _dateTimeToJson(DateTime? date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
  }
}
