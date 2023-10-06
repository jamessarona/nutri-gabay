import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:nutri_gabay/controllers/mainscreen_provider.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:provider/provider.dart';

class SuccessBookingScreen extends StatefulWidget {
  const SuccessBookingScreen({super.key});

  @override
  State<SuccessBookingScreen> createState() => _SuccessBookingScreenState();
}

class _SuccessBookingScreenState extends State<SuccessBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Text(
                  'Waiting for Appoval',
                  style: appstyle(15, Colors.black, FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 150,
                  child: UserCredentialPrimaryButton(
                      onPress: () {
                        //restart app and return to homepage
                        mainScreenNotifier.pageIndex = 0;
                        Phoenix.rebirth(context);
                      },
                      label: 'Back to Home',
                      labelSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
