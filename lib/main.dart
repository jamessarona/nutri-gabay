import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/ui/loginscreen.dart';
import 'package:provider/provider.dart';
import 'controllers/mainscreen_provider.dart';
import 'views/ui/mainscreen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => MainScreenNotifier(),
      )
    ],
    child: const MyApp(),
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
      home: LoginScreen(),
    );
  }
}
