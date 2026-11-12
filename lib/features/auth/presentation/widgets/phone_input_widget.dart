import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';

class PhoneInputWidget extends StatelessWidget {
  const PhoneInputWidget(
      {super.key,
      required this.controller,
      required this.onChanged,
      this.error,
      this.focusNode});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? error;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9 +\-]'))
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '9XXXXXXXXX',
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 18, right: 12),
              child: Center(
                  widthFactor: 1,
                  child: Text('+95',
                      style: TextStyle(fontWeight: FontWeight.w700))),
            ),
            errorText: error,
          ),
        ),
        const SizedBox(height: 10),
        const Text('Enter your Myanmar mobile number',
            style: TextStyle(color: Palette.muted, fontSize: 13)),
      ],
    );
  }
}
