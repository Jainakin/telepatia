import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'dart:math';

import '../../../../common/domain/use_case/usecase.dart';
import '../../domain/entities/recording_entity.dart';
import '../../domain/use_cases/get_recordings_usecase.dart';
// import '../../domain/use_cases/upload_recording_usecase.dart';
import 'recording_state.dart';

final recordingsNotifierProvider =
    StateNotifierProvider<RecordingsNotifier, RecordingState>((ref) {
  return RecordingsNotifier(
    ref.watch(getRecordingsUseCaseProvider),
    // ref.watch(uploadRecordingUseCaseProvider),
  );
});

class RecordingsNotifier extends StateNotifier<RecordingState> {
  final GetRecordingsUseCase _getRecordingsUseCase;
  // final UploadRecordingUseCase _uploadRecordingUseCase;
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<RecordingEntity> _recordings = [];
  RecordingEntity? _currentRecording;
  bool _isRecording = false;
  RecordingsNotifier(
    this._getRecordingsUseCase,
    // this._uploadRecordingUseCase
  ) : super(const RecordingState.initial());

  Future<void> getRecordings() async {
    state = const RecordingState.loading();
    final failureOrRecordings = await _getRecordingsUseCase(NoParams());
    failureOrRecordings.fold(
      (failure) => state = RecordingState.error(failure),
      (recordings) {
        _recordings = recordings;
        state = RecordingState.success(_recordings);
      },
    );
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
      growable: false,
    ).join();
  }

  Future<void> _startRecording() async {
    try {
      state = const RecordingState.loading();
      _isRecording = true;
      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${_generateRandomId()}.wav');

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: filePath,
      );

      _currentRecording =
          RecordingEntity(id: _generateRandomId(), path: filePath);
      state = const RecordingState.success([]);
    } catch (e) {
      state = RecordingState.error(Exception('Error while recording: $e'));
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      _isRecording = false;
      if (_currentRecording != null) {
        _recordings.add(_currentRecording!);
        state = RecordingState.success(_recordings);
        await uploadRecording();
      }
    } catch (e) {
      state =
          RecordingState.error(Exception('Error while stopping recording: $e'));
    }
  }

  Future<void> record() async {
    if (await _audioRecorder.isRecording()) {
      await _stopRecording();
    } else {
      if (await _audioRecorder.hasPermission()) {
        await _startRecording();
      } else {
        throw Exception('Recording permission not granted');
      }
    }
  }

  Future<void> uploadRecording() async {
    if (_currentRecording != null) {
      // state = const RecordingState.uploading();
      // final result = await _uploadRecordingUseCase(_currentRecording!);
      // result.fold(
      //   (failure) => state = RecordingState.uploadError(failure),
      //   (_) => state = const RecordingState.uploadSuccess(),
      // );
    }
  }

  Future<void> playRecording(String path) async {
    await _audioPlayer.setFilePath(path);
    await _audioPlayer.play();
  }

  bool get isRecording => _isRecording;

  RecordingEntity? get currentRecording => _currentRecording;
}
