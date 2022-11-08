import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_buddy_goo_mobile/modules/tour/ui/widgets/tourSearchCitiesDelegate.dart';

import '../../../../common/model/city.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../common/widgets/search_delegate.dart';
import '../../../../common/widgets/shimmer.dart';
import '../../model/tour_theme.dart';
import '../../servies/cubit/tour_theme/tour_theme_cubit.dart';

class TourThemeW extends StatefulWidget {
  final List<City>? cities;

  const TourThemeW({Key? key, this.cities}) : super(key: key);
  @override
  _TourThemeWState createState() => _TourThemeWState();
}

class _TourThemeWState extends State<TourThemeW> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TourThemeCubit>(context).getPackageThemes();
  }

  @override
  Widget build(BuildContext context) {
    final TourThemeCubit tourThemeCubit =
        BlocProvider.of<TourThemeCubit>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Search tour package by selecting a theme,",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 80,
          child: BlocBuilder<TourThemeCubit, TourThemeState>(
            builder: (context, state) {
              if (state is TourThemeLoaded) {
                return ListView.separated(
                  itemCount: tourThemeCubit.packageThemes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SingleTourThemeWidget(
                      packageTheme: tourThemeCubit.packageThemes[index],
                      cities: widget.cities,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10);
                  },
                );
              }

              return ListView.separated(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return const SingleTourThemeShimmerWidget();
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class SingleTourThemeWidget extends StatelessWidget {
  final PackageTheme? packageTheme;
  final List<City>? cities;

  const SingleTourThemeWidget({Key? key, this.packageTheme, this.cities})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showSearchCustom(
          context: context,
          delegate: TourSearchCitiesDelegate(cities, packageTheme),
        );
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: showNetworkImageSmall(packageTheme!.image.toString()),
          ),
          const SizedBox(height: 3),
          Text(
            packageTheme!.title.toString(),
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class SingleTourThemeShimmerWidget extends StatelessWidget {
  const SingleTourThemeShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Center(
              child: Text("image"),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            "Tour Name",
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
