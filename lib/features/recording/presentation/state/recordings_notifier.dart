import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../common/domain/use_case/usecase.dart';
import '../../domain/entities/recording_entity.dart';
import '../../domain/use_cases/get_recordings_usecase.dart';
import '../../domain/use_cases/make_firestore_doc_use_case.dart';
import '../../domain/use_cases/update_firestore_doc_use_case.dart';
import '../../domain/use_cases/upload_recording_usecase.dart';
import 'recording_state.dart';

final recordingsNotifierProvider =
    StateNotifierProvider<RecordingsNotifier, RecordingState>((ref) {
  return RecordingsNotifier(
    ref.watch(getRecordingsUseCaseProvider),
    ref.watch(uploadRecordingUseCaseProvider),
    ref.watch(makeFirestoreDocUseCaseProvider),
    ref.watch(updateFirestoreDocUseCaseProvider),
  );
});

class RecordingsNotifier extends StateNotifier<RecordingState> {
  final GetRecordingsUseCase _getRecordingsUseCase;
  final UploadRecordingUseCase _uploadRecordingUseCase;
  final MakeFirestoreDocUseCase _makeFirestoreDocUseCase;
  final UpdateFirestoreDocUseCase _updateFirestoreDocUseCase;

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<RecordingEntity> _recordings = [];
  String? _currentRecordingPath;
  String? _currentRecordingId;
  bool _isRecording = false;

  RecordingsNotifier(this._getRecordingsUseCase, this._uploadRecordingUseCase,
      this._makeFirestoreDocUseCase, this._updateFirestoreDocUseCase)
      : super(const RecordingState.initial());

  Future<void> getRecordings() async {
    state = const RecordingState.loading();
    final failureOrRecordings = await _getRecordingsUseCase(NoParams());
    failureOrRecordings.fold(
      (failure) => state = RecordingState.error(failure),
      (recordings) {
        _recordings = recordings.reversed.toList();
        print('recordings length: ${_recordings.length}');
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

      _currentRecordingPath = filePath;
      state = const RecordingState.success([]);
    } catch (e) {
      state = RecordingState.error(Exception('Error while recording: $e'));
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      _isRecording = false;
      if (_currentRecordingPath != null) {
        state = RecordingState.success(_recordings);
        // await uploadRecording();
      }

      await uploadRecording();
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
    if (_currentRecordingPath != null) {
      final failureOrDocId = await _makeFirestoreDocUseCase(NoParams());
      failureOrDocId
          .fold((failure) => state = RecordingState.uploadError(failure),
              (docId) async {
        final failureOrUploadTask = await _uploadRecordingUseCase(
          {'path': _currentRecordingPath!, 'docId': docId},
        );

        failureOrUploadTask.fold(
          (failure) => state = RecordingState.uploadError(failure),
          (uploadTask) {
            state = const RecordingState.uploading(progress: 0.0);
            uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
              switch (taskSnapshot.state) {
                case TaskState.running:
                  print('Upload is running');
                  if (taskSnapshot.bytesTransferred == 0 &&
                      taskSnapshot.totalBytes == 0) {
                    state = const RecordingState.uploading(progress: 0.0);
                  } else {
                    final progress = 100.0 *
                        (taskSnapshot.bytesTransferred /
                            taskSnapshot.totalBytes);
                    print("Upload is $progress% complete.");
                    state =
                        RecordingState.uploading(progress: progress / 100.0);

                    if (progress == 100.0) {
                      // update firestore doc
                      await _updateFirestoreDocUseCase.call(docId);
                    }

                    // get recordings
                    await getRecordings();
                  }
                  break;
                case TaskState.paused:
                  print("Upload is paused.");
                  break;
                case TaskState.canceled:
                  print("Upload was canceled");
                  state = RecordingState.uploadError(
                      Exception('Upload was canceled'));
                  break;
                case TaskState.error:
                  print("Upload failed.");
                  state =
                      RecordingState.uploadError(Exception('Upload failed'));
                  break;
                case TaskState.success:
                  print("Upload completed successfully.");
                  state = const RecordingState.uploadSuccess();
                  break;
              }
            });
          },
        );
      });
    }
  }

  Future<void> playRecording(RecordingEntity recording) async {
    await _audioPlayer.setUrl(recording.downloadUrl!);
    await _audioPlayer.play();
  }

  bool get isRecording => _isRecording;

  String? get currentRecordingPath => _currentRecordingPath;

  List<RecordingEntity> get recordings => _recordings;
}
