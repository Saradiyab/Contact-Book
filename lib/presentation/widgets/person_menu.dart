import 'package:contact_app1/core/constants/colors.dart';
import 'package:flutter/material.dart';

class PersonMenu extends StatefulWidget {
  const PersonMenu({super.key});

  @override
  State<PersonMenu> createState() => _PersonMenuState();
}

class _PersonMenuState extends State<PersonMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      offset: Offset(60, 45),
      color: Colors.white,
      elevation: 8,
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 220,
            width: 168,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ricardo Johnes",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.black,
                                  overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                            Text(
                              "ricardo@contact_book.com",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey[300],
                  height: 0,
                  indent: 0,
                  endIndent: 0,
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  text: "Settings",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.person,
                  text: "Profile",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/profile_screen');
                  },
                ),
                SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.logout,
                  text: "Log out",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/login_screen');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
      child: Icon(Icons.account_circle, color: Colors.white, size: 28),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            SizedBox(width: 12),
            Text(text,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black)),
          ],
        ),
      ),
    );
  }
}
