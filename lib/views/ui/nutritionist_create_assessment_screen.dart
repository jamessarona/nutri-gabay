import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class NutritionistCreateAssessmentScreen extends StatefulWidget {
  final String appointmentId;
  const NutritionistCreateAssessmentScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  State<NutritionistCreateAssessmentScreen> createState() =>
      _NutritionistCreateAssessmentScreenState();
}

class _NutritionistCreateAssessmentScreenState
    extends State<NutritionistCreateAssessmentScreen> {
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
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  'Client History (CH)',
                  style: appstyle(14, Colors.black, FontWeight.bold)
                      .copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                    'Patient/client or family nutrition‐oriented medical/health history:',
                    style: appstyle(14, Colors.black, FontWeight.normal)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
