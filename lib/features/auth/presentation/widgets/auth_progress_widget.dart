import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AuthProgressWidget extends StatelessWidget {
  const AuthProgressWidget({super.key, required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: (step + 1) / 4),
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 350),
            builder: (context, value, _) => CircularProgressIndicator(
              value: value,
              color: Palette.pink,
              backgroundColor: Palette.pale,
              strokeWidth: 5,
              strokeCap: StrokeCap.round,
            ),
          ),
          step == 3
              ? const Icon(Icons.check_rounded, color: Palette.pink, size: 23)
              : Text('${step + 1}/4',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
