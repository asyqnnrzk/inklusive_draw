import 'package:InklusiveDraw/module/app_dashboard/dashboard_selector.dart';
import 'package:InklusiveDraw/module/mainpage/homepage.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/login/login_screen'
    '.dart';
import 'package:InklusiveDraw/repository/exceptions/sign_up_fail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../source/colors.dart';
import '../source/text_theme.dart';
import 'package:flutter/material.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _firestore = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const LoginScreen()) : Get.offAll(() =>
    const Homepage());
  }

  Future<void> registerUserWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User register: ${userCredential.user?.uid}');
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpFail.code(e.code);
      print('FIREBASE AUTH EXCEPTION: ${ex.message}');
      throw ex;
    } catch (e) {
      const ex = SignUpFail();
      print('EXCEPTION: ${ex.message}');
      throw ex;
    }
  }

  Future<void> loginUserWithEmailAndPassword(String email, String password)
  async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users')
            .doc(firebaseUser.uid).get();

        if (userDoc.exists) {
          bool isDeleted = userDoc.get('isDeleted') ?? false;

          if (isDeleted) {
            await logout();
            Get.snackbar(
              '',
              '',
              titleText: Text(
                'Account Disabled',
                style: LightTextTheme.snackbarBold,
              ),
              messageText: Text(
                'Your account has been disabled. Please contact support.',
                style: LightTextTheme.snackbarTxt,
              ),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: redButton,
              colorText: blackColor,
            );
            return;
          }

          // Update lastLoginDate
          await _firestore.collection('users').doc(firebaseUser.uid).update({
            'lastLoggedIn': Timestamp.now(),
          });

          Get.offAll(() => const DashboardSelector());
        } else {
          Get.snackbar(
            'Error',
            'User document does not exist in Firestore.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.offAll(() => const LoginScreen());
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpFail.code(e.code);
      print('FIREBASE AUTH EXCEPTION: ${ex.message}');
      throw ex;
    } catch (e) {
      const ex = SignUpFail();
      print('EXCEPTION: ${ex.message}');
      throw ex;
    }
  }

  Future<void> signInUserWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Get.offAll(() => const LoginScreen());
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential
        (credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users')
            .doc(firebaseUser.uid).get();

        if (userDoc.exists) {
          bool isDeleted = userDoc.get('isDeleted') ?? false;

          if (isDeleted) {
            await logout();
            Get.snackbar(
              '',
              '',
              titleText: Text(
                'Account Disabled',
                style: LightTextTheme.snackbarBold,
              ),
              messageText: Text(
                'Your account has been disabled. Please contact support.',
                style: LightTextTheme.snackbarTxt,
              ),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: redButton,
              colorText: blackColor,
            );
            return;
          }

          // Update lastLoginDate
          await _firestore.collection('users').doc(firebaseUser.uid).update({
            'lastLoggedIn': Timestamp.now(),
          });

          Get.offAll(() => const DashboardSelector());
        } else {
          Get.snackbar(
            '',
            '',
            titleText: Text(
              'Uh oh!',
              style: LightTextTheme.snackbarBold,
            ),
            messageText: Text(
              'Account does not exist, please register',
              style: LightTextTheme.snackbarTxt,
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redButton,
            colorText: blackColor,
          );
        }
      } else {
        Get.offAll(() => const LoginScreen());
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpFail.code(e.code);
      print('FIREBASE AUTH EXCEPTION: ${ex.message}');
      throw ex;
    } catch (e) {
      const ex = SignUpFail();
      print('EXCEPTION: ${ex.message}');
      throw ex;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}