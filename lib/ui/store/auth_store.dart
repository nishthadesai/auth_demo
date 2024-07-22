import 'package:authentication_demo/locator/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @observable
  String? errorMessage;
  @observable
  String? uid;
  @observable
  String? imageUrl;
  @observable
  String? fullName;
  @observable
  String? email;

  @action
  Future<User?> signInWithGoogle() async {
    await Firebase.initializeApp();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      if (user != null) {
        assert(!user.isAnonymous);

        final User currentUser = _auth.currentUser!;
        assert(user.uid == currentUser.uid);

        debugPrint('signInWithGoogle succeeded: $user');
        await googleSignIn.signOut();

        return user;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("G-SignIn error: $error");
      errorMessage = error.toString();
      return null;
    }
  }
}

final authStore = locator<AuthStore>();
