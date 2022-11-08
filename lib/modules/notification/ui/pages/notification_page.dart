import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../services/cubit/notification/notification_cubit.dart';
import '../widgets/notification_widget.dart';


class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NotificationCubit()..getNotifications(),
      child: const NotificationBody(),
    );
  }
}

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  _NotificationBodyState createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  @override
  Widget build(BuildContext context) {
    final NotificationCubit cubit = BlocProvider.of<NotificationCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          bool isLoggedIn = HiveUser.getLoggedIn();

          if (!isLoggedIn) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "You aren't logged in!\nLogin to view notifications!",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (state is NotificationLoading) {
            return const LoadingWidget();
          } else if (state is NotificationLoaded) {
            return cubit.notifications.isEmpty
                ? const Center(child: Text("No notification"))
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ListView.separated(
                      itemCount: cubit.notifications.length,
                      itemBuilder: (context, i) {
                        return NotificationWidget(cubit.notifications[i]);
                      },
                      separatorBuilder: (context, i) {
                        return const SizedBox(height: 10);
                      },
                    ),
                  );
          }

          return const Center(child: Text("Error loading notifications."));
        },
      ),
    );
  }
}
