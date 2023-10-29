import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_gabay/models/appointment_controller.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/models/patient_controller.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;
  final String appointmentId;
  const ChatScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Doctor? doctor;
  Patient? patient;
  Appointment? appointment;

  void getAppointmentInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("appointment")
        .doc(widget.appointmentId)
        .withConverter(
          fromFirestore: Appointment.fromFirestore,
          toFirestore: (Appointment appointment, _) =>
              appointment.toFirestore(),
        );
    final docSnap = await ref.get();
    appointment = docSnap.data()!;
    setState(() {});
  }

  void getDoctortInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("doctor")
        .doc(widget.doctorId)
        .withConverter(
          fromFirestore: Doctor.fromFirestore,
          toFirestore: (Doctor doctor, _) => doctor.toFirestore(),
        );
    final docSnap = await ref.get();
    doctor = docSnap.data()!;
    setState(() {});
  }

  void getPatientInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("patient")
        .doc(widget.patientId)
        .withConverter(
          fromFirestore: Patient.fromFirestore,
          toFirestore: (Patient patient, _) => patient.toFirestore(),
        );
    final docSnap = await ref.get();
    patient = docSnap.data()!;
    setState(() {});
  }

  @override
  void initState() {
    getAppointmentInfo();
    getDoctortInfo();
    getPatientInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: appointment == null || doctor == null || patient == null
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.2))),
                ),
                toolbarHeight: 50,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.phone),
                    ),
                    Expanded(
                        child: Text(
                      doctor!.name,
                      style: appstyle(15, Colors.black, FontWeight.normal),
                    )),
                  ],
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                          ),
                          child: Image.network(
                            doctor!.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  30,
                                ),
                                color: doctor!.isOnline
                                    ? Colors.green
                                    : Colors.grey),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
