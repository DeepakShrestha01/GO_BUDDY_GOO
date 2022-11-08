import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/ui/widgets/no_result_widget.dart';
import '../../model/tour.dart';
import '../../model/tour_theme.dart';
import '../../model/value_notifier.dart';
import '../../servies/cubit/tour_search_result/tour_search_result_cubit.dart';
import '../widgets/singleTour.dart';
import '../widgets/tourFilter.dart';

class TourSearchListPage extends StatelessWidget {
  const TourSearchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TourSearchResultCubit(),
      child: const TourSearchResultBody(),
    );
  }
}

class TourSearchResultBody extends StatefulWidget {
  const TourSearchResultBody({Key? key}) : super(key: key);
  @override
  _TourSearchResultBodyState createState() => _TourSearchResultBodyState();
}

class _TourSearchResultBodyState extends State<TourSearchResultBody> {
  @override
  void dispose() {
    tourSearchResultNumber.value = 0;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments[0].runtimeType == PackageTheme) {
      BlocProvider.of<TourSearchResultCubit>(context).getSearchResult(
          isInitial: true,
          packageThemeId: Get.arguments[0].id,
          startingCity: Get.arguments[1]);
    } else {
      BlocProvider.of<TourSearchResultCubit>(context).getSearchResult(
          isInitial: true,
          query: Get.arguments[0],
          startingCity: Get.arguments[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TourSearchResultCubit tourSearchResultCubit =
        BlocProvider.of<TourSearchResultCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Tour List",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          TopPartWidget(searchQuery: Get.arguments[0]),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<TourSearchResultCubit, TourSearchResultState>(
              builder: (context, state) {
                if (state is TourSearchLoaded ||
                    state is TourSearchMoreLoading) {
                  return TourListWidget(cubit: tourSearchResultCubit);
                } else if (state is TourSearchError) {
                  return const Center(
                    child: Text("Error loading data"),
                  );
                }

                return const LoadingWidget();
              },
            ),
          )
        ],
      ),
    );
  }
}

class TourListWidget extends StatefulWidget {
  final TourSearchResultCubit? cubit;

  const TourListWidget({Key? key, this.cubit}) : super(key: key);

  @override
  _TourListWidgetState createState() => _TourListWidgetState();
}

class _TourListWidgetState extends State<TourListWidget> {
  List<TourPackage>? tours;
  TourSearchResultCubit? tourSearchResultCubit;

  @override
  void initState() {
    super.initState();
    tourSearchResultCubit = widget.cubit;
    tours = tourSearchResultCubit?.tourList;
  }

  showFilterModalSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black12.withOpacity(0.75),
      builder: (BuildContext context) {
        return TourFilter(tourSearchResultCubit);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        tours!.isEmpty
            ? const NoResultWidget()
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      scrollInfo is ScrollEndNotification) {
                    if (!tourSearchResultCubit!.allDataLoaded) {
                      tourSearchResultCubit?.getSearchResult(isInitial: false);
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tours!.length + 1,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (BuildContext context, int i) {
                    if (i == tours?.length) {
                      if (tourSearchResultCubit!.allDataLoaded) {
                        return Column(
                          children: [
                            Container(),
                            const SizedBox(height: 50),
                          ],
                        );
                      }

                      return Column(
                        children: const [
                          LoadingWidget(),
                          SizedBox(height: 50),
                        ],
                      );
                    }
                    return SingleTourWidget(tours?[i]);
                  },
                ),
              ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              showFilterModalSheet();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: MyTheme.primaryColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: const [
                  Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Filter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TopPartWidget extends StatelessWidget {
  final searchQuery;
  const TopPartWidget({Key? key, this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: MyTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            searchQuery.runtimeType == PackageTheme
                ? "Keyword: " + searchQuery.title
                : "Keyword: " + searchQuery,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          ValueListenableBuilder(
            builder: (BuildContext context, value, Widget? child) {
              return Text(
                "${tourSearchResultNumber.value} Tours",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              );
            },
            valueListenable: tourSearchResultNumber,
          ),
        ],
      ),
    );
  }
}
