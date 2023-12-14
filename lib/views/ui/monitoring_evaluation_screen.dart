import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/ui/answered_form_screen.dart';
import 'package:nutri_gabay/views/ui/unanswered_form_screen.dart';

class MonitoringEvaluationScreen extends StatefulWidget {
  final String appointmentId;
  const MonitoringEvaluationScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  State<MonitoringEvaluationScreen> createState() =>
      _MonitoringEvaluationScreenState();
}

class _MonitoringEvaluationScreenState
    extends State<MonitoringEvaluationScreen> {
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnsweredFormScreen(
                            appointmentId: widget.appointmentId),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: customColor[50]),
                    height: 110,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 15, bottom: 15),
                            child: Image.asset('assets/icons/answered.png')),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Anwsered\nForm',
                            style: appstyle(30, Colors.white, FontWeight.bold),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UnansweredFormScreen(
                            appointmentId: widget.appointmentId),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: customColor[10]),
                    height: 110,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 15, bottom: 15),
                            child: Image.asset('assets/icons/unanswered.png')),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Unanswered\nForm',
                            style: appstyle(30, Colors.white, FontWeight.bold),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
