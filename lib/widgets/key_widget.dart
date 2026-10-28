import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

enum Finger {
  leftPinky,
  leftRing,
  leftMiddle,
  leftIndex,
  rightIndex,
  rightMiddle,
  rightRing,
  rightPinky,
  thumb,
}

Color getFingerColor(Finger finger) {
  switch (finger) {
    case Finger.leftPinky:
      return AppColors.leftPinky;
    case Finger.leftRing:
      return AppColors.leftRing;
    case Finger.leftMiddle:
      return AppColors.leftMiddle;
    case Finger.leftIndex:
      return AppColors.leftIndex;
    case Finger.rightIndex:
      return AppColors.rightIndex;
    case Finger.rightMiddle:
      return AppColors.rightMiddle;
    case Finger.rightRing:
      return AppColors.rightRing;
    case Finger.rightPinky:
      return AppColors.rightPinky;
    case Finger.thumb:
      return AppColors.thumb;
  }
}

class KeyWidget extends StatelessWidget {
  final String label;
  final double width;
  final bool isNext;
  final bool isPressed;
  final bool isWrong;
  final Finger finger;

  const KeyWidget({
    super.key,
    required this.label,
    this.width = 44,
    this.isNext = false,
    this.isPressed = false,
    this.isWrong = false,
    required this.finger,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fingerColor = getFingerColor(finger);

    Color bgColor;
    if (isWrong) {
      bgColor = AppColors.error;
    } else if (isNext) {
      bgColor = fingerColor;
    } else {
      bgColor = theme.brightness == Brightness.dark ? Colors.white12 : Colors.white;
    }

    Color textColor = isNext || isWrong ? Colors.white : theme.colorScheme.onSurface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: width,
      height: 44,
      margin: const EdgeInsets.all(2),
      transform: isPressed ? Matrix4.translationValues(0, 2, 0) : Matrix4.identity(),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNext ? Colors.white : (theme.brightness == Brightness.dark ? Colors.white24 : Colors.black12),
          width: isNext ? 2 : 1,
        ),
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: fingerColor.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
