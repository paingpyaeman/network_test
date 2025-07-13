import 'package:flutter/material.dart';

Future<String?> openInputDialog(
  BuildContext context,
  String title,
  String label,
  String type,
) {
  final TextEditingController controller = TextEditingController();

  String hintText = switch (type) {
    'barcode' => "1234567890123456789",
    'otp' => "123456",
    _ => "09XXXXXXXXX",
  };

  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: TextField(
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: hintText,
        ),
        keyboardType: type == "phone"
            ? TextInputType.phone
            : TextInputType.number,
        onSubmitted: (_) {
          Navigator.of(dialogContext).pop(controller.text.trim());
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop(controller.text.trim());
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}
