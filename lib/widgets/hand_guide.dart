import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'key_widget.dart';

class HandGuide extends StatelessWidget {
  final String? nextChar;

  const HandGuide({super.key, required this.nextChar});

  Finger? _getFingerForChar(String? char) {
    if (char == null) return null;
    final c = char.toLowerCase();
    if ('1qa z`'.contains(c)) return Finger.leftPinky;
    if ('2wsx'.contains(c)) return Finger.leftRing;
    if ('3edc'.contains(c)) return Finger.leftMiddle;
    if ('4rfv5tgb'.contains(c)) return Finger.leftIndex;
    if ('6yhn7ujm'.contains(c)) return Finger.rightIndex;
    if ('8ik,'.contains(c)) return Finger.rightMiddle;
    if ('9ol.'.contains(c)) return Finger.rightRing;
    if ('0p;/-=[]\\\'/'.contains(c)) return Finger.rightPinky;
    if (c == ' ') return Finger.thumb;
    return Finger.leftIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeFinger = _getFingerForChar(nextChar);
    final activeColor = activeFinger != null ? getFingerColor(activeFinger) : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.handshake_outlined, size: 20),
          const SizedBox(width: 8),
          Text(
            activeFinger != null
                ? 'Active Finger: ${activeFinger.name.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), ' ').toUpperCase()}'
                : 'Get ready to type',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: activeColor,
            ),
          ),
        ],
      ),
    );
  }
}
