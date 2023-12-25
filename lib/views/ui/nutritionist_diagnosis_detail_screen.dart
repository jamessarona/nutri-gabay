import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/diagnosis.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/custom_container.dart';

class NutritionistDiagnosisDetailScreen extends StatefulWidget {
  final String appointmentId;
  final String diagnosisId;
  const NutritionistDiagnosisDetailScreen({
    super.key,
    required this.appointmentId,
    required this.diagnosisId,
  });

  @override
  State<NutritionistDiagnosisDetailScreen> createState() =>
      _NutritionistDiagnosisDetailScreenState();
}

class _NutritionistDiagnosisDetailScreenState
    extends State<NutritionistDiagnosisDetailScreen> {
  late Size screenSize;
  final TextEditingController _domain1Controller = TextEditingController();
  final TextEditingController _domain2Controller = TextEditingController();
  final TextEditingController _domain3Controller = TextEditingController();
  final TextEditingController _domain4Controller = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _statementController = TextEditingController();

  Diagnosis? diagnosis;

  Future<void> getDiagnosis() async {
    final ref = FirebaseFirestore.instance
        .collection("appointment")
        .doc(widget.appointmentId)
        .collection("diagnosis")
        .doc(widget.diagnosisId)
        .withConverter(
          fromFirestore: Diagnosis.fromFirestore,
          toFirestore: (Diagnosis diag, _) => diag.toFirestore(),
        );
    final docSnap = await ref.get();
    diagnosis = docSnap.data()!;

    _domain1Controller.text = diagnosis!.domain1;
    _domain2Controller.text = diagnosis!.domain2;
    _domain3Controller.text = diagnosis!.domain3;
    _domain4Controller.text = diagnosis!.domain4;
    _problemController.text = diagnosis!.problem;
    _statementController.text = diagnosis!.statement;

    setState(() {});
  }

  @override
  void initState() {
    getDiagnosis();
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
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  'Diagnosis',
                  style: appstyle(18, customColor, FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: diagnosis == null
                      ? []
                      : [
                          Text(
                            'DOMAIN',
                            style: appstyle(15, Colors.black, FontWeight.bold)
                                .copyWith(fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _domain1Controller.text == ''
                                    ? Container()
                                    : DiagnosisDomainContainer(
                                        controller: _domain1Controller,
                                        validation: (value) {
                                          return null;
                                        },
                                        isEdit: false,
                                      ),
                                _domain2Controller.text == ''
                                    ? Container()
                                    : const SizedBox(width: 15),
                                _domain2Controller.text == ''
                                    ? Container()
                                    : DiagnosisDomainContainer(
                                        controller: _domain2Controller,
                                        validation: (value) {
                                          return null;
                                        },
                                        isEdit: false,
                                      ),
                                _domain3Controller.text == ''
                                    ? Container()
                                    : const SizedBox(width: 15),
                                _domain3Controller.text == ''
                                    ? Container()
                                    : DiagnosisDomainContainer(
                                        controller: _domain3Controller,
                                        validation: (value) {
                                          return null;
                                        },
                                        isEdit: false,
                                      ),
                                _domain4Controller.text == ''
                                    ? Container()
                                    : const SizedBox(width: 15),
                                _domain4Controller.text == ''
                                    ? Container()
                                    : DiagnosisDomainContainer(
                                        controller: _domain4Controller,
                                        validation: (value) {
                                          return null;
                                        },
                                        isEdit: false,
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Nutrition Problem(s)',
                              style:
                                  appstyle(15, Colors.black, FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 150),
                            child: Text(
                              diagnosis!.problem,
                              style: appstyle(
                                14,
                                Colors.black,
                                FontWeight.normal,
                              ),
                            ),
                          ),
                          const Divider(),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'PES STATEMENT(S)',
                              style:
                                  appstyle(15, Colors.black, FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Problem related to Etiology as evidenced by signs and symptoms',
                              style:
                                  appstyle(14, Colors.black, FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 150),
                            child: Text(
                              diagnosis!.statement,
                              style: appstyle(
                                14,
                                Colors.black,
                                FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
