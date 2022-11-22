import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo_mobile/modules/myaccount/ui/widgets/new_ui/new_loggedOut.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../services/cubit/account/account_cubit.dart';
import '../../services/hive/hive_user.dart';
import '../widgets/loggedIn.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountCubit(),
      child: const AccountBody(),
    );
  }
}

class AccountBody extends StatefulWidget {
  const AccountBody({super.key});

  @override
  _AccountBodyState createState() => _AccountBodyState();
}

class _AccountBodyState extends State<AccountBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AccountCubit>(context).getAccountState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "My Account",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            BlocBuilder<AccountCubit, AccountState>(
              builder: (context, state) {
                if (state is AccountLoggedIn) {
                  return IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      print('hive data ......)');
                      print(HiveUser.getUser());
                      Get.offAndToNamed("/updateProfile",
                          arguments: HiveUser.getUser());
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        body: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, state) {
            if (state is AccountProcessing) {
              return const LoadingWidget();
            } else if (state is AccountLoggedIn) {
              return const LoggedInWidget();
            } else if (state is AccountLoggedOut || state is AccountLoggingIn) {
              // return LoggedOutWidget();
              return const LoggedOutWidget();
            } else if (state is AccountLogginWithOTP) {
              return const LoggedOutWidget();
            }

            return const Center(
              child: Text("Error"),
            );
          },
        ));
  }
}
