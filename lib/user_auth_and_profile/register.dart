import 'package:InklusiveDraw/homepage/homepage.dart';
import 'package:InklusiveDraw/user_auth_and_profile/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: RegisterPage(),
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  final GlobalKey<FormState> _formKeyRegister = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black54,
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
          key: _formKeyRegister,
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
                      'Create an account',
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
                      'Name*',
                      style: tfName,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF58B9A1)),
                        ),
                        hintText: 'Enter name',
                        prefixIcon: Icon(Icons.person),
                        prefixIconColor: Color(0xFF58B9A1),
                      ),
                      validator: (name) {
                        if (name == null || name.isEmpty) {
                          return 'Please enter your name';
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
                      'Username*',
                      style: tfName,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF58B9A1)),
                        ),
                        hintText: 'Enter username',
                        prefixIcon: Icon(Icons.person),
                        prefixIconColor: Color(0xFF58B9A1),
                      ),
                      validator: (username) {
                        if (username == null || username.isEmpty) {
                          return 'Please enter your username';
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
                      'Password*',
                      style: tfName,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Alphabets, numbers, _ only',
                      style: TextStyle(
                        fontFamily: 'MontserratBold',
                        fontSize: 10,
                        color: Color(0xFFE37F8F)
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      obscureText: _obscurePassword,
                      maxLength: 16,
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
                        if (password.length < 8) {
                          return 'Password is too short';
                        }
                        RegExp regexPassword = RegExp(r'^[a-zA-Z0-9_]+$');
                        if (!regexPassword.hasMatch(password)) {
                          return 'Please enter a valid password';
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
                      'Confirm Password*',
                      style: tfName,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      obscureText: _obscureConfirm,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF58B9A1)),
                        ),
                        hintText: 'Re-enter password',
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: const Color(0xFF58B9A1),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                          child: Icon(
                            _obscureConfirm ? Icons.visibility :
                            Icons.visibility_off,
                          ),
                        ),
                        suffixIconColor: const Color(0xFF58B9A1),
                      ),
                      validator: (confirmPassword) {
                        if (confirmPassword == null || confirmPassword.isEmpty)
                        {
                          return 'Please re-enter your password';
                        }
                        if (confirmPasswordController.text !=
                            passwordController.text) {
                          return 'Password is not match';
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
                      'Email*',
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
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Please enter your email';
                        }
                        RegExp regexEmail = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          caseSensitive: false,
                        );
                        if (!regexEmail.hasMatch(email)) {
                          return 'Please enter a valid email address';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'REQUIRED*',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'MontserratBold'
                  ),
                ),
              ),
              const SizedBox(height: 2.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKeyRegister.currentState!.validate()) {
                            print('Register');
                            // go to login page
                            const LoginPage();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: const Color(0xFF58B9A1)
                        ),
                        child: const Text(
                            'Register'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2.0),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Or register with ',
                          style: TextStyle(
                              fontFamily: 'MontserratRegular'
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Tapped');
                            // go to register with Google
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
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                              fontFamily: 'MontserratRegular'
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Tapped');
                            // go to login page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                              const LoginPage()),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'MontserratBold',
                              fontSize: 14.0,
                              color: Color(0xFF58B9A1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
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
