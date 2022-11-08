import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/widgets/appbar.dart';
import '../../../configs/theme.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContactUsBody();
  }
}

class ContactUsBody extends StatefulWidget {
  const ContactUsBody({super.key});

  @override
  State<ContactUsBody> createState() => _ContactUsBodyState();
}

class _ContactUsBodyState extends State<ContactUsBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getMainAppBar(context, 'Contact Us', null),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Get in Touch",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const BottomContactWidget(
                      icon: CupertinoIcons.home,
                      onTap: null,
                      title: "Sanepa Height, Lalitpur",
                    ),
                    const SizedBox(height: 5.0),
                    BottomContactWidget(
                      icon: CupertinoIcons.mail,
                      onTap: () async {
                        if (await launchUrl(
                          Uri(scheme: 'mailto', path: 'support@gobuddygoo.com'),
                        )) {}
                        //  if (await canLaunch(
                        //     'mailto:support@gobuddygoo.com')) {
                        //   await launch('mailto:support@gobuddygoo.com');
                        // }
                      },
                      title: "support@gobuddygoo.com",
                    ),
                    const SizedBox(height: 5.0),
                    BottomContactWidget(
                      icon: CupertinoIcons.phone,
                      onTap: () {
                        launchUrl(Uri(scheme: 'tel', path: '+97715912655'));
                      },
                      title: "+977 15912655",
                    ),
                    const SizedBox(height: 5.0),
                    BottomContactWidget(
                      icon: CupertinoIcons.phone,
                      onTap: () {
                        launchUrl(Uri(scheme: 'tel', path: '+9779801188597'));
                      },
                      title: "+977 9801188597",
                    ),
                    const SizedBox(height: 5.0),
                    BottomContactWidget(
                      icon: CupertinoIcons.phone,
                      onTap: () {
                        launchUrl(Uri(scheme: 'tel', path: '+9779801188598'));
                      },
                      title: "+977 9801188598",
                    ),
                    const SizedBox(height: 5.0),
                    BottomContactWidget(
                      icon: CupertinoIcons.link,
                      onTap: () async {
                        if (await launchUrl(
                          Uri(
                              scheme: 'mailto',
                              path: 'http://www.gobuddygoo.com/'),
                        )) {}
                        // if (await canLaunch("http://www.gobuddygoo.com/")) {
                        //   await launch("http://www.gobuddygoo.com/");
                        // }
                      },
                      title: "www.gobuddygoo.com",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }
}

class BottomContactWidget extends StatelessWidget {
  const BottomContactWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: MyTheme.primaryColor,
            size: 20.0,
          ),
          const SizedBox(width: 20.0),
          Text(
            title,
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}

class CircularWidget extends StatelessWidget {
  final String? image;
  final Color? backGroundColor;

  const CircularWidget({Key? key, this.backGroundColor, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backGroundColor,
      ),
      child: Center(
        child: Image.asset(
          image.toString(),
          color: MyTheme.primaryColor,
        ),
      ),
    );
  }
}
