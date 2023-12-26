import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/assessment.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';

class NutritionistViewAssessmentScreen extends StatefulWidget {
  final String appointmentId;
  final String assessmentId;
  const NutritionistViewAssessmentScreen({
    super.key,
    required this.appointmentId,
    required this.assessmentId,
  });

  @override
  State<NutritionistViewAssessmentScreen> createState() =>
      _NutritionistViewAssessmentScreenState();
}

class _NutritionistViewAssessmentScreenState
    extends State<NutritionistViewAssessmentScreen> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _situationController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _relatedHistoryController =
      TextEditingController();
  final TextEditingController _changeController = TextEditingController();
  final TextEditingController _successController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _proceduresController = TextEditingController();
  final TextEditingController _measurementsController = TextEditingController();
  final TextEditingController _findingsController = TextEditingController();
  final TextEditingController _standardController = TextEditingController();

  int formIndex = 0;
  bool isEditable = false;

  Assessment? assessment;

  void validateFirstForm() {
    if (_formKey1.currentState!.validate()) {
      formIndex = 1;

      setState(() {});
    }
  }

  void returnFirstForm() {
    formIndex = 0;

    setState(() {});
  }

  Future<void> getAssessment() async {
    final ref = FirebaseFirestore.instance
        .collection("appointment")
        .doc(widget.appointmentId)
        .collection('assessment')
        .doc(widget.assessmentId)
        .withConverter(
          fromFirestore: Assessment.fromFirestore,
          toFirestore: (Assessment asmt, _) => asmt.toFirestore(),
        );
    final docSnap = await ref.get();
    assessment = docSnap.data()!;

    _historyController.text = assessment!.history;
    _situationController.text = assessment!.situation;
    _occupationController.text = assessment!.occupation;
    _relatedHistoryController.text = assessment!.relatedHistory;

    _changeController.text = assessment!.change.toString();
    _successController.text = assessment!.success.toString();
    _startController.text = assessment!.start.toString();
    _proceduresController.text = assessment!.procedures;
    _measurementsController.text = assessment!.measurements;
    _findingsController.text = assessment!.findings;
    _standardController.text = assessment!.standards;
    setState(() {});
  }

  @override
  void initState() {
    getAssessment();
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
          backgroundColor: Colors.white,
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
          child: assessment == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Nutrition Assessment',
                        style: appstyle(18, customColor, FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: formIndex == 0
                            ? Form(
                                key: _formKey1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Client History (CH)',
                                      style: appstyle(
                                              14, Colors.black, FontWeight.bold)
                                          .copyWith(
                                              fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                        'Patient/client or family nutrition‐oriented medical/health history:',
                                        style: appstyle(13, Colors.black,
                                            FontWeight.normal)),
                                    const SizedBox(height: 10),
                                    BookingLongTextField(
                                      controller: _historyController,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 4,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    Text('Living/housing situation:',
                                        style: appstyle(13, Colors.black,
                                            FontWeight.normal)),
                                    const SizedBox(height: 10),
                                    BookingLongTextField(
                                      controller: _situationController,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 2,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    Text('Occupation:',
                                        style: appstyle(13, Colors.black,
                                            FontWeight.normal)),
                                    const SizedBox(height: 10),
                                    BookingLongTextField(
                                      controller: _occupationController,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 1,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                        'Food/ Nutrition‐ Related History (FH)',
                                        style: appstyle(
                                            13, Colors.black, FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    BookingLongTextField(
                                      controller: _relatedHistoryController,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 7,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                        'Readiness to change nutrition‐related behaviors: Motivation (Scales 1‐10)',
                                        style: appstyle(13, Colors.black,
                                            FontWeight.normal)),
                                    const SizedBox(height: 10),
                                    AssessmentLabeledTextField(
                                      controller: _changeController,
                                      label:
                                          'I think it is important to make change',
                                      keyboardType: TextInputType.number,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        if (int.parse(value) < 0) {
                                          _changeController.text = '0';
                                        } else if (int.parse(value) > 10) {
                                          _changeController.text = '10';
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    AssessmentLabeledTextField(
                                      controller: _successController,
                                      label: 'I am sure that I will success',
                                      keyboardType: TextInputType.number,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        if (int.parse(value) < 0) {
                                          _successController.text = '0';
                                        } else if (int.parse(value) > 10) {
                                          _successController.text = '10';
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    AssessmentLabeledTextField(
                                      controller: _startController,
                                      label: 'I am ready to start',
                                      keyboardType: TextInputType.number,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        if (int.parse(value) < 0) {
                                          _startController.text = '0';
                                        } else if (int.parse(value) > 10) {
                                          _startController.text = '10';
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'PAGE | 1',
                                          style: appstyle(13, Colors.black,
                                              FontWeight.normal),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 80,
                                          child: UserCredentialSecondaryButton(
                                            onPress: () {
                                              validateFirstForm();
                                            },
                                            label: "Next",
                                            labelSize: 12,
                                            color: customColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              )
                            : Form(
                                key: _formKey2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Biochemical Data, Medical Tests and Procedures (BD)',
                                      style: appstyle(
                                              14, Colors.black, FontWeight.bold)
                                          .copyWith(
                                              fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(height: 10),
                                    BookingLongTextField(
                                      controller: _proceduresController,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Anthropometric Measurements (AD)',
                                      style: appstyle(
                                              14, Colors.black, FontWeight.bold)
                                          .copyWith(
                                              fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(height: 10),
                                    BookingLongTextField(
                                      controller: _measurementsController,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 4,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Nutrition‐ Focused Physical Findings (PD)',
                                      style: appstyle(
                                              14, Colors.black, FontWeight.bold)
                                          .copyWith(
                                              fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(height: 10),
                                    BookingLongTextField(
                                      controller: _findingsController,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 4,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Comparative Standards (CS)',
                                      style: appstyle(
                                              14, Colors.black, FontWeight.bold)
                                          .copyWith(
                                              fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(height: 10),
                                    BookingLongTextField(
                                      controller: _standardController,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 4,
                                      isEditable: isEditable,
                                      validation: (value) {
                                        if (value == '') {
                                          return "";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'PAGE | 2',
                                          style: appstyle(13, Colors.black,
                                              FontWeight.normal),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 80,
                                          child: UserCredentialSecondaryButton(
                                            onPress: () {
                                              returnFirstForm();
                                            },
                                            label: "Back",
                                            labelSize: 12,
                                            color: customColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
