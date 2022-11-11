import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;
final String? Function(String?)? validator;
  final TextEditingController? controller;
   const CustomTextFormField({
    Key? key,
    required this.text,
    this.controller, this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.060,
      width: MediaQuery.of(context).size.width * 355,
      decoration: BoxDecoration(
          color: const Color(0xFFFEFEFE),
          borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
        validator:validator ,
        keyboardType: TextInputType.number,
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          fillColor: const Color(0xFFFEFEFE),
          hintText: text,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 17),
          hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9B97A0)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
