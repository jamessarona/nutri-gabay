import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/ui/nutritionist_booking_screen.dart';

class NutritionistProfileScreen extends StatefulWidget {
  final String nutritionistId;
  const NutritionistProfileScreen({super.key, required this.nutritionistId});

  @override
  State<NutritionistProfileScreen> createState() =>
      _NutritionistProfileScreenState();
}

class _NutritionistProfileScreenState extends State<NutritionistProfileScreen> {
  late Size screenSize;

  Doctor? doctor;
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

  String calculatAge(String birthdate) {
    DateTime date = DateFormat('MM/dd/yyyy').parse(birthdate);
    return (AgeCalculator.age(date).years + 1).toString();
  }

  Widget _buildSchedule() {
    return Table(
      children: [
        TableRow(
          children: [
            Text(
              'MON',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
            Text(
              '00:00 PM - 00:00PM',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              'TUE',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
            Text(
              '00:00 PM - 00:00PM',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              'WED',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
            Text(
              '00:00 PM - 00:00PM',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              'THU',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
            Text(
              '00:00 PM - 00:00PM',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              'FRI',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
            Text(
              '00:00 PM - 00:00PM',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              'SAT',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
            Text(
              '00:00 PM - 00:00PM',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              'SUN',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
            Text(
              '00:00 PM - 00:00PM',
              style: appstyle(13, Colors.black, FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    getDoctorInfo();
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
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: doctor == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Container(
                      height: screenSize.height * 0.31,
                      color: customColor[70],
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: customColor,
                              backgroundImage: NetworkImage(
                                doctor!.image,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            doctor!.name,
                            style: appstyle(24, Colors.black, FontWeight.w800),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 5, bottom: 10, left: 25, right: 25),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    doctor!.specialization,
                                    style: appstyle(
                                      15,
                                      Colors.black,
                                      FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                  ),
                                  Text(
                                    doctor!.birthdate == ''
                                        ? ''
                                        : 'Age:${calculatAge(doctor!.birthdate)} ${doctor!.birthdate}',
                                    style: appstyle(
                                      12,
                                      Colors.black,
                                      FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                  ),
                                  Text(
                                    doctor!.email,
                                    style: appstyle(
                                      12,
                                      Colors.black,
                                      FontWeight.normal,
                                    ).copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                  ),
                                  Text(
                                    doctor!.address,
                                    style: appstyle(
                                      12,
                                      Colors.black,
                                      FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                  ),
                                  Text(
                                    doctor!.phone,
                                    style: appstyle(
                                      12,
                                      Colors.black,
                                      FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: screenSize.height * 0.60,
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(top: 5, left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time Schedule',
                            style: appstyle(15, Colors.black, FontWeight.w600),
                          ),
                          const Divider(thickness: 1),
                          _buildSchedule(),
                          const SizedBox(height: 20),
                          Text(
                            'About Me',
                            style: appstyle(15, Colors.black, FontWeight.w600),
                          ),
                          const Divider(thickness: 1),
                          Text(
                            doctor!.about,
                            style: appstyle(13, Colors.black, FontWeight.w500),
                            maxLines: 10,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        floatingActionButton: SizedBox(
          height: 35,
          width: 80,
          child: UserCredentialSecondaryButton(
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NutritionistBookingScreen(
                    nutritionistId: widget.nutritionistId,
                  ),
                ),
              );
            },
            label: "Book",
            labelSize: 12,
            color: customColor,
          ),
        ),
      ),
    );
  }
}
