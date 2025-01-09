import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/domain/use_case/usecase.dart';
import '../../data/repositories/recording_repository.dart';

final makeFirestoreDocUseCaseProvider =
    Provider<MakeFirestoreDocUseCase>((ref) {
  return MakeFirestoreDocUseCase(ref.watch(recordingRepositoryProvider));
});

class MakeFirestoreDocUseCase extends UseCase<String, void> {
  final RecordingRepository _recordingRepository;

  MakeFirestoreDocUseCase(this._recordingRepository);

  @override
  Future<Either<Exception, String>> call(void args) async {
    final failureOrDocId = await _recordingRepository.makeFirestoreDoc();
    return failureOrDocId.fold(
      (failure) => Left(failure),
      (docId) => Right(docId),
    );
  }
}
