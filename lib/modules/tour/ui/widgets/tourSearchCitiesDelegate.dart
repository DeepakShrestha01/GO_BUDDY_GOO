import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/model/city.dart';
import '../../../../common/widgets/search_delegate.dart';
import '../../../../configs/theme.dart';

class TourSearchCitiesDelegate extends SearchDelegateCustom {
  final dynamic prevData;
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  String get searchFieldLabel => "Select your starting city";

  @override
  TextStyle get searchFieldStyle =>
      MyTheme.mainTextTheme.headline3!.copyWith(color: Colors.white);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(selectedResult),
    );
  }

  List<City>? cities;
  TourSearchCitiesDelegate(this.cities, this.prevData);

  @override
  Widget buildSuggestions(BuildContext context) {
    List<City> suggestionList = [];
    query.isEmpty
        ? suggestionList = cities! //In the true case
        : suggestionList.addAll(
            cities!.where(
              (element) =>
                  element.name!.toLowerCase().contains(query.toLowerCase()),
            ),
          );

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].name.toString()),
          leading: const Icon(
            CupertinoIcons.location_solid,
            color: MyTheme.primaryColor,
            size: 20,
          ),
          onTap: () {
            Get.toNamed(
              "/tourList",
              arguments: [prevData, suggestionList[index].id],
            );
          },
        );
      },
    );
  }
}
