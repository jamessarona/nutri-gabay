import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/ui/nutritionist_create_assessment_screen.dart';
import 'package:nutri_gabay/views/ui/nutritionist_view_assessment_screen.dart';

class NutritionAssessmentScreen extends StatefulWidget {
  final String appointmentId;
  const NutritionAssessmentScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  State<NutritionAssessmentScreen> createState() =>
      _NutritionAssessmentScreenState();
}

class _NutritionAssessmentScreenState extends State<NutritionAssessmentScreen> {
  late Size screenSize;

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
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  'Nutrition Assessment',
                  style: appstyle(18, customColor, FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('appointment')
                      .doc(widget.appointmentId)
                      .collection('assessment')
                      .orderBy('date')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Text('No Records');
                    }

                    int assessmentCount = 0;
                    return Column(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            assessmentCount++;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NutritionistViewAssessmentScreen(
                                      appointmentId: widget.appointmentId,
                                      assessmentId: data['id'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: customColor[10]),
                                height: 110,
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Assessment $assessmentCount",
                                      style: appstyle(
                                        20,
                                        Colors.black,
                                        FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      DateFormat('MMMM dd, yyyy')
                                          .format(data['date'].toDate()),
                                      style: appstyle(
                                        15,
                                        Colors.black,
                                        FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                          .toList()
                          .cast(),
                    );
                  }),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          height: 35,
          width: 140,
          child: UserCredentialSecondaryButton(
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NutritionistCreateAssessmentScreen(
                    appointmentId: widget.appointmentId,
                  ),
                ),
              );
            },
            label: "Reassessment",
            labelSize: 12,
            color: customColor,
          ),
        ),
      ),
    );
  }
}
