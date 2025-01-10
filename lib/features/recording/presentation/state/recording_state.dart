import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/recording_entity.dart';

part 'recording_state.freezed.dart';

@freezed
class RecordingState with _$RecordingState {
  const factory RecordingState.initial() = _Initial;
  const factory RecordingState.loading() = _Loading;
  const factory RecordingState.recording() = _Recording;
  const factory RecordingState.success(List<RecordingEntity> recordings) =
      _Success;
  const factory RecordingState.error(Exception exception) = _Error;

  const factory RecordingState.playing() = _Playing;
  const factory RecordingState.buffering() = _Buffering;
  const factory RecordingState.paused() = _Paused;
  const factory RecordingState.stopped() = _Stopped;

  const factory RecordingState.uploading({required double progress}) =
      _Uploading;
  const factory RecordingState.uploadSuccess() = _UploadSuccess;
  const factory RecordingState.uploadError(Exception exception) = _UploadError;
}
