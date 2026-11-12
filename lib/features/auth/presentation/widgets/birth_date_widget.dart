import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BirthDateWidget extends StatelessWidget {
  const BirthDateWidget(
      {super.key,
      required this.month,
      required this.day,
      required this.year,
      required this.onChanged});
  final TextEditingController month;
  final TextEditingController day;
  final TextEditingController year;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _field('Month (1–12)', month, 2),
      const SizedBox(height: 12),
      _field('Day', day, 2),
      const SizedBox(height: 12),
      _field('Year', year, 4),
    ]);
  }

  Widget _field(String hint, TextEditingController controller, int length) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction:
          hint == 'Year' ? TextInputAction.done : TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(length)
      ],
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(hintText: hint),
    );
  }
}
