import 'package:contact_app1/presentation/widgets/latest_activities.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/stat_card.dart';
import 'package:contact_app1/presentation/widgets/custom/footer_widget.dart'; 

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
              "Statistical Dashboard",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 16),
            StatCard(count: "101", label: "Active", color: AppColors.cartgreen, isUp: true),
            SizedBox(height: 30),
            StatCard(count: "101", label: "Inactive", color: AppColors.red, isUp: false),
            SizedBox(height: 30),
            StatCard(count: "101", label: "With email", color: AppColors.darkblue, isUp: true),
            SizedBox(height: 30),
            StatCard(count: "101", label: "Without email", color: AppColors.lightblue, isUp: false),
            SizedBox(height: 30),
            LatestActivities(),     
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}
