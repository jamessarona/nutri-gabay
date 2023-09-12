import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutri_gabay/models/patient_controller.dart';
import 'package:nutri_gabay/models/patient_nutrition_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/custom_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late String imageUrl;
  late Size screenSize;
  // ignore: prefer_typing_uninitialized_variables
  var patient, nutritionProfile;
  bool hasData = false;
  File? image;
  bool isLoading = false;

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
    setState(() {});
  }

  void getPatientNutritionInfo() async {
    String uid = await FireBaseAuth().currentUser();
    final collection = FirebaseFirestore.instance
        .collection('patient_nutritional_profile')
        .where("uid", isEqualTo: uid)
        .withConverter(
          fromFirestore: PatientNutrition.fromFirestore,
          toFirestore: (PatientNutrition city, _) => city.toFirestore(),
        );

    collection.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (uid == docSnapshot.data().uid) {
            nutritionProfile = docSnapshot.data();
            hasData = patient != null;
            setState(() {});
            break;
          }
        }
      },
    );
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        this.image = null;
        final imageTemporary = File(image.path);
        this.image = imageTemporary;
      });
    }
  }

  uploadImage() async {
    final firebaseStorage = FirebaseStorage.instance;
    var snapshot = await firebaseStorage
        .ref()
        .child('images/profiles/${patient.uid}')
        .putFile(File(image!.path));

    var downloadUrl = await snapshot.ref.getDownloadURL();

    saveImageToDatabase(downloadUrl);
  }

  saveImageToDatabase(String url) async {
    final collection = FirebaseFirestore.instance.collection('patient');

    await collection.doc(patient.uid).update({"image": url});

    setState(() {
      image = null;
      getPatientInfo();
      getPatientNutritionInfo();
    });
  }

  @override
  void initState() {
    getPatientInfo();
    getPatientNutritionInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
                decoration: BoxDecoration(border: Border.all(width: 0.2))),
          ),
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Container(
            height: 45,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo-name.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save_as_outlined,
                color: image != null ? Colors.black : Colors.transparent,
              ),
              onPressed: image != null || !isLoading
                  ? () {
                      setState(() {
                        isLoading = true;
                      });
                      if (image != null) uploadImage();
                      setState(() {
                        isLoading = false;
                      });
                    }
                  : null,
            ),
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: !hasData
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              : ListView(
                  children: [
                    Container(
                      height: screenSize.height * 0.3,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            customColor,
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Container(
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: customColor,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: image != null
                                      ? Image.file(
                                          image!,
                                          width: 95,
                                          height: 95,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          patient.image,
                                          width: 95,
                                          height: 95,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 4,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                      onPressed: () {
                                        pickImage();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 60, right: 60),
                            width: double.maxFinite,
                            child: Text(
                              "${patient.firstname} ${patient.lastname}",
                              style:
                                  appstyle(26, Colors.black, FontWeight.w800),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 28,
                            width: 95,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 20,
                                    offset: const Offset(-1, 2)),
                              ],
                            ),
                            child: UserCredentialSecondaryButton(
                                onPress: () {},
                                label: "Edit Profile",
                                labelSize: 10),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    ProfileCard(
                      leading: "Gender:",
                      title: nutritionProfile.sex,
                      screenSize: screenSize,
                      fontSize: 18,
                      isOverFlow: false,
                    ),
                    ProfileCard(
                      leading: "Age:",
                      title: nutritionProfile.age.toString(),
                      screenSize: screenSize,
                      fontSize: 18,
                      isOverFlow: false,
                    ),
                    ProfileCard(
                      leading: "Height:",
                      title: "${nutritionProfile.height.toStringAsFixed(2)} cm",
                      screenSize: screenSize,
                      fontSize: 18,
                      isOverFlow: false,
                    ),
                    ProfileCard(
                      leading: "Weight:",
                      title: "${nutritionProfile.weight.toStringAsFixed(2)} kg",
                      screenSize: screenSize,
                      fontSize: 18,
                      isOverFlow: false,
                    ),
                    ProfileCard(
                      leading: "BMI:",
                      title: "${nutritionProfile.bmi.toStringAsFixed(2)}",
                      screenSize: screenSize,
                      fontSize: 18,
                      isOverFlow: false,
                    ),
                    ProfileCard(
                      leading: "Nutritional Status:",
                      title: nutritionProfile.status,
                      screenSize: screenSize,
                      fontSize: 18,
                      isOverFlow: true,
                    ),
                    ProfileCard(
                      leading: "Nutritional Assessment score:",
                      title:
                          "${nutritionProfile.points.toStringAsFixed(0)} (${nutritionProfile.result})",
                      screenSize: screenSize,
                      fontSize: 18,
                      isOverFlow: true,
                    ),
                    ProfileCard(
                      leading: "Phone Number:",
                      title: patient.phone,
                      screenSize: screenSize,
                      fontSize: 18,
                      isOverFlow: false,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
        ),
      ),
    );
  }
}
