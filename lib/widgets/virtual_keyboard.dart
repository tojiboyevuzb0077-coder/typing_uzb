import 'package:flutter/material.dart';
import 'key_widget.dart';

class VirtualKeyboard extends StatelessWidget {
  final String? nextChar;
  final String? pressedChar;
  final bool isWrong;

  const VirtualKeyboard({
    super.key,
    required this.nextChar,
    required this.pressedChar,
    required this.isWrong,
  });

  static const List<List<Map<String, dynamic>>> rows = [
    [
      {'label': '`', 'finger': Finger.leftPinky},
      {'label': '1', 'finger': Finger.leftPinky},
      {'label': '2', 'finger': Finger.leftRing},
      {'label': '3', 'finger': Finger.leftMiddle},
      {'label': '4', 'finger': Finger.leftIndex},
      {'label': '5', 'finger': Finger.leftIndex},
      {'label': '6', 'finger': Finger.rightIndex},
      {'label': '7', 'finger': Finger.rightIndex},
      {'label': '8', 'finger': Finger.rightMiddle},
      {'label': '9', 'finger': Finger.rightRing},
      {'label': '0', 'finger': Finger.rightPinky},
      {'label': '-', 'finger': Finger.rightPinky},
      {'label': '=', 'finger': Finger.rightPinky},
      {'label': 'Backspace', 'width': 80.0, 'finger': Finger.rightPinky},
    ],
    [
      {'label': 'Tab', 'width': 65.0, 'finger': Finger.leftPinky},
      {'label': 'q', 'finger': Finger.leftPinky},
      {'label': 'w', 'finger': Finger.leftRing},
      {'label': 'e', 'finger': Finger.leftMiddle},
      {'label': 'r', 'finger': Finger.leftIndex},
      {'label': 't', 'finger': Finger.leftIndex},
      {'label': 'y', 'finger': Finger.rightIndex},
      {'label': 'u', 'finger': Finger.rightIndex},
      {'label': 'i', 'finger': Finger.rightMiddle},
      {'label': 'o', 'finger': Finger.rightRing},
      {'label': 'p', 'finger': Finger.rightPinky},
      {'label': '[', 'finger': Finger.rightPinky},
      {'label': ']', 'finger': Finger.rightPinky},
      {'label': '\\', 'width': 50.0, 'finger': Finger.rightPinky},
    ],
    [
      {'label': 'Caps', 'width': 75.0, 'finger': Finger.leftPinky},
      {'label': 'a', 'finger': Finger.leftPinky},
      {'label': 's', 'finger': Finger.leftRing},
      {'label': 'd', 'finger': Finger.leftMiddle},
      {'label': 'f', 'finger': Finger.leftIndex},
      {'label': 'g', 'finger': Finger.leftIndex},
      {'label': 'h', 'finger': Finger.rightIndex},
      {'label': 'j', 'finger': Finger.rightIndex},
      {'label': 'k', 'finger': Finger.rightMiddle},
      {'label': 'l', 'finger': Finger.rightRing},
      {'label': ';', 'finger': Finger.rightPinky},
      {'label': "'", 'finger': Finger.rightPinky},
      {'label': 'Enter', 'width': 85.0, 'finger': Finger.rightPinky},
    ],
    [
      {'label': 'Shift', 'width': 95.0, 'finger': Finger.leftPinky},
      {'label': 'z', 'finger': Finger.leftPinky},
      {'label': 'x', 'finger': Finger.leftRing},
      {'label': 'c', 'finger': Finger.leftMiddle},
      {'label': 'v', 'finger': Finger.leftIndex},
      {'label': 'b', 'finger': Finger.leftIndex},
      {'label': 'n', 'finger': Finger.rightIndex},
      {'label': 'm', 'finger': Finger.rightIndex},
      {'label': ',', 'finger': Finger.rightMiddle},
      {'label': '.', 'finger': Finger.rightRing},
      {'label': '/', 'finger': Finger.rightPinky},
      {'label': 'Shift', 'width': 105.0, 'finger': Finger.rightPinky},
    ],
    [
      {'label': 'Space', 'width': 280.0, 'finger': Finger.thumb},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final normalizedNext = nextChar?.toLowerCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((keyData) {
                final label = keyData['label'] as String;
                final width = (keyData['width'] ?? 44.0) as double;
                final finger = keyData['finger'] as Finger;

                final isNext = normalizedNext != null &&
                    (normalizedNext == label.toLowerCase() || (normalizedNext == ' ' && label == 'Space'));
                final isPressed = pressedChar != null &&
                    (pressedChar!.toLowerCase() == label.toLowerCase() || (pressedChar == ' ' && label == 'Space'));

                return KeyWidget(
                  label: label,
                  width: width,
                  finger: finger,
                  isNext: isNext,
                  isPressed: isPressed,
                  isWrong: isNext && isWrong,
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
