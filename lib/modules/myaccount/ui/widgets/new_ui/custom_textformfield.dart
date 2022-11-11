import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String text;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool? readOnly;

  const CustomTextFormField({
    Key? key,
    required this.text,
    this.controller,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly!,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        errorStyle: GoogleFonts.poppins(fontSize: 12),
        filled: true,
        fillColor: const Color(0xFFFEFEFE),
        hintText: text,
        contentPadding: EdgeInsets.zero,
        hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9B97A0)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none),
      ),
    );
  }
}
