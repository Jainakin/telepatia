import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/use_cases/sign_in_with_google_usecase.dart';
import 'auth_state.dart';
import 'firebase_auth_provider.dart';
import 'google_sign_in_provider.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(signInWithGoogleUseCaseProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthNotifier(
    this._signInWithGoogleUseCase, {
    required this.firebaseAuth,
    required this.googleSignIn,
  }) : super(const AuthState.initial()) {
    _init();
    _init();
  }

  void _init() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      state = AuthState.authenticated(currentUser);
    } else {
      state = const AuthState.unauthenticated();
    }
    firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      final failureOrUser = await _signInWithGoogleUseCase.call();
      failureOrUser.fold(
        (failure) => state = AuthState.error(failure),
        (user) => state = AuthState.authenticated(user!),
      );
    } catch (e) {
      state = AuthState.error(Exception('Error during Google sign-in: $e'));
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(Exception('Error during sign-out: $e'));
    }
  }
}
