import '../../domain/entities/recording_entity.dart';
import '../models/recording_model.dart';

class RecordingMapper {
  static RecordingEntity toEntity(RecordingModel recording) {
    return RecordingEntity(
      id: recording.id,
      path: recording.path,
    );
  }

  static RecordingModel toModel(RecordingEntity recording) {
    return RecordingModel(
      id: recording.id,
      path: recording.path,
    );
  }
}
