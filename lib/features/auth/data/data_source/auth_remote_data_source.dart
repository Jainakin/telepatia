import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telepatia/features/auth/presentation/state/firebase_auth_provider.dart';

import '../../presentation/state/google_sign_in_provider.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
      ref.read(firebaseAuthProvider), ref.read(googleSignInProvider));
});

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource(this._firebaseAuth, this._googleSignIn);

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;

      await addUserToFirestore(user!);

      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  Future<void> addUserToFirestore(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(user.uid).set({'uid': user.uid});
  }
}
