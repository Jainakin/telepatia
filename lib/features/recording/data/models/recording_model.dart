import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_model.g.dart';

@JsonSerializable()
class RecordingModel {
  final String id;
  final String path;

  RecordingModel({
    required this.id,
    required this.path,
  });

  factory RecordingModel.fromJson(Map<String, dynamic> json) =>
      _$RecordingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecordingModelToJson(this);
}
