import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/recording_entity.dart';
import '../data_source/recording_remote_data_source.dart';
import '../mappers/recording_mapper.dart';

final recordingRepositoryProvider = Provider<RecordingRepository>((ref) {
  return RecordingRepositoryImpl(ref.watch(recordRemoteDataSourceProvider));
});

abstract class RecordingRepository {
  Future<Either<Exception, List<RecordingEntity>>> getRecordings();
  Future<Either<Exception, void>> uploadRecording(RecordingEntity recording);
}

class RecordingRepositoryImpl implements RecordingRepository {
  final RecordRemoteDataSource _recordRemoteDataSource;

  RecordingRepositoryImpl(this._recordRemoteDataSource);

  @override
  Future<Either<Exception, List<RecordingEntity>>> getRecordings() async {
    try {
      final recordingModels = await _recordRemoteDataSource.getRecordings();
      final recordings = recordingModels.map(RecordingMapper.toEntity).toList();
      return Right(recordings);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, void>> uploadRecording(
      RecordingEntity recording) async {
    try {
      final recordingModel = RecordingMapper.toModel(recording);
      await _recordRemoteDataSource.uploadRecording(recordingModel);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e));
    }
  }
}
