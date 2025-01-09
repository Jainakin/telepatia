import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data_source/auth_remote_data_source.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(authRemoteDataSourceProvider));
});

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<Either<Exception, User?>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Right(user);
    } catch (e) {
      return Left(Exception('Failed to sign in with Google: $e'));
    }
  }

  Future<void> signOut() => _remoteDataSource.signOut();
}
