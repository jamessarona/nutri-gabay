import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:nutri_gabay/rootpage.dart';
import 'package:nutri_gabay/services/baseauth.dart';
import 'package:provider/provider.dart';
import 'controllers/mainscreen_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => MainScreenNotifier(),
      )
    ],
    child: Phoenix(child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriGabay',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Root(
        auth: FireBaseAuth(),
      ),
    );
  }
}
