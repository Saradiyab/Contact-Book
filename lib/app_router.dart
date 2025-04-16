import 'package:contact_app1/business_logic/cubit/contact_cubit.dart';
import 'package:contact_app1/business_logic/cubit/user_cubit.dart';
import 'package:contact_app1/data/api/auth_servic.dart';
import 'package:contact_app1/data/api/company_service.dart';
import 'package:contact_app1/data/api/contact_service.dart';
import 'package:contact_app1/data/api/users_service.dart';
import 'package:contact_app1/data/repository/auth_repository.dart';
import 'package:contact_app1/data/repository/company_repository.dart';
import 'package:contact_app1/data/repository/contact_repository.dart';
import 'package:contact_app1/data/repository/user_repository.dart';
import 'package:contact_app1/presentation/screens/auth/register_screen.dart';
import 'package:contact_app1/presentation/screens/company/company_profile_screen.dart';
import 'package:contact_app1/presentation/screens/contact/contacts_screen.dart';
import 'package:contact_app1/presentation/screens/profile_screen.dart';
import 'package:contact_app1/presentation/screens/users/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/presentation/screens/home/home_screen.dart';
import 'package:contact_app1/presentation/screens/auth/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/business_logic/cubit/company_cubit.dart';
import 'package:contact_app1/business_logic/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';

class AppRouter {
  final Dio dio = Dio();
  final CompanyRepository companyRepository;
  final ContactRepository contactRepository;
  final UserRepository userRepository;

  AppRouter()
      : companyRepository =
            CompanyRepository(companyService: CompanyService(Dio())),
        contactRepository = ContactRepository(
            contactService: ContactService(Dio()), authService: AuthService()),
        userRepository = UserRepository(usersService: UsersService(Dio()));

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login_screen':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(
              authRepository: AuthRepository(authService: AuthService()),
            ),
            child: LoginScreen(),
          ),
        );

      case '/register_screen':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(
              authRepository: AuthRepository(authService: AuthService()),
            ),
            child: RegisterScreen(),
          ),
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
        );

      case '/contacts_screen':
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<String?>(
            future: AuthService().getToken(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return LoginScreen();
              }
              return BlocProvider(
                create: (context) =>
                    ContactCubit(contactRepository: contactRepository),
                child: ContactsScreen(userToken: snapshot.data!),
              );
            },
          ),
        );

      case '/profile_screen':
        return MaterialPageRoute(builder: (context) => ProfileScreen());

      case '/users_screen':
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<String?>(
            future: AuthService().getToken(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return LoginScreen();
              }
              return BlocProvider(
                create: (context) => UserCubit(userRepository: userRepository),
                child: UsersScreen(userToken: snapshot.data!),
              );
            },
          ),
        );

      case '/company_profile_screen':
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<String?>(
            future: AuthService().getToken(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return LoginScreen();
              }
              return BlocProvider(
                create: (context) =>
                    CompanyCubit(companyRepository: companyRepository),
                child: CompanyProfileScreen(userToken: snapshot.data!),
              );
            },
          ),
        );

      default:
        return null;
    }
  }
}
