import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutri_gabay/models/appointment_controller.dart';
import 'package:nutri_gabay/models/doctor.dart';
import 'package:nutri_gabay/models/message_controller.dart';
import 'package:nutri_gabay/models/patient_controller.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;
  final String appointmentId;
  const ChatScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Doctor? doctor;
  Patient? patient;
  Appointment? appointment;

  TextEditingController textController = TextEditingController();

  void getAppointmentInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("appointment")
        .doc(widget.appointmentId)
        .withConverter(
          fromFirestore: Appointment.fromFirestore,
          toFirestore: (Appointment appointment, _) =>
              appointment.toFirestore(),
        );
    final docSnap = await ref.get();
    appointment = docSnap.data()!;
    setState(() {});
  }

  void getDoctortInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("doctor")
        .doc(widget.doctorId)
        .withConverter(
          fromFirestore: Doctor.fromFirestore,
          toFirestore: (Doctor doctor, _) => doctor.toFirestore(),
        );
    final docSnap = await ref.get();
    doctor = docSnap.data()!;
    setState(() {});
  }

  void getPatientInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("patient")
        .doc(widget.patientId)
        .withConverter(
          fromFirestore: Patient.fromFirestore,
          toFirestore: (Patient patient, _) => patient.toFirestore(),
        );
    final docSnap = await ref.get();
    patient = docSnap.data()!;
    setState(() {});
  }

  Future<void> sendMessage() async {
    if (textController.text.isNotEmpty) {
      final messageDoc = FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.appointmentId)
          .collection('chat')
          .doc();

      Message message = Message(
          id: messageDoc.id,
          senderId: widget.patientId,
          receiverId: widget.doctorId,
          content: textController.text,
          sentTime: DateTime.now(),
          messageType: MessageType.text);
      final json = message.toJson();

      await messageDoc.set(json);
      setState(() {});
    }
    textController.clear();
    // ignore: use_build_context_synchronously
    FocusScope.of(context).unfocus();
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      final messageDoc = FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.appointmentId)
          .collection('chat')
          .doc();

      Message message = Message(
          id: messageDoc.id,
          senderId: widget.patientId,
          receiverId: widget.doctorId,
          content: '',
          sentTime: DateTime.now(),
          messageType: MessageType.image);
      final json = message.toJson();

      await messageDoc.set(json);
      uploadImage(message.id, File(image.path));
    }
  }

  Future<void> uploadImage(String messageId, File image) async {
    final firebaseStorage = FirebaseStorage.instance;
    var snapshot = await firebaseStorage
        .ref()
        .child('images/chat/$messageId')
        .putFile(File(image.path));

    var downloadUrl = await snapshot.ref.getDownloadURL();

    saveImageToDatabase(messageId, downloadUrl);
  }

  saveImageToDatabase(String messageId, String url) async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('chat');

    await collection.doc(messageId).update({"content": url});
    setState(() {});
  }

  @override
  void initState() {
    getAppointmentInfo();
    getDoctortInfo();
    getPatientInfo();
    super.initState();
  }

  List<dynamic>? messages;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: appointment == null || doctor == null || patient == null
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.2))),
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
                title: Row(
                  children: [
                    Container(
                      height: 35,
                      margin: const EdgeInsets.only(right: 10),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            child: Image.network(
                              doctor!.image,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  color: doctor!.isOnline
                                      ? Colors.green
                                      : Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor!.name,
                            style: appstyle(15, Colors.black, FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            doctor!.isOnline
                                ? 'Active'
                                : 'Active ${timeago.format(doctor!.lastActive, locale: 'en_short')} ago',
                            style: appstyle(
                              11,
                              doctor!.isOnline ? Colors.green : Colors.black87,
                              FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesomeIcons.phone,
                      size: 20,
                      color: customColor,
                    ),
                  ),
                ],
              ),
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('appointment')
                            .doc(widget.appointmentId)
                            .collection('chat')
                            .orderBy('sentTime', descending: true)
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                          messages = snapshot.data!.docs
                              .map((doc) => Message.fromJson(doc.data()))
                              .toList();
                          return ListView.builder(
                            itemCount: messages!.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return Align(
                                alignment: messages![index].senderId ==
                                        widget.patientId
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    right: 10,
                                    left: 10,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: messages![index].senderId ==
                                            widget.patientId
                                        ? customColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(30),
                                      topRight: const Radius.circular(30),
                                      bottomLeft: Radius.circular(
                                        messages![index].senderId ==
                                                widget.patientId
                                            ? 30
                                            : 0,
                                      ),
                                      bottomRight: Radius.circular(
                                        messages![index].senderId !=
                                                widget.patientId
                                            ? 30
                                            : 0,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        messages![index].senderId ==
                                                widget.patientId
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      messages![index].messageType ==
                                              MessageType.text
                                          ? Text(
                                              messages![index].content,
                                              style: appstyle(13, Colors.black,
                                                  FontWeight.normal),
                                            )
                                          : Container(
                                              height: 200,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                      messages![index].content,
                                                    ),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                      const SizedBox(height: 3),
                                      Text(
                                        timeago
                                            .format(messages![index].sentTime),
                                        style: appstyle(
                                          9,
                                          Colors.black,
                                          FontWeight.normal,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await pickImage();
                            },
                            icon: const Icon(
                              FontAwesomeIcons.image,
                              size: 20,
                              color: customColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 5),
                              child: TextFormField(
                                controller: textController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  ),
                                  errorStyle: appstyle(
                                      0, Colors.red, FontWeight.normal),
                                  filled: true,
                                  hintText: 'Message',
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10.0),
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await sendMessage();
                            },
                            icon: const Icon(
                              FontAwesomeIcons.circleArrowRight,
                              size: 20,
                              color: customColor,
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
