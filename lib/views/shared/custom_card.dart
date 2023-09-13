import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

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
