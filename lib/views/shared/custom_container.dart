import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';

class ContainerWithLabel extends StatelessWidget {
  final String leading;
  final String title;
  final double height;
  final double width;
  const ContainerWithLabel(
      {super.key,
      required this.leading,
      required this.title,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Text(
            leading,
            style: appstyle(12, Colors.black, FontWeight.normal),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              style: appstyle(12, Colors.black, FontWeight.bold),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingContainerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? onTap;
  const BookingContainerButton(
      {super.key, required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              label,
              style: appstyle(13, Colors.black, FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}

class DiagnosisDomainContainer extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validation;
  final bool isEdit;
  const DiagnosisDomainContainer({
    super.key,
    required this.controller,
    this.validation,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.only(top: 15),
      color: Colors.grey.shade300,
      child: TextFormField(
        controller: controller,
        enabled: isEdit,
        keyboardType: TextInputType.multiline,
        textAlign: TextAlign.center,
        validator: validation,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: false,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          hintText: isEdit ? 'Input a Domain here' : '',
          hintStyle: appstyle(
            15,
            Colors.black,
            FontWeight.normal,
          ),
        ),
        style: appstyle(
          15,
          Colors.black,
          FontWeight.normal,
        ),
        maxLines: 5,
      ),
    );
  }
}
