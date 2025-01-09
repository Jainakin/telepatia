import '../../domain/entities/recording_entity.dart';
import '../models/recording_model.dart';

class RecordingMapper {
  static RecordingEntity toEntity(RecordingModel recording) {
    return RecordingEntity(
      id: recording.id,
      size: recording.size,
      createdAt: recording.createdAt,
      updatedAt: recording.updatedAt,
      type: recording.type,
      downloadUrl: recording.downloadUrl,
    );
  }

  // static RecordingModel toModel(RecordingEntity recording) {
  //   return RecordingModel(
  //     id: recording.id,
  //     size: recording.size,
  //     createdAt: recording.createdAt,
  //     updatedAt: recording.updatedAt,
  //     type: recording.type,
  //   );
  // }
}
