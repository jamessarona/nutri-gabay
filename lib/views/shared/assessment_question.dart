import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/text_field_widget.dart';

class QuestionContainer extends StatelessWidget {
  final List<Widget> question;
  final List<Widget> choices;
  final TextEditingController controller;
  final String range;
  final int minimum;
  final int maximum;
  final bool isRequired;
  const QuestionContainer(
      {super.key,
      required this.question,
      required this.choices,
      required this.controller,
      required this.range,
      required this.minimum,
      required this.maximum,
      required this.isRequired});

  bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: question),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: choices),
          Expanded(child: Container()),
          AssessmentTextField(
            controller: controller,
            label: '',
            isObscure: false,
            keyboardType: TextInputType.number,
            range: range,
            validation: (value) {
              if (value == '' && isRequired) {
                return "Please answer the question";
              }
              if (value == '' && !isRequired) {
                controller.text = "0";
              }

              return null;
            },
            onChanged: (value) {
              if (controller.text != '') {
                if (!isNumeric(controller.text)) {
                  controller.text = minimum.toString();
                } else if (double.parse(controller.text) > maximum) {
                  controller.text = maximum.toString();
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
