import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';

final signInWithGoogleUseCaseProvider =
    Provider<SignInWithGoogleUseCase>((ref) {
  return SignInWithGoogleUseCase(ref.read(authRepositoryProvider));
});

class SignInWithGoogleUseCase {
  final AuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  Future<Either<Exception, User?>> call() async {
    final failureOrUser = await _repository.signInWithGoogle();
    return failureOrUser.fold(
      (failure) => Left(failure),
      (user) => Right(user),
    );
  }
}
