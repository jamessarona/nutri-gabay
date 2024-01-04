import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/appointment_controller.dart';
import 'package:nutri_gabay/models/assessment.dart';
import 'package:nutri_gabay/models/diagnosis.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/models/form.dart';
import 'package:nutri_gabay/models/message_controller.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/custom_card.dart';
import 'package:nutri_gabay/views/ui/chat_screen.dart';
import 'package:nutri_gabay/views/ui/monitoring_evaluation_screen.dart';
import 'package:nutri_gabay/views/ui/nutritionist_assessment_screen.dart';
import 'package:nutri_gabay/views/ui/nutritionist_diagnosis_screen.dart';
import 'package:nutri_gabay/views/ui/nutritionist_intervention_screen.dart';
import 'package:badges/badges.dart' as badges;

class NutritionistMonitoringScreen extends StatefulWidget {
  final String appointmentId;
  final String nutritionistId;
  final String patientId;
  const NutritionistMonitoringScreen({
    super.key,
    required this.appointmentId,
    required this.nutritionistId,
    required this.patientId,
  });

  @override
  State<NutritionistMonitoringScreen> createState() =>
      _NutritionistMonitoringScreenState();
}

class _NutritionistMonitoringScreenState
    extends State<NutritionistMonitoringScreen> {
  late Size screenSize;

  int chatCount = 0;
  int assessmentCount = 0;
  int diagnosisCount = 0;
  int interventionCount = 0;
  int monitoringCount = 0;

  Doctor? doctor;
  Appointments? appointment;

  Future<void> getNewChatCount() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('chat')
        .where(
          Filter.and(Filter("isSeen", isEqualTo: false),
              Filter("receiverId", isEqualTo: widget.patientId)),
        )
        .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message msg, _) => msg.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        chatCount = querySnapshot.docs.length;
      },
    );
  }

  Future<void> getNewAssessmentCount() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('assessment')
        .withConverter(
          fromFirestore: Assessment.fromFirestore,
          toFirestore: (Assessment assessment, _) => assessment.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        assessmentCount = querySnapshot.docs.length;
      },
    );
  }

  Future<void> getNewDiagnosisCount() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('diagnosis')
        .where(
          "isSeen",
          isEqualTo: false,
        )
        .withConverter(
          fromFirestore: Diagnosis.fromFirestore,
          toFirestore: (Diagnosis diagnosis, _) => diagnosis.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        diagnosisCount = querySnapshot.docs.length;
      },
    );
  }

  Future<void> getNewInterventionCount() async {
    interventionCount = 0;
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files');

    await collection.get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()["isSeen"] == false) {
            interventionCount++;
          }
          await getNewInterventionCommentCount(docSnapshot.data()["id"]);
        }
      },
    );
  }

  Future<void> getNewInterventionCommentCount(String fileId) async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .doc(fileId)
        .collection('comments')
        .where(
          Filter.and(Filter("isPatient", isEqualTo: false),
              Filter("isSeen", isEqualTo: false)),
        );

    await collection.get().then(
      (querySnapshot) {
        interventionCount += querySnapshot.docs.length;
      },
    );
  }

  Future<void> getNewMonitoringCount() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('form')
        .where("answered", isEqualTo: false)
        .withConverter(
          fromFirestore: FormQuestion.fromFirestore,
          toFirestore: (FormQuestion fq, _) => fq.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        monitoringCount = querySnapshot.docs.length;
      },
    );
  }

  Future<void> getUpdates() async {
    await getNewChatCount();
    await getNewAssessmentCount();
    await getNewDiagnosisCount();
    await getNewInterventionCount();
    await getNewMonitoringCount();
    setState(() {});
  }

  Future<void> getNutritionist() async {
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

  Future<void> getAppointment() async {
    final ref = FirebaseFirestore.instance
        .collection("appointment")
        .doc(widget.appointmentId)
        .withConverter(
          fromFirestore: Appointments.fromFirestore,
          toFirestore: (Appointments apt, _) => apt.toFirestore(),
        );
    final docSnap = await ref.get();
    appointment = docSnap.data()!;
    setState(() {});
  }

  showRebookConfirmationDialog(BuildContext context, String appointmentId) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: appstyle(14, Colors.black, FontWeight.normal),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Rebook",
        style: appstyle(14, customColor, FontWeight.bold),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        setState(() {});
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirmation",
        style: appstyle(15, Colors.black, FontWeight.bold),
      ),
      content: Text(
        "Do you want to rebook this appointment?",
        style: appstyle(13, Colors.black, FontWeight.normal),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    getNutritionist();
    getAppointment();

    // const oneSec = Duration(seconds: 1);
    // Timer.periodic(oneSec, (Timer t) async => await
    getUpdates();
    // );
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
          child: doctor == null || appointment == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    MyNutritionistListTile(
                      screenSize: screenSize,
                      appointmentId: appointment!.id,
                      image: doctor!.image,
                      name: doctor!.name,
                      nutritionistId: doctor!.uid,
                      patientId: widget.patientId,
                      date: appointment!.dateSchedule,
                      hourStart: appointment!.hourStart,
                      hourEnd: appointment!.hourEnd,
                      isDisplayOnly: true,
                    ),
                    const SizedBox(height: 10),
                    badges.Badge(
                      badgeContent: Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          chatCount > 9 ? "9+" : chatCount.toString(),
                          style: appstyle(20, Colors.black, FontWeight.bold),
                        ),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      showBadge: chatCount > 0,
                      position: badges.BadgePosition.topEnd(top: -5, end: 18),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                doctorId: appointment!.doctorId,
                                patientId: appointment!.patientId,
                                appointmentId: appointment!.id,
                              ),
                            ),
                          ).whenComplete(() async {
                            await getUpdates();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 5,
                            left: screenSize.width * 0.05,
                            right: screenSize.width * 0.05,
                          ),
                          height: 120,
                          width: double.infinity,
                          child: Card(
                            color: customColor[50],
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
                                SizedBox(
                                  height: 80,
                                  child: Image.asset('assets/icons/chat.png'),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    'Chat',
                                    style: appstyle(
                                        25, Colors.white, FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    badges.Badge(
                      badgeContent: Container(
                        margin: const EdgeInsets.all(8),
                        child: Text(
                          "!",
                          style: appstyle(20, Colors.black, FontWeight.bold),
                        ),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      showBadge: assessmentCount == 0,
                      position: badges.BadgePosition.topEnd(top: -10, end: 18),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutritionAssessmentScreen(
                                appointmentId: appointment!.id,
                              ),
                            ),
                          ).whenComplete(() async {
                            await getUpdates();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: screenSize.width * 0.05,
                            right: screenSize.width * 0.05,
                          ),
                          height: 120,
                          width: double.infinity,
                          child: Card(
                            color: customColor,
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
                                SizedBox(
                                  height: 80,
                                  child: Image.asset(
                                      'assets/icons/nutrition-assessment.png'),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    'Nutrition\nAssessment',
                                    style: appstyle(
                                        25, Colors.white, FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, bottom: 10),
                                    child: Text(
                                      '1',
                                      style: appstyle(
                                          20, Colors.white, FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    badges.Badge(
                      badgeContent: Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          diagnosisCount > 9 ? "9+" : diagnosisCount.toString(),
                          style: appstyle(20, Colors.black, FontWeight.bold),
                        ),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      showBadge: diagnosisCount > 0,
                      position: badges.BadgePosition.topEnd(top: -5, end: 18),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutritionistDiagnosisScreen(
                                appointmentId: appointment!.id,
                              ),
                            ),
                          ).whenComplete(() async {
                            await getUpdates();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: screenSize.width * 0.05,
                            right: screenSize.width * 0.05,
                          ),
                          height: 120,
                          width: double.infinity,
                          child: Card(
                            color: customColor[10],
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
                                SizedBox(
                                  height: 80,
                                  child:
                                      Image.asset('assets/icons/diagnosis.png'),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    'Nutrition\nDiagnosis',
                                    style: appstyle(
                                        25, Colors.white, FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, bottom: 10),
                                    child: Text(
                                      '2',
                                      style: appstyle(
                                          20, Colors.white, FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    badges.Badge(
                      badgeContent: Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          interventionCount > 9
                              ? "9+"
                              : interventionCount.toString(),
                          style: appstyle(20, Colors.black, FontWeight.bold),
                        ),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      showBadge: interventionCount > 0,
                      position: badges.BadgePosition.topEnd(top: -5, end: 18),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NutritionistInterventionScreen(
                                appointmentId: appointment!.id,
                                doctorId: appointment!.doctorId,
                                patientId: appointment!.patientId,
                              ),
                            ),
                          ).whenComplete(() async {
                            await getUpdates();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: screenSize.width * 0.05,
                            right: screenSize.width * 0.05,
                          ),
                          height: 120,
                          width: double.infinity,
                          child: Card(
                            color: customColor,
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
                                SizedBox(
                                  height: 80,
                                  child: Image.asset(
                                      'assets/icons/nutri-intervention.png'),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    'Nutrition\nIntervention',
                                    style: appstyle(
                                        25, Colors.white, FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, bottom: 10),
                                    child: Text(
                                      '3',
                                      style: appstyle(
                                          20, Colors.white, FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    badges.Badge(
                      badgeContent: Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          monitoringCount > 9
                              ? "9+"
                              : monitoringCount.toString(),
                          style: appstyle(20, Colors.black, FontWeight.bold),
                        ),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      position: badges.BadgePosition.topEnd(top: -5, end: 18),
                      showBadge: monitoringCount > 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MonitoringEvaluationScreen(
                                  appointmentId: appointment!.id),
                            ),
                          ).whenComplete(() async {
                            await getUpdates();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: screenSize.width * 0.05,
                            right: screenSize.width * 0.05,
                          ),
                          height: 120,
                          width: double.infinity,
                          child: Card(
                            color: customColor[10],
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
                                SizedBox(
                                  height: 80,
                                  child: Image.asset(
                                      'assets/icons/monitoring-evaluation.png'),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    'Monitoring and\nEvaluation',
                                    style: appstyle(
                                        25, Colors.white, FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, bottom: 10),
                                    child: Text(
                                      '4',
                                      style: appstyle(
                                          20, Colors.white, FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    appointment!.status == 'Closed'
                        ? GestureDetector(
                            onTap: () {
                              showRebookConfirmationDialog(
                                  context, appointment!.id);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: screenSize.width * 0.06,
                                right: screenSize.width * 0.06,
                              ),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: customColor),
                              alignment: Alignment.center,
                              child: Text(
                                'Rebook',
                                style:
                                    appstyle(25, Colors.white, FontWeight.bold),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
        ),
      ),
    );
  }
}
