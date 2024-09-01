import 'package:InklusiveDraw/module/app_dashboard/dashboard_selector.dart';
import 'package:InklusiveDraw/module/mainpage/homepage.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/login/login_screen'
    '.dart';
import 'package:InklusiveDraw/repository/exceptions/sign_up_fail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final _db = FirebaseFirestore.instance;

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

  Future<String> getImageUrl(String imagePath) async {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    final url = await ref.getDownloadURL();
    return url;
  }

  // Create a profile subcollection for the user
  Future<void> _createUserProfile(String userId) async {
    final userDefault = await getImageUrl('images/default_profile.png');
    try {
      await _db.collection('users').doc(userId).collection('profile')
          .doc(userId).set({
        'avatar': userDefault,
        'bio': 'Default bio',
        'following': 0,
        'posts': 0,
      });
    } catch (e) {
      print('Failed to create profile for user ID: $userId. Error: $e');
      rethrow;
    }
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
        Get.snackbar(
          'Sign-In Cancelled',
          'Google Sign-In was cancelled.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();

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
          // If the user document doesn't exist, create a new one
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'username': 'new user',
            'email': firebaseUser.email,
            'name': firebaseUser.displayName,
            'isDeleted': false,
            'lastLoggedIn': Timestamp.now(),
            'signUpDate': Timestamp.now(),
            // Add other default fields as necessary
          });

          // Create a profile for the new user
          await _createUserProfile(firebaseUser.uid);

          Get.snackbar(
            '',
            '',
            titleText: Text(
              'Success!',
              style: LightTextTheme.snackbarBold,
            ),
            messageText: Text(
              'Your account has been created!',
              style: LightTextTheme.snackbarTxt,
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: greenButton,
            colorText: blackColor,
          );

          Get.offAll(() => const DashboardSelector());
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

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}