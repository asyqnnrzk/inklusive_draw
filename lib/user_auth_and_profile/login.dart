import 'package:InklusiveDraw/homepage/homepage.dart';
import 'package:InklusiveDraw/user_auth_and_profile/profile.dart';
import 'package:InklusiveDraw/user_auth_and_profile/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginPage(),
  ));
}

const TextStyle appName = TextStyle(
  color: Color(0xFF58B9A1),
  fontSize: 36.0,
  fontFamily: 'MontserratBoth',
);

const TextStyle textName = TextStyle(
  color: Colors.black54,
  fontSize: 24.0,
  fontFamily: 'MontserratRegular',
);

const TextStyle tfName = TextStyle(
  color: Colors.black54,
  fontSize: 16.0,
  fontFamily: 'MontserratRegular',
);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();

  void _login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58B9A1)),
            strokeWidth: 4,
            backgroundColor: Colors.grey,
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // successfully logged in
      print('Logged in');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Welcome!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF58B9A1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Navigator.pop(context);
            },
            textColor: Colors.white,
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(user: FirebaseAuth.instance.currentUser)),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        print('Wrong email');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Incorrect email', 'The email address you entered is not registered",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFFEC8696),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                Navigator.pop(context);
              },
              textColor: Colors.white,
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Incorrect password', 'The password you entered is incorrect",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFFEC8696),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                Navigator.pop(context);
              },
              textColor: Colors.white,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Color(0xFF58B9A1),
          onPressed: () {
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) =>
            const HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyLogin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'InklusiveDraw',
                      style: appName,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Login',
                      style: textName,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Email',
                      style: tfName,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF58B9A1)),
                        ),
                        hintText: 'Enter email',
                        prefixIcon: Icon(Icons.email),
                        prefixIconColor: Color(0xFF58B9A1),
                      ),
                      validator: (username) {
                        if (username == null || username.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Password',
                      style: tfName,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      obscureText: _obscurePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF58B9A1)),
                        ),
                        hintText: 'Enter password',
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: const Color(0xFF58B9A1),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                            _obscurePassword ? Icons.visibility :
                            Icons.visibility_off,
                          ),
                        ),
                        suffixIconColor: const Color(0xFF58B9A1),
                      ),
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    print('Tapped');
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          fontFamily: 'MontserratRegular',
                          fontSize: 12.0,
                          color: Color(0xFF58B9A1),
                          decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKeyLogin.currentState!.validate()) {
                            print('Login');
                            // go to profile homepage
                            _login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: const Color(0xFF58B9A1)
                        ),
                        child: const Text(
                            'Login'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Or continue with ',
                          style: TextStyle(
                              fontFamily: 'MontserratRegular'
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Tapped');
                            // go to login with Google
                          },
                          child: const Text(
                            'Google',
                            style: TextStyle(
                              fontFamily: 'MontserratBold',
                              fontSize: 16.0,
                              color: Color(0xFF58B9A1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                  fontFamily: 'MontserratRegular'
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('Tapped');
                                // go to register page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                  const RegisterPage()),
                                );
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontFamily: 'MontserratBold',
                                  fontSize: 14.0,
                                  color: Color(0xFF58B9A1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
