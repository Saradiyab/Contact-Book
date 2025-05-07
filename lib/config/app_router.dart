
import 'package:contact_app1/features/auth/data/datasources/auth_service.dart';
import 'package:contact_app1/features/auth/presentation/page/login_screen.dart';
import 'package:contact_app1/features/auth/presentation/page/register_screen.dart';
import 'package:contact_app1/features/company/presentation/page/company_profile_screen.dart';
import 'package:contact_app1/features/contact/presentation/page/contacts_screen.dart';
import 'package:contact_app1/features/home/presentation/page/home_screen.dart';
import 'package:contact_app1/features/profile/presentation/page/profile_screen.dart';
import 'package:contact_app1/features/user/presentation/page/users_screen.dart';
import 'package:flutter/material.dart';


class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login_screen':
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: RouteSettings(name: '/login_screen'),
        );

      case '/register_screen':
        return MaterialPageRoute(
          builder: (context) => RegisterScreen(),
          settings: RouteSettings(name: '/register_screen'),
        );

      case '/home_screen':
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<String?>(
            future: AuthService().getToken(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return LoginScreen();
              }
              return HomeScreen(token: snapshot.data!);
            },
          ),
          settings: RouteSettings(name: '/home_screen'),
        );

      case '/contacts_screen':
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<String?>(
            future: AuthService().getToken(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                return LoginScreen();
              }
              return ContactsScreen(userToken: snapshot.data!);
            },
          ),
          settings: RouteSettings(name: '/contacts_screen'),
        );

      case '/profile_screen':
        return MaterialPageRoute(
          builder: (context) => ProfileScreen(),
          settings: RouteSettings(name: '/profile_screen'),
        );

      case '/users_screen':
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<String?>(
            future: AuthService().getToken(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                return LoginScreen();
              }
              return UsersScreen(userToken: snapshot.data!);
            },
          ),
          settings: RouteSettings(name: '/users_screen'),
        );

      case '/company_profile_screen':
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<String?>(
            future: AuthService().getToken(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                return LoginScreen();
              }
              return CompanyProfileScreen(userToken: snapshot.data!);
            },
          ),
          settings: RouteSettings(name: '/company_profile_screen'),
        );

      default:
        return null;
    }
  }
}