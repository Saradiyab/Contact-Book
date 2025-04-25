import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/person_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).padding.top,
          color: Colors.white,
        ),
        Container(
          height: 60,
          color: AppColors.blue,
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.menu, color: Colors.white, size: 24),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              Center(
                child: Image.asset(
                  "assets/images/Logo_White.png",
                  height: 34, 
                  width: 168.31,
                  fit: BoxFit.contain,
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: PersonMenu(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
