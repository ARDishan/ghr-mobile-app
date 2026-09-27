import 'package:flutter/material.dart';

/// Carried over from the previous project structure.
/// TODO: port full implementation from previous app_text_field.dart.
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(controller: controller);
  }
}
