import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/custom_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Size screenSize;
  final Stream<QuerySnapshot> _doctorStream =
      FirebaseFirestore.instance.collection('doctor').snapshots();
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: customColor[60],
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: _doctorStream,
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
                      return NutritionistListTile(
                        screenSize: screenSize,
                        image: data['image'],
                        name: data['name'],
                        specialties: data['specialties'],
                        nutritionistId: data['uid'],
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
