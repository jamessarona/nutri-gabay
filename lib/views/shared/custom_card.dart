import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:nutri_gabay/views/shared/button_widget.dart';
import 'package:nutri_gabay/views/ui/nutritionist_booking_screen.dart';
import 'package:nutri_gabay/views/ui/nutritionist_monitoring_screen.dart';
import 'package:nutri_gabay/views/ui/nutritionist_profile_screen.dart';

class ProfileCard extends StatelessWidget {
  final String leading;
  final Size screenSize;
  final double fontSize;
  final bool isOverFlow;
  final bool isEditing;
  final bool isGender;
  final bool isDigit;
  final String unit;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final void Function()? onTap;
  final FormFieldValidator<String>? validation;
  const ProfileCard({
    super.key,
    required this.leading,
    required this.screenSize,
    required this.fontSize,
    required this.isOverFlow,
    required this.isEditing,
    required this.isGender,
    required this.isDigit,
    required this.unit,
    required this.keyboardType,
    required this.controller,
    this.onTap,
    this.validation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(
            horizontal: screenSize.height * 0.02, vertical: 5),
        child: ListTile(
          onTap: onTap,
          leading: !isOverFlow
              ? Text(
                  leading,
                  style: appstyle(fontSize, Colors.black, FontWeight.normal),
                )
              : null,
          title: !isOverFlow
              ? !isEditing
                  ? Text(
                      controller.text,
                      style: appstyle(fontSize, customColor, FontWeight.w700),
                    )
                  : SizedBox(
                      height: 30,
                      child: !isGender
                          ? TextFormField(
                              controller: controller,
                              keyboardType: keyboardType,
                              style: appstyle(
                                  fontSize, customColor, FontWeight.w700),
                              validator: validation,
                              inputFormatters: keyboardType ==
                                          TextInputType.number ||
                                      keyboardType == TextInputType.phone
                                  ? <TextInputFormatter>[
                                      isDigit
                                          ? FilteringTextInputFormatter
                                              .digitsOnly
                                          : FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                    ]
                                  : null,
                              cursorColor: customColor,
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: customColor),
                                ),
                              ),
                            )
                          : TextFormField(
                              controller: controller,
                              keyboardType: keyboardType,
                              style: appstyle(
                                  fontSize, customColor, FontWeight.w700),
                              validator: validation,
                              decoration: InputDecoration(
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    controller.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return ["Male", "Female"]
                                        .map<PopupMenuItem<String>>(
                                            (String value) {
                                      return PopupMenuItem(
                                          value: value, child: Text(value));
                                    }).toList();
                                  },
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: customColor),
                                ),
                                fillColor: Colors.transparent,
                              ),
                            ),
                    )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leading,
                      style:
                          appstyle(fontSize, Colors.black, FontWeight.normal),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${controller.text} $unit",
                      style: appstyle(fontSize, customColor, FontWeight.w700),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class NutritionistListTile extends StatelessWidget {
  final Size screenSize;
  final String image;
  final String name;
  final String specialties;
  final String nutritionistId;
  const NutritionistListTile(
      {super.key,
      required this.screenSize,
      required this.image,
      required this.name,
      required this.specialties,
      required this.nutritionistId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NutritionistProfileScreen(
              nutritionistId: nutritionistId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 5,
          left: screenSize.width * 0.02,
          right: screenSize.width * 0.02,
        ),
        height: 150,
        width: double.infinity,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 120,
                  padding: const EdgeInsets.all(3), // Border width
                  decoration: const BoxDecoration(
                      color: customColor, shape: BoxShape.circle),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(48),
                      child: Image.network(image, fit: BoxFit.fill),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style:
                                  appstyle(15, Colors.black, FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Text(
                          specialties,
                          style:
                              appstyle(11, Colors.black87, FontWeight.normal),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 25,
                            width: 95,
                            child: UserCredentialSecondaryButton(
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NutritionistBookingScreen(
                                            nutritionistId: nutritionistId),
                                  ),
                                );
                              },
                              label: "Book",
                              labelSize: 12,
                              color: customColor,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '5.0',
                                style:
                                    appstyle(14, Colors.black, FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
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

class MyNutritionistListTile extends StatelessWidget {
  final Size screenSize;
  final String appointmentId;
  final String image;
  final String name;
  final String nutritionistId;
  final String date;
  final int hourStart;
  final int hourEnd;
  final bool isDisplayOnly;
  const MyNutritionistListTile({
    super.key,
    required this.appointmentId,
    required this.screenSize,
    required this.image,
    required this.name,
    required this.nutritionistId,
    required this.date,
    required this.hourStart,
    required this.hourEnd,
    required this.isDisplayOnly,
  });
  String formatTimeRange() {
    String result = '';

    if (hourStart > 12) {
      result = '${hourStart - 12} - ${hourEnd - 12} PM';
    } else if (hourEnd < 13) {
      result = '$hourStart - $hourEnd AM';
    } else {
      result = '$hourStart AM - $hourEnd PM';
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisplayOnly
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NutritionistMonitoringScreen(
                    appointmentId: appointmentId,
                    nutritionistId: nutritionistId,
                  ),
                ),
              );
            },
      child: Container(
        margin: EdgeInsets.only(
          top: 5,
          left: screenSize.width * 0.02,
          right: screenSize.width * 0.02,
        ),
        height: 150,
        width: double.infinity,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Nutritionist',
                        style: appstyle(15, Colors.grey, FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        name,
                        style: appstyle(15, Colors.black, FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        date,
                        style: appstyle(13, Colors.black, FontWeight.normal),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        formatTimeRange(),
                        style: appstyle(13, Colors.black, FontWeight.normal),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  height: double.infinity,
                  width: 120,
                  padding: const EdgeInsets.all(3), // Border width
                  decoration: const BoxDecoration(
                      color: customColor, shape: BoxShape.circle),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(48),
                      child: Image.network(image, fit: BoxFit.fill),
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
