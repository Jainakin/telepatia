import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recording_model.dart';

final recordRemoteDataSourceProvider = Provider<RecordRemoteDataSource>((ref) {
  return RecordRemoteDataSource();
});

class RecordRemoteDataSource {
  Future<List<RecordingModel>> getRecordings() async {
    try {
      // get current user
      final currentUser = FirebaseAuth.instance.currentUser;

      // get user recordings collection
      final userRecordingsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('recordings');

      // get docs from user recordings collection
      final userRecordingsDocs = await userRecordingsRef.get();

      // convert docs to list of recordings
      final recordings = userRecordingsDocs.docs.map((doc) {
        return RecordingModel.fromJson(doc.data());
      }).toList();

      return recordings;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  Future<UploadTask> uploadRecording(String filePath, String docId) async {
    try {
      final file = File(filePath);
      final storageRef =
          FirebaseStorage.instance.ref().child('recordings/$docId.wav');
      return storageRef.putFile(file);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> makeFirestoreDoc() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final userRecordingsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('recordings');
      final recordingDoc = userRecordingsRef.doc();
      final docId = recordingDoc.id;
      await recordingDoc.set({
        'id': docId,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'type': 'wav',
        'downloadUrl': '',
      });
      return docId;
    } catch (e) {
      print('error making firestore doc: $e');
      throw Exception(e);
    }
  }

  Future<void> updateFirestoreDoc(String docId) async {
    try {
      print('updating firestore doc: $docId');
      final storageRef =
          FirebaseStorage.instance.ref().child('recordings/$docId.wav');
      final downloadUrl = await storageRef.getDownloadURL();

      final currentUser = FirebaseAuth.instance.currentUser;
      final userRecordingsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('recordings');
      final recordingDoc = userRecordingsRef.doc(docId);
      await recordingDoc.update({
        'downloadUrl': downloadUrl,
      });
    } catch (e) {
      print('error updating firestore doc: $e');
      throw Exception(e);
    }
  }
}
