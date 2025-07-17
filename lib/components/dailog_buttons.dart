import 'package:flutter/material.dart';
import 'package:reminder_app/components/costum_outline.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomOutline(
      strokeWidth: 4,
      radius: 40,
      padding: const EdgeInsets.all(4),
      width: 80,
      height: 35,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromRGBO(54, 226, 195, .5),
          Color.fromRGBO(239, 27, 167, .5)
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(54, 226, 195, .5),
              Color.fromRGBO(239, 27, 167, .5)
            ],
          ),
        ),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
