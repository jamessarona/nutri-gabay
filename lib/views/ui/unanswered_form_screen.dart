import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/ui/unanswered_question_screen.dart';

class UnansweredFormScreen extends StatefulWidget {
  final String appointmentId;
  const UnansweredFormScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  State<UnansweredFormScreen> createState() => _UnansweredFormScreenState();
}

class _UnansweredFormScreenState extends State<UnansweredFormScreen> {
  late Size screenSize;
  Future<void> getNewEvaluation() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('form')
        .where("answered", isEqualTo: false);

    await collection.get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await updateSeenEvaluation(docSnapshot.data()["id"]);
        }
      },
    );
  }

  Future<void> updateSeenEvaluation(String evaluationId) async {
    await FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('form')
        .doc(evaluationId)
        .update(
      {'answered': true},
    );
  }

  @override
  void initState() {
    getNewEvaluation();
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
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
              height: 40,
              width: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo-name.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Monitoring and Evaluation',
                  style: appstyle(
                    14,
                    Colors.black,
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('appointment')
                          .doc(widget.appointmentId)
                          .collection('form')
                          .orderBy(
                            "date",
                            descending: true,
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
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UnansweredQuestionScreen(
                                          appointmentId: widget.appointmentId,
                                          formId: data['id'],
                                          name: data['name'],
                                          date: data['date'].toDate(),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['name'],
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
