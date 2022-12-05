import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../configs/backendUrl.dart';

class AuthPrivacyTC extends StatefulWidget {
  const AuthPrivacyTC({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthPrivacyTC> createState() => _AuthPrivacyTCState();
}

class _AuthPrivacyTCState extends State<AuthPrivacyTC> {
  String termsAndServiceUrl = "${backendServerUrl}termsandconditionscustomer";
  String privacyPolicyUrl = "${backendServerUrl}privacy_policy";
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () async {
            if (await launchUrl(Uri.parse(termsAndServiceUrl))) {
              // await launchUrl(Uri.parse(termsAndServiceUrl));
              throw 'Could not lunch $privacyPolicyUrl';
            }
          },
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
          onTap: () async {
            if (await launchUrl(Uri.parse(privacyPolicyUrl))) {
              // await launchUrl(Uri.parse(privacyPolicyUrl));
              throw 'Could not lunch $privacyPolicyUrl';
            }
          },
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
