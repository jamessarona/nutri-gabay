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
  bool isEditing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _bmi = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final TextEditingController _points = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _sex = TextEditingController();
  final TextEditingController _age = TextEditingController();

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
            hasData = nutritionProfile != null;
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

  saveProfile() async {
    final patientDoc =
        FirebaseFirestore.instance.collection('patient').doc(patient.uid);
    final nutritionDoc = FirebaseFirestore.instance
        .collection('patient_nutritional_profile')
        .doc(nutritionProfile.id);

    Patient updatedPatient = Patient(
      uid: patient.uid,
      firstname: _firstname.text,
      lastname: _lastname.text,
      email: _email.text,
      image: patient.image,
      phone: _phone.text,
    );

    PatientNutrition updatedNutrition = PatientNutrition(
      id: nutritionProfile.id,
      uid: nutritionProfile.uid,
      height: nutritionProfile.height,
      weight: nutritionProfile.weight,
      date: nutritionProfile.date,
      birthdate: nutritionProfile.birthdate,
      age: int.parse(_age.text),
      sex: _sex.text,
      bmi: nutritionProfile.bmi,
      category: nutritionProfile.category,
      status: nutritionProfile.status,
      points: nutritionProfile.points,
      result: nutritionProfile.result,
    );

    final patientJson = updatedPatient.toJson();
    await patientDoc.update(patientJson);

    final nutritionJson = updatedNutrition.toJson();
    await nutritionDoc.update(nutritionJson);

    setState(() {
      image = null;
      getPatientInfo();
      getPatientNutritionInfo();
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (!isEditing) {
      if (patient != null) {
        _firstname.text = patient.firstname;
        _lastname.text = patient.lastname;
        _email.text = patient.email;
        _phone.text = patient.phone;
      }
      if (nutritionProfile != null) {
        _height.text = "${nutritionProfile.height.toStringAsFixed(2)}";
        _weight.text = "${nutritionProfile.weight.toStringAsFixed(2)}";
        _age.text = nutritionProfile.age.toString();
        _sex.text = nutritionProfile.sex;
        _bmi.text = nutritionProfile.bmi.toStringAsFixed(0);
        _status.text = nutritionProfile.status;
        _points.text =
            "${nutritionProfile.points.toStringAsFixed(0)} (${nutritionProfile.result})";
      }
    }
    super.setState(fn);
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
                color: image != null || isEditing
                    ? Colors.black
                    : Colors.transparent,
              ),
              onPressed: image != null || !isLoading || isEditing
                  ? () {
                      setState(() {
                        isLoading = true;
                      });
                      if (image != null) uploadImage();
                      if (isEditing) {
                        setState(() {
                          isEditing = false;
                        });
                        saveProfile();
                      }
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
              : Form(
                  key: _formKey,
                  child: ListView(
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
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                  top: 20, left: 50, right: 50),
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  !isEditing
                                      ? Text(
                                          patient.firstname,
                                          style: appstyle(26, Colors.black,
                                              FontWeight.w800),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          height: 25,
                                          child: TextFormField(
                                            controller: _firstname,
                                            textAlign: TextAlign.center,
                                            style: appstyle(26, Colors.black,
                                                FontWeight.w800),
                                            cursorColor: customColor,
                                            decoration: const InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: customColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                  !isEditing
                                      ? Text(
                                          patient.lastname,
                                          style: appstyle(26, Colors.black,
                                              FontWeight.w800),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        )
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(top: 15),
                                          height: 25,
                                          child: TextFormField(
                                            controller: _lastname,
                                            textAlign: TextAlign.center,
                                            style: appstyle(26, Colors.black,
                                                FontWeight.w800),
                                            cursorColor: customColor,
                                            decoration: const InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: customColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            !isEditing
                                ? Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    height: 28,
                                    width: 95,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 3,
                                            blurRadius: 20,
                                            offset: const Offset(-1, 2)),
                                      ],
                                    ),
                                    child: UserCredentialSecondaryButton(
                                        onPress: () {
                                          setState(() {
                                            isEditing = true;
                                          });
                                        },
                                        label: "Edit Profile",
                                        labelSize: 10),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      ProfileCard(
                        leading: "Email:",
                        screenSize: screenSize,
                        fontSize: 18,
                        isOverFlow: false,
                        isEditing: false,
                        isGender: false,
                        isDigit: false,
                        unit: "",
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      ProfileCard(
                        leading: "Phone Number:",
                        screenSize: screenSize,
                        fontSize: 18,
                        isOverFlow: false,
                        isEditing: isEditing,
                        isGender: false,
                        isDigit: true,
                        unit: "",
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                      ),
                      ProfileCard(
                        leading: "Age:",
                        screenSize: screenSize,
                        fontSize: 18,
                        isOverFlow: false,
                        isEditing: isEditing,
                        isGender: false,
                        isDigit: true,
                        unit: "",
                        controller: _age,
                        keyboardType: TextInputType.number,
                      ),
                      ProfileCard(
                        leading: "Sex:",
                        screenSize: screenSize,
                        fontSize: 18,
                        isOverFlow: false,
                        isEditing: isEditing,
                        isGender: true,
                        isDigit: false,
                        unit: "",
                        controller: _sex,
                        keyboardType: TextInputType.none,
                      ),
                      ProfileCard(
                        leading: "Height:",
                        screenSize: screenSize,
                        fontSize: 18,
                        isOverFlow: false,
                        isEditing: false,
                        isGender: false,
                        isDigit: false,
                        unit: "cm",
                        controller: _height,
                        keyboardType: TextInputType.number,
                      ),
                      ProfileCard(
                        leading: "Weight:",
                        screenSize: screenSize,
                        fontSize: 18,
                        isOverFlow: false,
                        isEditing: false,
                        isGender: false,
                        isDigit: false,
                        unit: "kg",
                        controller: _weight,
                        keyboardType: TextInputType.number,
                      ),
                      ProfileCard(
                        leading: "BMI:",
                        screenSize: screenSize,
                        fontSize: 18,
                        isOverFlow: false,
                        isEditing: false,
                        isGender: false,
                        isDigit: false,
                        unit: "",
                        controller: _bmi,
                        keyboardType: TextInputType.number,
                      ),
                      ProfileCard(
                        leading: "Nutritional Status:",
                        screenSize: screenSize,
                        fontSize: 18,
                        isOverFlow: true,
                        isEditing: false,
                        isGender: false,
                        isDigit: false,
                        unit: "",
                        controller: _status,
                        keyboardType: TextInputType.text,
                      ),
                      ProfileCard(
                        leading: "Nutritional Assessment score:",
                        screenSize: screenSize,
                        fontSize: 18,
                        isOverFlow: true,
                        isEditing: false,
                        isGender: false,
                        isDigit: false,
                        unit: "",
                        controller: _points,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
