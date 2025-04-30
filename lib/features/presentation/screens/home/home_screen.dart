import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/presentation/widgets/custom/custom_appbar.dart';
import 'package:contact_app1/features/presentation/widgets/custom/custom_drawer.dart';
import 'package:contact_app1/features/presentation/widgets/custom/footer_widget.dart';
import 'package:contact_app1/features/presentation/widgets/latest_activities.dart';
import 'package:contact_app1/features/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  final String token;

  const HomeScreen({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: token),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              AppStrings.statisticalDashboard,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 16),
            StatCard(count: "101", label: AppStrings.active, color: AppColors.cartgreen, isUp: true),
            SizedBox(height: 30),
            StatCard(count: "101", label: AppStrings.inactive, color: AppColors.red, isUp: false),
            SizedBox(height: 30),
            StatCard(count: "101", label: AppStrings.withEmail, color: AppColors.darkblue, isUp: true),
            SizedBox(height: 30),
            StatCard(count: "101", label: AppStrings.withoutEmail, color: AppColors.lightblue, isUp: false),
            SizedBox(height: 30),
            LatestActivities(),     
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}
