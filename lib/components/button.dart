import 'package:flutter/material.dart';
import 'package:reminder_app/components/costum_outline.dart';

class GradientButton extends StatelessWidget {
  final void Function()? ontap;
  final Widget child;

  const GradientButton({
    super.key,
    required this.ontap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: CustomOutline(
        strokeWidth: 4,
        radius: 40,
        padding: const EdgeInsets.all(4),
        width: 160,
        height: 50,
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
          child: Center(child: child),
        ),
      ),
    );
  }
}
