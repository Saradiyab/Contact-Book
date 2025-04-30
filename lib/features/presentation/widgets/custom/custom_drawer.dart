import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String token;

  const CustomDrawer({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            color: AppColors.blue,
            padding: const EdgeInsets.fromLTRB(18, 25, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/Logo_White.png",
                  height: 34,
                  fit: BoxFit.contain,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 24),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(AppStrings.home, onTap: () {
                  if (ModalRoute.of(context)?.settings.name != "/home_screen") {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/home_screen");
                  } else {
                    Navigator.pop(context);
                  }
                }),
                Divider(),
                _buildMenuItem(AppStrings.contacts, onTap: () {
                  if (ModalRoute.of(context)?.settings.name !=
                      "/contacts_screen") {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/contacts_screen");
                  } else {
                    Navigator.pop(context);
                  }
                }),
                Divider(),
                _buildMenuItem(AppStrings.companyProfile, onTap: () {
                  if (ModalRoute.of(context)?.settings.name !=
                      "/company_profile_screen") {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, "/company_profile_screen");
                  } else {
                    Navigator.pop(context);
                  }
                }),
                Divider(),
                _buildMenuItem(AppStrings.users, onTap: () {
                  if (ModalRoute.of(context)?.settings.name !=
                      "/users_screen") {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/users_screen");
                  } else {
                    Navigator.pop(context);
                  }
                }),
                Divider(),
                _buildMenuItem(AppStrings.userName, onTap: () {
                  Navigator.pop(context);
                }),
                Divider(),
                _buildMenuItem(AppStrings.myProfile, icon: Icons.person, onTap: () {
                  if (ModalRoute.of(context)?.settings.name !=
                      "/profile_screen") {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/profile_screen");
                  } else {
                    Navigator.pop(context);
                  }
                }),
                _buildMenuItem(AppStrings.logOut, icon: Icons.logout, onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/login_screen");
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, {IconData? icon, VoidCallback? onTap}) {
    return ListTile(
      leading:
          icon != null ? Icon(icon, size: 20, color: Colors.black54) : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: (title == "My Profile" || title == "Log out")
              ? FontWeight.normal
              : FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
