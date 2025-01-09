import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/domain/use_case/usecase.dart';
import '../../data/repositories/recording_repository.dart';

final updateFirestoreDocUseCaseProvider =
    Provider<UpdateFirestoreDocUseCase>((ref) {
  return UpdateFirestoreDocUseCase(ref.watch(recordingRepositoryProvider));
});

class UpdateFirestoreDocUseCase extends UseCase<void, String> {
  final RecordingRepository _recordingRepository;

  UpdateFirestoreDocUseCase(this._recordingRepository);

  @override
  Future<Either<Exception, void>> call(String docId) async {
    final failureOrVoid = await _recordingRepository.updateFirestoreDoc(docId);
    return failureOrVoid;
  }
}
