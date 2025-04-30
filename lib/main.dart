import 'package:contact_app1/config/app_router.dart';
import 'package:contact_app1/core/dependency_injection/injection_container.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/auth_cubit.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/company_cubit.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/contact_cubit.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  final appRouter = AppRouter();
  WidgetsFlutterBinding.ensureInitialized();
  await init(); //injection start
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required AppRouter appRouter});

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
        initialRoute: '/login_screen',
        onGenerateRoute: AppRouter().generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
