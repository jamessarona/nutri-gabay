import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay/models/appointment_controller.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/models/patient_controller.dart';
import 'package:nutri_gabay/models/patient_nutrition_controller.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/custom_container.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';
import 'package:nutri_gabay/views/ui/success_booking_screen.dart';
import 'package:time_range_picker/time_range_picker.dart';

class NutritionistBookingScreen extends StatefulWidget {
  final String nutritionistId;
  const NutritionistBookingScreen({super.key, required this.nutritionistId});

  @override
  State<NutritionistBookingScreen> createState() =>
      _NutritionistBookingScreenState();
}

class _NutritionistBookingScreenState extends State<NutritionistBookingScreen> {
  late Size screenSize;
  static int maxNotes = 400;

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
  final TextEditingController _notes = TextEditingController();

  DateTime? bookingDate;
  TimeRange? bookingTimeRange;

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
    _name.text = '${patient!.firstname} ${patient!.lastname}';
    setState(() {});
  }

  void getPatientNutritionInfo() async {
    String uid = await FireBaseAuth().currentUser();
    final collection = FirebaseFirestore.instance
        .collection('patient_nutritional_profile')
        .where("uid", isEqualTo: uid)
        .withConverter(
          fromFirestore: PatientNutrition.fromFirestore,
          toFirestore: (PatientNutrition pn, _) => pn.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (uid == docSnapshot.data().uid) {
            patientNutrition = docSnapshot.data();
            _bmi.text = patientNutrition!.bmi.toStringAsFixed(2);
            _status.text = patientNutrition!.status;
            _riskLevel.text = patientNutrition!.result;
            _sex.text = patientNutrition!.sex;
            _age.text = patientNutrition!.age.toStringAsFixed(0);
            _height.text = patientNutrition!.height.toStringAsFixed(2);
            setState(() {});
            break;
          }
        }
      },
    );
  }

  String formatTimeRange() {
    String result = '';
    if (bookingTimeRange != null) {
      if (bookingTimeRange!.startTime.hour > 12) {
        result =
            '${bookingTimeRange!.startTime.hour - 12} - ${bookingTimeRange!.endTime.hour - 12} PM';
      } else if (bookingTimeRange!.endTime.hour < 13) {
        result =
            '${bookingTimeRange!.startTime.hour} - ${bookingTimeRange!.endTime.hour} AM';
      } else {
        result =
            '${bookingTimeRange!.startTime.hour} AM - ${bookingTimeRange!.endTime.hour} PM';
      }
    }
    return result;
  }

  void validateBooking() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .where("doctorId", isEqualTo: doctor!.uid)
        .withConverter(
          fromFirestore: Appointments.fromFirestore,
          toFirestore: (Appointments apmt, _) => apmt.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        bool isValid = true;
        for (var docSnapshot in querySnapshot.docs) {
          Appointments appointment = docSnapshot.data();
          DateTime bookingDate =
              DateFormat('MM/dd/yyyy').parse(appointment.dateSchedule);

          if (bookingDate == this.bookingDate) {
            // check if conflict selected schedule to all schedules
            isValid = !((bookingTimeRange!.startTime.hour >=
                        appointment.hourStart &&
                    bookingTimeRange!.startTime.hour <= appointment.hourEnd) ||
                (bookingTimeRange!.endTime.hour >= appointment.hourStart &&
                    bookingTimeRange!.endTime.hour <= appointment.hourEnd));
          }
          if (!isValid) break;
        }
        if (isValid) {
          saveBooking().then((value) {
            //redirect to pending screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const SuccessBookingScreen()),
            );
          });
        } else {
          final snackBar = SnackBar(
            content: Text(
              'Selected schedule was already book by someone else',
              style: appstyle(12, Colors.white, FontWeight.normal),
            ),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  Future<void> saveBooking() async {
    final appointmentDoc =
        FirebaseFirestore.instance.collection('appointment').doc();

    Appointments appointment = Appointments(
      id: appointmentDoc.id,
      dateRecorded: DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now()),
      dateSchedule: DateFormat('MM/dd/yyyy').format(bookingDate!),
      hourStart: bookingTimeRange!.startTime.hour,
      hourEnd: bookingTimeRange!.endTime.hour,
      patientId: patient!.uid,
      patientNutritionalId: patientNutrition!.id,
      doctorId: doctor!.uid,
      notes: _notes.text,
      status: 'Pending',
    );

    final json = appointment.toJson();
    await appointmentDoc.set(json);
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
                                        width: 110,
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
                                        width: 130,
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
                            'Reason for your consultation?',
                            style:
                                appstyle(12, Colors.black, FontWeight.normal),
                          ),
                          const Divider(thickness: 1),
                          BookingLongTextField(
                              controller: _notes,
                              label: '',
                              isObscure: false,
                              keyboardType: TextInputType.text,
                              maxLines: 10,
                              isEditable: true,
                              onChanged: (value) {
                                if (value.length > 400) {
                                  _notes.text = value.substring(0, maxNotes);
                                }
                                setState(() {});
                              }),
                          const SizedBox(height: 5),
                          Text(
                            '${maxNotes - _notes.text.length} character${maxNotes - _notes.text.length > 1 ? 's' : ''} left',
                            style:
                                appstyle(11, Colors.black45, FontWeight.normal)
                                    .copyWith(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Set Date',
                                    style: appstyle(
                                      15,
                                      Colors.black,
                                      FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  BookingContainerButton(
                                    label: bookingDate == null
                                        ? 'Select date'
                                        : DateFormat('MM/dd/yyyy')
                                            .format(bookingDate!),
                                    icon: Icons.calendar_month_outlined,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: customColor,
                                                onPrimary: Colors.white,
                                                onSurface: Colors.black,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );

                                      if (pickedDate != null) {
                                        bookingDate = pickedDate;
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(
                                    'Set Time',
                                    style: appstyle(
                                      15,
                                      Colors.black,
                                      FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  BookingContainerButton(
                                    label: bookingTimeRange == null
                                        ? 'Select time'
                                        : formatTimeRange(),
                                    icon: Icons.av_timer_outlined,
                                    onTap: () async {
                                      TimeRange? selectedTimeRange =
                                          await showTimeRangePicker(
                                              context: context,
                                              start: TimeOfDay(
                                                  hour: DateTime.now().hour,
                                                  minute: 0),
                                              end: TimeOfDay(
                                                  hour: DateTime.now().hour + 1,
                                                  minute: 0),
                                              disabledTime: DateUtils.isSameDay(
                                                      bookingDate,
                                                      DateTime.now())
                                                  ? TimeRange(
                                                      startTime:
                                                          const TimeOfDay(
                                                              hour: 0,
                                                              minute: 0),
                                                      endTime: TimeOfDay(
                                                          hour: DateTime.now()
                                                              .hour,
                                                          minute: 0))
                                                  : null,
                                              disabledColor:
                                                  Colors.red.withOpacity(0.5),
                                              interval:
                                                  const Duration(hours: 1),
                                              minDuration:
                                                  const Duration(hours: 1),
                                              use24HourFormat: false,
                                              strokeWidth: 4,
                                              ticks: 24,
                                              ticksOffset: -7,
                                              ticksLength: 15,
                                              ticksColor: Colors.grey,
                                              labels: [
                                                "12 am",
                                                "3 am",
                                                "6 am",
                                                "9 am",
                                                "12 pm",
                                                "3 pm",
                                                "6 pm",
                                                "9 pm"
                                              ].asMap().entries.map((e) {
                                                return ClockLabel.fromIndex(
                                                    idx: e.key,
                                                    length: 8,
                                                    text: e.value);
                                              }).toList(),
                                              labelOffset: 35,
                                              rotateLabels: false,
                                              padding: 60);
                                      if (selectedTimeRange != null) {
                                        bookingTimeRange = selectedTimeRange;
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              width: 150,
                              child: UserCredentialPrimaryButton(
                                  onPress: () {
                                    if (bookingDate != null &&
                                        bookingTimeRange != null) {
                                      // check if there is no conflict schedule
                                      validateBooking();
                                    } else {
                                      //show error through snackbar
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'Please select your schedule',
                                          style: appstyle(13, Colors.white,
                                              FontWeight.normal),
                                        ),
                                        action: SnackBarAction(
                                          label: 'Close',
                                          onPressed: () {},
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  label: 'Book',
                                  labelSize: 18),
                            ),
                          )
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
