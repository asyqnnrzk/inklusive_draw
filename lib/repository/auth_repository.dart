import 'package:InklusiveDraw/module/app_dashboard/user_dashboard.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/login/login_screen.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/register/register_screen.dart';
import 'package:InklusiveDraw/repository/exceptions/sign_up_fail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const LoginScreen()) : Get.offAll(() => const UserDashboard());
  }

  Future<void> registerUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      firebaseUser.value != null ? Get.offAll(() => const UserDashboard()) : Get.offAll(() => const RegisterScreen());
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

  Future<void> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      firebaseUser.value != null ? Get.offAll(() => const UserDashboard()) : Get.offAll(() => const LoginScreen());
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

  Future<void> logout() async => await _auth.signOut();
}