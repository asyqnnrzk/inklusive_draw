import 'package:InklusiveDraw/module/app_dashboard/user/user_dashboard.dart';
import 'package:InklusiveDraw/module/mainpage/homepage.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/login/login_screen'
    '.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/register/'
    'register_screen.dart';
import 'package:InklusiveDraw/repository/exceptions/sign_up_fail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<void> registerUserWithEmailAndPassword(String email, String password)
  async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      firebaseUser.value != null ? Get.offAll(() => const Homepage()) :
      Get.offAll(() => const RegisterScreen());
    } on FirebaseAuthException catch(e) {
      final ex = SignUpFail.code(e.code);
      print('FIREBASE AUTH EXCEPTION: ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpFail();
      print('EXCEPTION: ${ex.message}');
      throw ex;
    }
  }

  Future<void> loginUserWithEmailAndPassword(String email, String password)
  async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      firebaseUser.value != null ? Get.offAll(() => const Homepage()) :
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch(e) {
      final ex = SignUpFail.code(e.code);
      print('FIREBASE AUTH EXCEPTION: ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpFail();
      print('EXCEPTION: ${ex.message}');
      throw ex;
    }
  }

  Future<void> signInUserWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        Get.offAll(() => const LoginScreen());
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      UserCredential userCredential = await _auth.signInWithCredential
        (credential);

      // Check if the user is signed in
      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Check if user data exists in Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users')
            .doc(firebaseUser.uid).get();

        if (!userDoc.exists) {
          // If no user data exists, create a new user record
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'email': firebaseUser.email,
            'name': firebaseUser.displayName,
          });
          print('New user registered: ${firebaseUser.email}');
        } else {
          print('User already exists: ${firebaseUser.email}');
        }

        // Navigate to user dashboard
        Get.offAll(() => const UserDashboard());
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