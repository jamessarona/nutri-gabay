import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';
import 'package:nutri_gabay/views/ui/resetscreen.dart';
import 'package:nutri_gabay/views/ui/signupscreen.dart';
import 'package:nutri_gabay/services/baseauth.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onSignIn;
  final BaseAuth auth;
  const LoginScreen({super.key, required this.auth, this.onSignIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool isLoading = false, authIsNotValid = false;
  String authMessage = '';

  void validation() async {
    String userUID;
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        setState(() {
          authIsNotValid = false;
        });

        userUID = await widget.auth
            .signInWithEmailAndPassword(_username.text, _password.text);
        // ignore: unnecessary_null_comparison
        if (userUID != null) {
          widget.onSignIn!();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          setState(() {
            authIsNotValid = true;

            authMessage = 'Password is incorrect!';
          });
        } else {
          setState(() {
            authIsNotValid = true;
            authMessage = 'Email does not exist!';
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: screenSize.height,
                width: screenSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.2,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
                      height: 90,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo-name.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    UserCredentialTextField(
                        controller: _username,
                        screenSize: screenSize,
                        label: "Username",
                        isObscure: false,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 15,
                    ),
                    UserCredentialTextField(
                        controller: _password,
                        screenSize: screenSize,
                        label: "Password",
                        isObscure: true,
                        keyboardType: TextInputType.text),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: screenSize.height * 0.03,
                      child: authIsNotValid == true
                          ? Text(authMessage,
                              style: appstyle(12, Colors.red, FontWeight.w400))
                          : null,
                    ),
                    SizedBox(
                      height: 50,
                      width: screenSize.width * 0.6,
                      child: UserCredentialPrimaryButton(
                          onPress: () {
                            validation();
                          },
                          label: "Login"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: appstyle(14, Colors.black, FontWeight.w500),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Create your account",
                            style: appstyle(
                                14,
                                const Color.fromARGB(255, 28, 117, 190),
                                FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 40,
                      width: screenSize.width * 0.5,
                      child: UserCredentialSecondaryButton(
                        onPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const ResetScreen(),
                            ),
                          );
                        },
                        label: "Forgot Password?",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
