import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay/models/appointment_controller.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/ui/nutritionist_booking_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class NutritionistProfileScreen extends StatefulWidget {
  final String nutritionistId;
  const NutritionistProfileScreen({super.key, required this.nutritionistId});

  @override
  State<NutritionistProfileScreen> createState() =>
      _NutritionistProfileScreenState();
}

class _NutritionistProfileScreenState extends State<NutritionistProfileScreen> {
  late Size screenSize;
  int tabIndex = 0;
  Doctor? doctor;
  final CalendarController _calendarController = CalendarController();
  List<QueryDocumentSnapshot<Appointments>>? appointments;

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

  List<Appointment> getAppointments() {
    getPendingAppointments();
    List<Appointment> meetings = <Appointment>[];

    if (appointments != null) {
      for (var appointment in appointments!) {
        final DateTime bookingStart = DateFormat("MM/dd/yyyy hh").parse(
            "${appointment.data().dateSchedule} ${appointment.data().hourStart.toStringAsFixed(2)}");
        final DateTime bookingEnd = DateFormat("MM/dd/yyyy hh").parse(
            "${appointment.data().dateSchedule} ${appointment.data().hourEnd.toStringAsFixed(2)}");
        meetings.add(
          Appointment(
              startTime: bookingStart,
              endTime: bookingEnd,
              subject: 'Taken',
              color: customColor),
        );
      }
    }
    return meetings;
  }

  Future<void> getPendingAppointments() async {
    if (widget.nutritionistId != '') {
      final docRef = FirebaseFirestore.instance
          .collection("appointment")
          .where(
            "doctorId",
            isEqualTo: widget.nutritionistId,
          )
          .withConverter(
            fromFirestore: Appointments.fromFirestore,
            toFirestore: (Appointments ptn, _) => ptn.toFirestore(),
          );
      await docRef.get().then(
        (querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            appointments = querySnapshot.docs;
          }
        },
      );
    }
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tabIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: tabIndex == 0
                                              ? customColor
                                              : Colors.grey,
                                          width: tabIndex == 0 ? 1 : 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'About',
                                      style: appstyle(
                                          15, Colors.black, FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tabIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: tabIndex != 0
                                              ? customColor
                                              : Colors.grey,
                                          width: tabIndex != 0 ? 1 : 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Schedules',
                                      style: appstyle(
                                          15, Colors.black, FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: tabIndex == 0
                                ? [
                                    Text(
                                      'About Me',
                                      style: appstyle(
                                          15, Colors.black, FontWeight.w600),
                                    ),
                                    Text(
                                      doctor!.about,
                                      style: appstyle(
                                          13, Colors.black, FontWeight.w500),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                    ),
                                    const Divider(thickness: 1),
                                    Text(
                                      'Specialization',
                                      style: appstyle(
                                          15, Colors.black, FontWeight.w600),
                                    ),
                                    Text(
                                      doctor!.specialties,
                                      style: appstyle(
                                          13, Colors.black, FontWeight.w500),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ]
                                : [
                                    SizedBox(
                                      height: 400,
                                      width: double.infinity,
                                      child: SfCalendar(
                                        controller: _calendarController,
                                        headerStyle: const CalendarHeaderStyle(
                                            textAlign: TextAlign.left),
                                        view: CalendarView.month,
                                        dataSource: AppointmentSchedules(
                                            getAppointments()),
                                        monthViewSettings:
                                            const MonthViewSettings(
                                          appointmentDisplayMode:
                                              MonthAppointmentDisplayMode
                                                  .indicator,
                                          showAgenda: true,
                                          appointmentDisplayCount: 5,
                                        ),
                                        initialSelectedDate: DateTime.now(),
                                      ),
                                    ),
                                  ],
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

class AppointmentSchedules extends CalendarDataSource {
  AppointmentSchedules(List<Appointment> source) {
    appointments = source;
  }
}
