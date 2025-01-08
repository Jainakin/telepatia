import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recording_model.dart';

final recordRemoteDataSourceProvider = Provider<RecordRemoteDataSource>((ref) {
  return RecordRemoteDataSource();
});

class RecordRemoteDataSource {
  Future<List<RecordingModel>> getRecordings() async {
    return [];
  }

  Future<void> uploadRecording(RecordingModel recording) async {
    return;
  }
}
