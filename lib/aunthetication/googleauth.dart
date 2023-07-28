import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Start the Google sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // Obtain the auth details from the Google sign-in
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential using the Google token
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase using the Google credential
         final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

         
        // Get the signed-in user
        final User? user = userCredential.user;

        if (user != null) {
          // Add user details to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.email).set({
            'email': user.email,
            'role': 'regular',
          });
        }
         return userCredential;
      }
    } catch (e) {
     [];
    }
    return null;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

