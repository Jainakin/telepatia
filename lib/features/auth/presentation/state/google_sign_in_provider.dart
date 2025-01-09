import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});
