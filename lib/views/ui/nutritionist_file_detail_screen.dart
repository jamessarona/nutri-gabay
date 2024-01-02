import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_gabay/models/comment.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/models/patient_controller.dart';
import 'package:nutri_gabay/views/ui/nutritionist_file_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:nutri_gabay/views/shared/app_style.dart';

class NutritionistFileDetailScreen extends StatefulWidget {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String fileId;
  final String fileType;
  final String fileUrl;
  final String fileName;
  const NutritionistFileDetailScreen({
    super.key,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.fileId,
    required this.fileType,
    required this.fileUrl,
    required this.fileName,
  });

  @override
  State<NutritionistFileDetailScreen> createState() =>
      _NutritionistFileDetailScreenState();
}

class _NutritionistFileDetailScreenState
    extends State<NutritionistFileDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  late Size screenSize;
  Patient? patient;
  Doctor? doctor;

  Future<void> submitComment() async {
    if (_formKey.currentState!.validate()) {
      await saveToFirebase();
    }
  }

  Future<void> saveToFirebase() async {
    final docComment = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .doc(widget.fileId)
        .collection('comments')
        .doc();
    Comment comment = Comment(
      id: docComment.id,
      isPatient: true,
      text: _commentController.text,
      date: DateTime.now(),
      isSeen: false,
    );

    final formJson = comment.toJson();
    await docComment.set(formJson);
  }

  Future<void> getDoctorInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("doctor")
        .doc(widget.doctorId)
        .withConverter(
          fromFirestore: Doctor.fromFirestore,
          toFirestore: (Doctor dtr, _) => dtr.toFirestore(),
        );

    final docSnap = await ref.get();
    doctor = docSnap.data()!;
    setState(() {});
  }

  Future<void> getPatientInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("patient")
        .doc(widget.patientId)
        .withConverter(
          fromFirestore: Patient.fromFirestore,
          toFirestore: (Patient pt, _) => pt.toFirestore(),
        );

    final docSnap = await ref.get();
    patient = docSnap.data()!;
    setState(() {});
  }

  Future<void> getNewComments() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .doc(widget.fileId)
        .collection('comments')
        .where(
          Filter.and(
            Filter("isPatient", isEqualTo: false),
            Filter(
              "isSeen",
              isEqualTo: false,
            ),
          ),
        );

    await collection.get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await updateSeenComments(docSnapshot.data()["id"]);
        }
      },
    );
  }

  Future<void> updateSeenComments(String commentId) async {
    await FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .doc(widget.fileId)
        .collection('comments')
        .doc(commentId)
        .update(
      {'isSeen': true},
    );
  }

  @override
  void initState() {
    getNewComments();
    getDoctorInfo();
    getPatientInfo();
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
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: patient == null || doctor == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => NutritionistFileScreen(
                                    fileType: widget.fileType,
                                    fileUrl: widget.fileUrl,
                                    fileName: widget.fileName,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width:
                                          widget.fileType == 'application/pdf'
                                              ? 10
                                              : 5),
                                  Icon(
                                    widget.fileType == 'application/pdf'
                                        ? FontAwesomeIcons.filePdf
                                        : FontAwesomeIcons.fileImage,
                                    color: widget.fileType == 'application/pdf'
                                        ? const Color.fromARGB(
                                            255, 201, 126, 121)
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
                                          widget.fileType == 'application/pdf'
                                              ? 'PDF'
                                              : 'Image',
                                          style: appstyle(
                                              11, Colors.grey, FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          widget.fileName,
                                          style: appstyle(14, Colors.black,
                                              FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          'Informative',
                                          style: appstyle(11, Colors.grey,
                                              FontWeight.normal),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Comments',
                              style:
                                  appstyle(13, Colors.black, FontWeight.normal),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('appointment')
                                    .doc(widget.appointmentId)
                                    .collection('files')
                                    .doc(widget.fileId)
                                    .collection('comments')
                                    .orderBy("date", descending: false)
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
                                          Map<String, dynamic> data = document
                                              .data()! as Map<String, dynamic>;
                                          return Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: CircleAvatar(
                                                    radius: 30.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            data['isPatient'] ==
                                                                    true
                                                                ? patient!.image
                                                                : doctor!
                                                                    .image),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                SizedBox(
                                                  width: screenSize.width * 0.7,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data['isPatient'] ==
                                                                true
                                                            ? '${patient!.firstname} ${patient!.lastname}'
                                                            : doctor!.name,
                                                        style: appstyle(
                                                            12,
                                                            Colors.black,
                                                            FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        data['text'],
                                                        style: appstyle(
                                                            12,
                                                            Colors.black,
                                                            FontWeight.normal),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                      Text(
                                                        timeago.format(
                                                          data['date'].toDate(),
                                                        ),
                                                        style: appstyle(
                                                            10,
                                                            Colors.black,
                                                            FontWeight.normal),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                        .toList()
                                        .cast(),
                                  );
                                }),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add a Comment:',
                                  style: appstyle(
                                      13, Colors.black, FontWeight.normal),
                                ),
                                const SizedBox(height: 5),
                                Form(
                                  key: _formKey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 40,
                                          child: TextFormField(
                                            controller: _commentController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value == '') {
                                                return 'please add a comment';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: const BorderSide(
                                                    color: customColor),
                                              ),
                                              hintStyle: appstyle(
                                                  12,
                                                  Colors.black,
                                                  FontWeight.w500),
                                              labelStyle: appstyle(
                                                  12,
                                                  Colors.black,
                                                  FontWeight.w500),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      IconButton(
                                          onPressed: () async {
                                            await submitComment().then((value) {
                                              _commentController.clear();
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.arrow_circle_right_rounded,
                                            size: 30,
                                            color: customColor,
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
