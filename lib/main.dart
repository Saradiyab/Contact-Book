import 'package:contact_app1/config/app_router.dart';
import 'package:contact_app1/core/dependency_injection/injection_container.dart';
import 'package:contact_app1/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:contact_app1/features/company/presentation/bloc/company_cubit.dart';
import 'package:contact_app1/features/contact/presentation/bloc/conatct_cubit.dart';
import 'package:contact_app1/features/user/presentation/bloc/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  final appRouter = AppRouter();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await init(); // injection start

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations', 
      fallbackLocale: Locale('en'), 
      child: MyApp(appRouter: appRouter),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<CompanyCubit>(create: (_) => sl<CompanyCubit>()),
        BlocProvider<ContactCubit>(create: (_) => sl<ContactCubit>()),
        BlocProvider<UserCubit>(create: (_) => sl<UserCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login_screen',
        onGenerateRoute: appRouter.generateRoute,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
