import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NutritionistInterventionScreen extends StatefulWidget {
  final String appointmentId;
  const NutritionistInterventionScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  State<NutritionistInterventionScreen> createState() =>
      _NutritionistInterventionScreenState();
}

class _NutritionistInterventionScreenState
    extends State<NutritionistInterventionScreen> {
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('appointment')
                .doc(widget.appointmentId)
                .collection('files')
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

              return ListView();
            },
          ),
        ),
      ),
    );
  }
}
