import 'package:contact_app1/presentation/screens/auth/login_screen.dart';
import 'package:contact_app1/presentation/screens/auth/register_screen.dart';
import 'package:contact_app1/presentation/screens/home/home_screen.dart';
import 'package:contact_app1/presentation/screens/contact/contacts_screen.dart';
import 'package:contact_app1/presentation/screens/users/users_screen.dart';
import 'package:contact_app1/presentation/screens/company/company_profile_screen.dart';
import 'package:contact_app1/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/data/api/auth_servic.dart';


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
