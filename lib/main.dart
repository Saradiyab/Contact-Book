import 'package:contact_app1/app_router.dart';
import 'package:contact_app1/business_logic/cubit/auth_cubit.dart';
import 'package:contact_app1/business_logic/cubit/company_cubit.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

void main() {
  final appRouter = AppRouter();
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthCubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            authRepository: AuthRepository(authService: AuthService()),
          ),
        ),
        // CompanyCubit
        BlocProvider<CompanyCubit>(
          create: (context) => CompanyCubit(
            companyRepository: CompanyRepository(companyService: CompanyService(Dio())),
          ),
        ),
        // ContactCubit
        BlocProvider<ContactCubit>(
          create: (context) => ContactCubit(
            contactRepository: ContactRepository(contactService: ContactService(Dio()), authService: AuthService()),
          ),
        ),
        // UserCubit
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(
            userRepository: UserRepository(usersService: UsersService(Dio())),
          ),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/login_screen', // Giriş ekranı ile başlatıyoruz.
        onGenerateRoute: appRouter.generateRoute, // AppRouter yönlendirme işini yapacak.
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
