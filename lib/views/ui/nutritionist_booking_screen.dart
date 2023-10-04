import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/models/patient_controller.dart';
import 'package:nutri_gabay/models/patient_nutrition_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';

class NutritionistBookingScreen extends StatefulWidget {
  final String nutritionistId;
  const NutritionistBookingScreen({super.key, required this.nutritionistId});

  @override
  State<NutritionistBookingScreen> createState() =>
      _NutritionistBookingScreenState();
}

class _NutritionistBookingScreenState extends State<NutritionistBookingScreen> {
  late Size screenSize;
  Doctor? doctor;
  Patient? patient;
  PatientNutrition? patientNutrition;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bmi = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final TextEditingController _riskLevel = TextEditingController();
  final TextEditingController _sex = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _height = TextEditingController();

  void getDoctorInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("doctor")
        .doc(widget.nutritionistId)
        .withConverter(
          fromFirestore: Doctor.fromFirestore,
          toFirestore: (Doctor dt, _) => dt.toFirestore(),
        );
    final docSnap = await ref.get();
    doctor = docSnap.data()!;
    setState(() {});
  }

  void getPatientInfo() async {
    String uid = await FireBaseAuth().currentUser();
    final ref =
        FirebaseFirestore.instance.collection("patient").doc(uid).withConverter(
              fromFirestore: Patient.fromFirestore,
              toFirestore: (Patient pt, _) => pt.toFirestore(),
            );
    final docSnap = await ref.get();
    patient = docSnap.data()!;
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

    await collection.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (uid == docSnapshot.data().uid) {
            patientNutrition = docSnapshot.data();
            setState(() {});
            break;
          }
        }
      },
    );
  }

  @override
  void initState() {
    getDoctorInfo();
    getPatientInfo();
    getPatientNutritionInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
          actions: const [
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.save_as_outlined,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: customColor[70],
          child: doctor == null && patient == null && patientNutrition == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Container(
                      height: 300,
                      color: customColor[70],
                      padding:
                          const EdgeInsets.only(bottom: 5, left: 25, right: 25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const Icon(
                                  Icons.flag_outlined,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                Text(
                                  'Book now',
                                  style: appstyle(
                                      23, customColor, FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  BookingTextField(
                                    controller: _name,
                                    label: 'Name',
                                    isEnable: false,
                                    isMultiLine: false,
                                    keyboardType: TextInputType.name,
                                    width: 0.3,
                                  ),
                                  const SizedBox(height: 5),
                                  BookingTextField(
                                    controller: _bmi,
                                    label: 'BMI',
                                    isEnable: false,
                                    isMultiLine: false,
                                    keyboardType: TextInputType.number,
                                    width: 0.3,
                                  ),
                                  const SizedBox(height: 5),
                                  BookingTextField(
                                    controller: _status,
                                    label: 'Nutritional Status',
                                    isEnable: false,
                                    isMultiLine: false,
                                    keyboardType: TextInputType.text,
                                    width: 0.3,
                                  ),
                                  const SizedBox(height: 5),
                                  BookingTextField(
                                    controller: _riskLevel,
                                    label: 'Risk Level',
                                    isEnable: false,
                                    isMultiLine: false,
                                    keyboardType: TextInputType.text,
                                    width: 0.3,
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: BookingTextField(
                                          controller: _sex,
                                          label: 'Sex',
                                          isEnable: false,
                                          isMultiLine: true,
                                          keyboardType: TextInputType.text,
                                          width: 0.3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: BookingTextField(
                                          controller: _age,
                                          label: 'Age',
                                          isEnable: false,
                                          isMultiLine: true,
                                          keyboardType: TextInputType.text,
                                          width: 0.3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 110,
                                        child: BookingTextField(
                                          controller: _height,
                                          label: 'Height',
                                          isEnable: false,
                                          isMultiLine: true,
                                          keyboardType: TextInputType.text,
                                          width: 0.3,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: screenSize.height * 0.60,
                      ),
                      color: Colors.white,
                      padding:
                          const EdgeInsets.only(top: 5, left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            thickness: 1,
                            color: Colors.black26,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Is there anything else you would like us to know?',
                            style:
                                appstyle(12, Colors.black, FontWeight.normal),
                          ),
                          const Divider(thickness: 1),
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
