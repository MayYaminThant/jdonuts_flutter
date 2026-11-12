import 'package:flutter/material.dart';

class NameInputWidget extends StatelessWidget {
  const NameInputWidget(
      {super.key,
      required this.firstController,
      required this.lastController,
      required this.onChanged});
  final TextEditingController firstController;
  final TextEditingController lastController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        controller: firstController,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        maxLength: 50,
        onChanged: (_) => onChanged(),
        decoration:
            const InputDecoration(hintText: 'First name', counterText: ''),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: lastController,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        maxLength: 50,
        onChanged: (_) => onChanged(),
        decoration: const InputDecoration(
            hintText: 'Last name (optional)', counterText: ''),
      ),
    ]);
  }
}
