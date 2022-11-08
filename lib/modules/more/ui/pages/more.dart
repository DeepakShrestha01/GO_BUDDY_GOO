import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/widgets/appbar.dart';
import '../../../../configs/theme.dart';
import '../../../contact_us/ui/contact_us_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MoreBody();
  }
}

class MoreBody extends StatefulWidget {
  const MoreBody({super.key});

  @override
  State<MoreBody> createState() => _MoreBodyState();
}

class _MoreBodyState extends State<MoreBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getMainAppBar(context, 'About', null),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: AutoSizeText(
                "Go Buddy Goo",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 35.0,
                  color: MyTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Forever Friend To Go!!",
                  style: GoogleFonts.dancingScript(
                    color: const Color(0xFFe3c05a),
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                  "Go Buddy Goo is a Nepal-based travel booking engine founded in 2021, with an aim to be a comfortable step for travellers to make pre-bookings and reservations online. Go Buddy Goo provides the reservation system for a wide variety of services, namely hotels, buses, flights, rental, tours & travels, and many more to go in upcoming days."),
            ),
            const SizedBox(height: 15.0),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                    "Go Buddy Goo facilitates travellers to make bookings online through their comfort zone without going through any hassle, just a click away with diversified options in each service. Along with the services, Go Buddy Goo aims to provide an exceptional customer service experience with real-time support and real-time booking confirmations.")),
            const SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CircularWidget(
                    backGroundColor: Color(0xFFF5F6F8),
                    image: "assets/images/hotel.png",
                  ),
                  CircularWidget(
                    backGroundColor: Color(0xFFF5F6F8),
                    image: "assets/images/travel.png",
                  ),
                  CircularWidget(
                    backGroundColor: Color(0xFFF5F6F8),
                    image: "assets/images/flight.png",
                  ),
                  CircularWidget(
                    backGroundColor: Color(0xFFF5F6F8),
                    image: "assets/images/rental.png",
                  ),
                  CircularWidget(
                    backGroundColor: Color(0xFFF5F6F8),
                    image: "assets/images/bus.png",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AutoSizeText(
                "LET GO BUDDY GOO BE YOUR TRAVEL BUDDY!!",
                maxLines: 1,
                style: GoogleFonts.dancingScript(fontSize: 25.0),
              ),
            ),
            const SizedBox(height: 25.0),
            Image.asset("assets/images/why_gbg.jpg"),
            const SizedBox(height: 35.0),
          ],
        ),
      ),
    );
  }
}
