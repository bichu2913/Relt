import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacebookLoginScreen {
  Future<void> loginWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();

      // Handle the Facebook login result
      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken!.token);

        // Sign in with Firebase using the Facebook access token
        final UserCredential firebaseResult =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Access the signed-in user's information
        final User? user = firebaseResult.user;
        if (user != null) {
          // Add user details to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'facebookId': user.uid,
            'role': 'regular',
          });

          print('Logged in with Facebook! User ID: ${user.uid}');
        } else {
          print('Failed to sign in with Facebook.');
        }
      } else {
        print('Facebook login failed');
      }
    } catch (e) {
      print('Error logging in with Facebook: $e');
    }
  }
}

      
