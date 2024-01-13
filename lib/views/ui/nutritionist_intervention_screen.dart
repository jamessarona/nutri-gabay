import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/ui/nutritionist_file_detail_screen.dart';

class NutritionistInterventionScreen extends StatefulWidget {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  const NutritionistInterventionScreen({
    super.key,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
  });

  @override
  State<NutritionistInterventionScreen> createState() =>
      _NutritionistInterventionScreenState();
}

class _NutritionistInterventionScreenState
    extends State<NutritionistInterventionScreen> {
  late Size screenSize;

  Future<void> getNewIntervention() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .where(
          "isSeen",
          isEqualTo: false,
        );

    await collection.get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await updateSeenInterventions(docSnapshot.data()["id"]);
        }
      },
    );
  }

  Future<void> updateSeenInterventions(String interventionId) async {
    await FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .doc(interventionId)
        .update(
      {'isSeen': true},
    );
  }

  @override
  void initState() {
    getNewIntervention();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: customColor[60],
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('appointment')
                .doc(widget.appointmentId)
                .collection('files')
                .orderBy('date', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return Container(
                        height: 80,
                        width: double.infinity,
                        margin:
                            const EdgeInsets.only(top: 3, left: 5, right: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      NutritionistFileDetailScreen(
                                        appointmentId: widget.appointmentId,
                                        doctorId: widget.doctorId,
                                        patientId: widget.patientId,
                                        fileId: data['id'],
                                        fileType: data['type'],
                                        fileUrl: data['url'],
                                        fileName: data['name'],
                                        domain1: data['domain1'],
                                        domain2: data['domain2'],
                                        domain3: data['domain3'],
                                        domain4: data['domain4'],
                                      )),
                            );
                          },
                          child: Card(
                            elevation: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: data['type'] == 'application/pdf'
                                        ? 10
                                        : 5),
                                Icon(
                                  data['type'] == 'application/pdf'
                                      ? FontAwesomeIcons.filePdf
                                      : FontAwesomeIcons.fileImage,
                                  color: data['type'] == 'application/pdf'
                                      ? const Color.fromARGB(255, 201, 126, 121)
                                      : const Color.fromARGB(
                                          255, 115, 163, 201),
                                  size: 50,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['type'] == 'application/pdf'
                                            ? 'PDF'
                                            : 'Image',
                                        style: appstyle(
                                            11, Colors.grey, FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        data['name'],
                                        style: appstyle(
                                            14, Colors.black, FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        'Informative',
                                        style: appstyle(
                                            11, Colors.grey, FontWeight.normal),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                    .toList()
                    .cast(),
              );
            },
          ),
        ),
      ),
    );
  }
}
