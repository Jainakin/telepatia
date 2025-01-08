import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/domain/use_case/usecase.dart';
import '../../data/repositories/recording_repository.dart';
import '../entities/recording_entity.dart';

final getRecordingsUseCaseProvider = Provider<GetRecordingsUseCase>((ref) {
  return GetRecordingsUseCase(ref.watch(recordingRepositoryProvider));
});

class GetRecordingsUseCase extends UseCase<List<RecordingEntity>, NoParams> {
  final RecordingRepository _recordingRepository;

  GetRecordingsUseCase(this._recordingRepository);

  @override
  Future<Either<Exception, List<RecordingEntity>>> call(NoParams params) async {
    final failureOrRecordings = await _recordingRepository.getRecordings();
    return failureOrRecordings.fold(
      (failure) => Left(failure),
      (recordings) => Right(recordings),
    );
  }
}
