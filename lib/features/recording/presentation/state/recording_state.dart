import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/recording_entity.dart';

part 'recording_state.freezed.dart';

@freezed
class RecordingState with _$RecordingState {
  const factory RecordingState.initial() = _Initial;
  const factory RecordingState.loading() = _Loading;
  const factory RecordingState.success(List<RecordingEntity> recordings) =
      _Success;
  const factory RecordingState.error(Exception exception) = _Error;

  const factory RecordingState.uploading() = _Uploading;
  const factory RecordingState.uploadSuccess() = _UploadSuccess;
  const factory RecordingState.uploadError(Exception exception) = _UploadError;
}
