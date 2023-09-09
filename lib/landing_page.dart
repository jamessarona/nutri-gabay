import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/loading_screen.dart';
import 'package:nutri_gabay/views/ui/assessment_nutritional_profile_screen.dart';
import 'package:nutri_gabay/views/ui/main_screen.dart';

class MainLandingPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const MainLandingPage(
      {super.key, required this.auth, required this.onSignOut});

  @override
  State<MainLandingPage> createState() => _MainLandingPageState();
}

class _MainLandingPageState extends State<MainLandingPage> {
  int userEvaluated = 0;
  void checkUserAssessment() async {
    String uid = await widget.auth.currentUser();
    final collection =
        FirebaseFirestore.instance.collection('patient_nutritional_profile');

    collection.where('uid', isEqualTo: uid).get().then((querySnapshot) {
      if (querySnapshot.size > 0) {
        userEvaluated = 2;
      } else {
        userEvaluated = 1;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    checkUserAssessment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userEvaluated == 0
        ? const LoadingScreen()
        : userEvaluated == 1
            ? AssessmentNutritionalProfileScreen(
                auth: widget.auth,
              )
            : MainScreen(auth: widget.auth, onSignOut: widget.onSignOut);
  }
}
