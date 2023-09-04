import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/user_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';

import '../shared/app_style.dart';
import '../shared/button_widget.dart';
import '../shared/text_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late Size screenSize;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEmailExist = false;

  String regEx =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  Future<bool> register() async {
    isEmailExist = await hasExistingAccount();
    if (_formKey.currentState!.validate()) {
      String userUID = await FireBaseAuth()
          .registerWithEmailPasswordAdmin(_email.text, _password.text);
      if (userUID != '') {
        createUser(userUID);
      }
      return userUID != '';
    }
    return false;
  }

  Future<void> createUser(String userUID) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    Users user = Users(
      id: docUser.id,
      name: _name.text,
      email: _email.text,
    );

    final json = user.toJson();
    await docUser.set(json);
  }

  Future<bool> hasExistingAccount() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    bool result = true;
    await firebaseAuth
        .fetchSignInMethodsForEmail(_email.text)
        .then((signInMethods) => result = signInMethods.isNotEmpty);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: Form(
                key: _formKey,
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
                      controller: _name,
                      screenSize: screenSize,
                      label: "Name",
                      isObscure: false,
                      keyboardType: TextInputType.name,
                      validation: (value) {
                        if (value == '') return 'Please enter your name';

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    UserCredentialTextField(
                      controller: _email,
                      screenSize: screenSize,
                      label: "Email",
                      isObscure: false,
                      keyboardType: TextInputType.emailAddress,
                      validation: (value) {
                        if (value == '') {
                          return 'Please enter your email';
                        } else if (!RegExp(regEx).hasMatch(value!)) {
                          return 'Invalid email format';
                        } else if (isEmailExist) {
                          return 'Email is already in used';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    UserCredentialTextField(
                      controller: _password,
                      screenSize: screenSize,
                      label: "Password",
                      isObscure: true,
                      keyboardType: TextInputType.text,
                      validation: (value) {
                        if (value == '') {
                          return 'Please enter your password';
                        } else if (value!.length < 8) {
                          return 'Password must be more than 8 characters';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    UserCredentialTextField(
                        controller: _confirmPassword,
                        screenSize: screenSize,
                        label: "Confirm Password",
                        isObscure: true,
                        keyboardType: TextInputType.text,
                        validation: (value) {
                          if (value == '') {
                            return 'Please confirm your password';
                          } else if (_password.text != value) {
                            return 'Password does not match';
                          }

                          return null;
                        }),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      width: screenSize.width * 0.6,
                      child: UserCredentialPrimaryButton(
                          onPress: () async {
                            bool isSuccessful = await register();
                            if (isSuccessful) {
                              _name.clear();
                              _email.clear();
                              _password.clear();
                              _confirmPassword.clear();
                              final snackBar = SnackBar(
                                content: const Text(
                                    'Your account has been created.'),
                                action: SnackBarAction(
                                  label: 'Close',
                                  onPressed: () {},
                                ),
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          label: "Create Account"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: appstyle(14, Colors.black, FontWeight.w500),
                        ),
                        const SizedBox(width: 60),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Login",
                            style: appstyle(
                                14,
                                const Color.fromARGB(255, 28, 117, 190),
                                FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class User {
  String id;
  final String name;
  final String email;

  User({
    this.id = '',
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
