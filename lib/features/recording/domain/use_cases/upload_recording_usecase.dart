import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/domain/use_case/usecase.dart';
import '../../data/repositories/recording_repository.dart';

final uploadRecordingUseCaseProvider = Provider<UploadRecordingUseCase>((ref) {
  return UploadRecordingUseCase(ref.watch(recordingRepositoryProvider));
});

class UploadRecordingUseCase extends UseCase<void, Map<String, dynamic>> {
  final RecordingRepository _recordingRepository;

  UploadRecordingUseCase(this._recordingRepository);

  @override
  Future<Either<Exception, UploadTask>> call(Map<String, dynamic> args) async {
    final failureOrUploadTask =
        await _recordingRepository.uploadRecording(args['path'], args['docId']);
    return failureOrUploadTask.fold(
      (failure) => Left(failure),
      (uploadTask) => Right(uploadTask),
    );
  }
}
