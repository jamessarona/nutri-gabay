import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/custom_card.dart';

class NutritionistBookingListScreen extends StatefulWidget {
  final String appointmentId;
  final String nutritionistId;
  final String nutritionistName;
  final String patientId;
  const NutritionistBookingListScreen({
    super.key,
    required this.appointmentId,
    required this.nutritionistId,
    required this.nutritionistName,
    required this.patientId,
  });

  @override
  State<NutritionistBookingListScreen> createState() =>
      _NutritionistBookingListScreenState();
}

class _NutritionistBookingListScreenState
    extends State<NutritionistBookingListScreen> {
  late Size screenSize;
  List<QueryDocumentSnapshot<Doctor>>? doctors;

  Future<void> getPatientId() async {
    setState(() {});
  }

  Future<void> getNutritionist() async {
    final docRef =
        FirebaseFirestore.instance.collection("doctor").withConverter(
              fromFirestore: Doctor.fromFirestore,
              toFirestore: (Doctor dr, _) => dr.toFirestore(),
            );
    await docRef.get().then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          doctors = querySnapshot.docs;
          setState(() {});
        }
      },
    );
  }

  String getNutritionistInfoByField(String doctorId, String field) {
    String result = '';
    if (doctors != null) {
      for (var doctor in doctors!) {
        if (doctorId == doctor.data().uid) {
          if (field == 'name') {
            result = doctor.data().name;
          } else if (field == 'phone') {
            result = doctor.data().phone;
          } else if (field == 'email') {
            result = doctor.data().email;
          } else if (field == 'image') {
            result = doctor.data().image;
          }
          break;
        }
      }
    }
    return result;
  }

  @override
  void initState() {
    getPatientId();
    getNutritionist();
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
          child: doctors == null
              ? Container()
              : ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                          left: screenSize.width * 0.03,
                          right: screenSize.width * 0.03),
                      child: Text(
                        widget.nutritionistName,
                        style: appstyle(15, Colors.grey, FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('appointment')
                            .where(
                              Filter.and(
                                  Filter("patientId",
                                      isEqualTo: widget.patientId),
                                  Filter("doctorId",
                                      isEqualTo: widget.nutritionistId)),
                            )
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Text('No Records');
                          }
                          return Column(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;

                                  return MyNutritionistListTile(
                                    screenSize: screenSize,
                                    appointmentId: data['id'],
                                    image: getNutritionistInfoByField(
                                        data['doctorId'], 'image'),
                                    name: getNutritionistInfoByField(
                                        data['doctorId'], 'name'),
                                    nutritionistId: data['doctorId'],
                                    patientId: data['patientId'],
                                    date: data['dateSchedule'],
                                    hourStart: data['hourStart'],
                                    hourEnd: data['hourEnd'],
                                    isDisplayOnly: false,
                                    displayType: 2,
                                  );
                                })
                                .toList()
                                .cast(),
                          );
                        }),
                  ],
                ),
        ),
      ),
    );
  }
}
