import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay/models/question.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class AnsweredQuestionScreen extends StatefulWidget {
  final String appointmentId;
  final String formId;
  final String name;
  final DateTime date;
  const AnsweredQuestionScreen(
      {super.key,
      required this.appointmentId,
      required this.formId,
      required this.name,
      required this.date});

  @override
  State<AnsweredQuestionScreen> createState() => _AnsweredQuestionScreenState();
}

class _AnsweredQuestionScreenState extends State<AnsweredQuestionScreen> {
  late Size screenSize;

  List<Question> questions = [];

  Future<void> getQuestions() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('form')
        .doc(widget.formId)
        .collection('questions')
        .withConverter(
          fromFirestore: Question.fromFirestore,
          toFirestore: (Question question, _) => question.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          questions.add(docSnapshot.data());
        }
      },
    );
    questions.sort((a, b) => a.number.compareTo(b.number));
    setState(() {});
  }

  @override
  void initState() {
    getQuestions();
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
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: customColor[50]),
                  height: 110,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: appstyle(
                          20,
                          Colors.white,
                          FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(widget.date),
                        style: appstyle(
                          15,
                          Colors.white,
                          FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  color: customColor[60],
                  height: 185 * questions.length.toDouble(),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: questions.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(questions.length, (index) {
                            return Container(
                              height: 170,
                              width: 1000,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 7.5, horizontal: 5),
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: RichText(
                                        maxLines: 3,
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(
                                          text:
                                              '${questions[index].number.toString()}. ${questions[index].question}',
                                          style: appstyle(15, Colors.black,
                                              FontWeight.normal),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: questions[index].required
                                                  ? ' *'
                                                  : '',
                                              style: appstyle(15, Colors.red,
                                                  FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        style: appstyle(14, Colors.black,
                                            FontWeight.normal),
                                        validator: (value) {
                                          if (value == '' &&
                                              questions[index].required) {
                                            return 'Please answer the question';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          filled: false,
                                          hintText: 'Your answer',
                                          hintStyle: appstyle(13, Colors.black,
                                              FontWeight.normal),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 5),
                                        ),
                                        initialValue: questions[index].answer,
                                        enabled: false,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            );
                          }),
                        )
                      : Container(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
