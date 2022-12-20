import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo/modules/bus_new/ui/widgets/new_search_widget.dart';

class NewSearchBody extends StatefulWidget {
  const NewSearchBody({super.key});

  @override
  State<NewSearchBody> createState() => _NewSearchBodyState();
}

class _NewSearchBodyState extends State<NewSearchBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Search Bus",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white)),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            NewBusSearchBox(),
          ],
        ),
      ),
    );
  }
}
