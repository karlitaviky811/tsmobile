import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
    Widget? suffixIcon, // Añadido para incluir el suffixIcon
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xffffdc00), width: 2),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xffffdc00), width: 2),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Color(0xffffdc00)) : null,
      suffixIcon: suffixIcon, // Añadido para incluir el suffixIcon
    );
  }
}
