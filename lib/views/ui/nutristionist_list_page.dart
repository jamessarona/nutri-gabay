import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/controllers/mainscreen_provider.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/shared/custom_card.dart';
import 'package:provider/provider.dart';

class MyNutritionistListPage extends StatefulWidget {
  const MyNutritionistListPage({super.key});

  @override
  State<MyNutritionistListPage> createState() => _MyNutritionistListPageState();
}

class _MyNutritionistListPageState extends State<MyNutritionistListPage> {
  String? uid;
  late Size screenSize;
  List<QueryDocumentSnapshot<Doctor>>? doctors;

  Future<void> getPatientId() async {
    uid = await FireBaseAuth().currentUser();
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
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: uid == null || doctors == null
                  ? Container()
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('appointment')
                          .where(
                            "patientId",
                            isEqualTo: uid,
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
                        return snapshot.data!.docs.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 150,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/logo.png"),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Book a nutritionist now!',
                                    style: appstyle(
                                        15, Colors.black, FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 150,
                                    child: UserCredentialPrimaryButton(
                                        onPress: () {
                                          mainScreenNotifier.pageIndex = 1;
                                        },
                                        label: 'Proceed',
                                        labelSize: 14),
                                  ),
                                ],
                              )
                            : ListView(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;

                                      return MyNutritionistListTile(
                                        screenSize: screenSize,
                                        image: getNutritionistInfoByField(
                                            data['doctorId'], 'image'),
                                        name: getNutritionistInfoByField(
                                            data['doctorId'], 'name'),
                                        nutritionistId: data['doctorId'],
                                      );
                                    })
                                    .toList()
                                    .cast(),
                              );
                      }),
            ),
          ),
        );
      },
    );
  }
}
