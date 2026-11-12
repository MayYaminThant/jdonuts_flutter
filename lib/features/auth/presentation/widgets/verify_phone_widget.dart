import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'otp_input_widget.dart';

class VerifyPhoneWidget extends StatelessWidget {
  const VerifyPhoneWidget({
    super.key,
    required this.phoneNumber,
    required this.controller,
    required this.secondsRemaining,
    required this.wrongAttempts,
    required this.onChanged,
    required this.onResend,
  });
  final String phoneNumber;
  final TextEditingController controller;
  final int secondsRemaining;
  final int wrongAttempts;
  final ValueChanged<String> onChanged;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final canResend = secondsRemaining == 0 || wrongAttempts >= 3;
    final countdown =
        '${secondsRemaining ~/ 60}:${(secondsRemaining % 60).toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('We sent a 6-digit code to $phoneNumber',
            style: const TextStyle(color: Palette.muted)),
        const SizedBox(height: 28),
        OtpInputWidget(
            controller: controller,
            enabled: wrongAttempts < 3,
            onChanged: onChanged),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: canResend ? onResend : null,
            child: Text(canResend ? 'Resend code' : 'Resend in $countdown'),
          ),
        ),
      ],
    );
  }
}
