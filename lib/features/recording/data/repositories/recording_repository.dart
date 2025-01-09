import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/recording_entity.dart';
import '../data_source/recording_remote_data_source.dart';
import '../mappers/recording_mapper.dart';

final recordingRepositoryProvider = Provider<RecordingRepository>((ref) {
  return RecordingRepositoryImpl(ref.watch(recordRemoteDataSourceProvider));
});

abstract class RecordingRepository {
  Future<Either<Exception, List<RecordingEntity>>> getRecordings();
  Future<Either<Exception, UploadTask>> uploadRecording(
      String path, String docId);
  Future<Either<Exception, String>> makeFirestoreDoc();
  Future<Either<Exception, void>> updateFirestoreDoc(String docId);
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
  Future<Either<Exception, UploadTask>> uploadRecording(
      String path, String docId) async {
    try {
      final uploadTask =
          await _recordRemoteDataSource.uploadRecording(path, docId);
      return Right(uploadTask);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, String>> makeFirestoreDoc() async {
    try {
      final docId = await _recordRemoteDataSource.makeFirestoreDoc();
      return Right(docId);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<Either<Exception, void>> updateFirestoreDoc(String docId) async {
    try {
      await _recordRemoteDataSource.updateFirestoreDoc(docId);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e));
    }
  }
}
