import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/core/error/exception.dart';
import 'package:fitness/core/utlis/back_end_points.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthServices {
  Future<void> deleteUser() async {
    await FirebaseAuth.instance.currentUser?.delete();
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      log(
        'execption on firebaseAuthServerce.createUserWithEmailAndPassword. ${e.toString()}and code is ${e.code}',
      );
      if (e.code == 'weak-password') {
        throw CustomException(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(
          message: 'The account already exists for that email.',
        );
      } else if (e.code == 'network-request-failed') {
        throw CustomException(
          message: 'Please check your internet connection.',
        );
      } else {
        throw CustomException(message: 'An unknown error occurred.');
      }
    } catch (e) {
      log(
        'execption on firebaseAuthServerce.createUserWithEmailAndPassword. ${e.toString()}',
      );
      throw CustomException(message: 'An unknown error occurred.');
    }
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      log(
        'execption on firebaseAuthServerce.signInWithEmailAndPassword. ${e.toString()}and code is ${e.code}',
      );
      if (e.code == 'user-not-found') {
        throw CustomException(message: 'email or password is not correct.');
      } else if (e.code == 'wrong-password') {
        throw CustomException(message: 'email or password is not correct.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException(
          message: 'Please check your internet connection.',
        );
      } else {
        // here is the problem from firebase console not shown the real error when
        //i use the email and password that not exist in firebase console
        throw CustomException(message: 'email or password is not correct.');
      }
    } catch (e) {
      log(
        'execption on firebaseAuthServerce.signInWithEmailAndPassword. ${e.toString()}',
      );
      throw CustomException(message: 'email or password is not correct.');
    }
  }

  // Future<User> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   return (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
  // }

  Future<User> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Once signed in, return the UserCredential
    return (await FirebaseAuth.instance.signInWithCredential(
      facebookAuthCredential,
    )).user!;
  }

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    // await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> reauthenticate({
    required String email,
    required String password,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    required String name,
    required String email,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in.',
      );
    }

    if (user.email != email) {
      await user.verifyBeforeUpdateEmail(email);
    }

    if (newPassword.isNotEmpty) {
      await user.updatePassword(newPassword);
    }

    await user.updateDisplayName(name);

    // Update Firestore
    await FirebaseFirestore.instance
        .collection(BackendPoints.addUserData)
        .doc(uid)
        .update({"name": name, "email": email});
  }
}
