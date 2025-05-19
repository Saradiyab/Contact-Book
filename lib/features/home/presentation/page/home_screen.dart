import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/widgets/custom_appbar.dart';
import 'package:contact_app1/core/widgets/custom_drawer.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:contact_app1/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:contact_app1/features/home/presentation/widget/latest_activities.dart';
import 'package:contact_app1/features/home/presentation/widget/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final token = context.watch<AuthCubit>().state.token;

    if (token == null) {
      return const Scaffold(
        body: Center(
          child: Text('Kullanıcı giriş yapmamış.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: token),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              AppStrings.statisticalDashboard.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            StatCard(
              count: AppStrings.number,
              label: AppStrings.active.tr(),
              color: AppColors.cartgreen,
              isUp: true,
            ),
            const SizedBox(height: 30),
            StatCard(
              count: AppStrings.number,
              label: AppStrings.inactive.tr(),
              color: AppColors.red,
              isUp: false,
            ),
            const SizedBox(height: 30),
            StatCard(
              count: AppStrings.number,
              label: AppStrings.withEmail.tr(),
              color: AppColors.darkblue,
              isUp: true,
            ),
            const SizedBox(height: 30),
            StatCard(
              count: AppStrings.number,
              label: AppStrings.withoutEmail.tr(),
              color: AppColors.lightblue,
              isUp: false,
            ),
            const SizedBox(height: 30),
             LatestActivities(),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}
