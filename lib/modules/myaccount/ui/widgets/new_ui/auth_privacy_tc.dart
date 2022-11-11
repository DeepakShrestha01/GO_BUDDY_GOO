import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthPrivacyTC extends StatelessWidget {
  const AuthPrivacyTC({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {},
          child: Text(
            'Privacy Policy',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9B97A0),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'T & C',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9B97A0),
            ),
          ),
        ),
      ],
    );
  }
}
