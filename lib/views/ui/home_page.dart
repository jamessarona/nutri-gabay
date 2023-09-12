import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/patient_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/home_page_container.dart';
import 'package:nutri_gabay/views/ui/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Size screenSize;
  // ignore: prefer_typing_uninitialized_variables
  var patient;
  bool hasData = false;

  String getGreetingMessage() {
    String msg = '';
    DateTime now = DateTime.now();
    int hours = now.hour;
    if (hours >= 1 && hours <= 12) {
      msg = "Good Morning'";
    } else if (hours >= 12 && hours <= 16) {
      msg = "Good Afternoon'";
    } else if (hours >= 16 && hours <= 24) {
      msg = "Good Evening'";
    }
    return msg;
  }

  void getPatientInfo() async {
    String uid = await FireBaseAuth().currentUser();
    final ref =
        FirebaseFirestore.instance.collection("patient").doc(uid).withConverter(
              fromFirestore: Patient.fromFirestore,
              toFirestore: (Patient patient, _) => patient.toFirestore(),
            );
    final docSnap = await ref.get();
    patient = docSnap.data()!;
    // ignore: unnecessary_null_comparison
    hasData = patient != null;
    setState(() {});
  }

  @override
  void initState() {
    getPatientInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.infinity,
          width: screenSize.width,
          child: ListView(
            children: [
              !hasData
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: customColor,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      patient.image,
                                    ),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            getGreetingMessage(),
                            style: appstyle(30, Colors.black, FontWeight.bold),
                          ),
                          SizedBox(
                            height: 70,
                            width: double.infinity,
                            child: Text(
                              "${patient.firstname} ${patient.lastname}",
                              style:
                                  appstyle(25, Colors.black, FontWeight.bold),
                              maxLines: 2,
                            ),
                          ),
                          HomePageContainer(
                            screenSize: screenSize,
                            colorIndex: 50,
                            image: "account.png",
                            title: "My Profile",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                              getPatientInfo();
                            },
                          ),
                          const SizedBox(height: 10),
                          HomePageContainer(
                              screenSize: screenSize,
                              colorIndex: 10,
                              image: "doctor.png",
                              title: "Find Nutritionist",
                              onTap: () {}),
                          const SizedBox(height: 10),
                          HomePageContainer(
                              screenSize: screenSize,
                              colorIndex: 0,
                              image: "calculator.png",
                              title: "Calculator",
                              onTap: () {}),
                          const SizedBox(height: 10),
                          HomePageContainer(
                              screenSize: screenSize,
                              colorIndex: 0,
                              image: "reassessment.png",
                              title: "Reassessment",
                              onTap: () {}),
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
