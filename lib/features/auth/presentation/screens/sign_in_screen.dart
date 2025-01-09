import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telepatia/features/recording/presentation/screens/record_screen.dart';
import '../state/auth_notifier.dart';
import '../state/auth_state.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      )) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RecordScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: authState.when(
          initial: () => _buildSignInButton(ref),
          loading: () => const CircularProgressIndicator(),
          authenticated: (user) => Text(
            'Welcome, ${user.displayName}',
            style: const TextStyle(color: Colors.white),
          ),
          unauthenticated: () => _buildSignInButton(ref),
          error: (exception) => Text(
            'Error: ${exception.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(WidgetRef ref) {
    return CupertinoButton(
      color: Colors.white,
      onPressed: () {
        ref.read(authNotifierProvider.notifier).signInWithGoogle();
      },
      child: const Text('Sign in with Google'),
    );
  }
}
