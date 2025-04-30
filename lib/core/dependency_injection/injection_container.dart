
import 'package:contact_app1/features/data/api/auth_servic.dart';
import 'package:contact_app1/features/data/api/company_service.dart';
import 'package:contact_app1/features/data/api/contact_service.dart';
import 'package:contact_app1/features/data/api/users_service.dart';
import 'package:contact_app1/features/data/repository/auth_repository.dart';
import 'package:contact_app1/features/data/repository/company_repository.dart';
import 'package:contact_app1/features/data/repository/contact_repository.dart';
import 'package:contact_app1/features/data/repository/user_repository.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/auth_cubit.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/company_cubit.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/contact_cubit.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/user_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ms.itmd-b1.com:5123/',
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 20),
  ));

  sl.registerLazySingleton<Dio>(() => dio);

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // AuthService Singleton
  sl.registerLazySingleton<AuthService>(() => AuthService());

  // Retrofit based services (with Dio dependency)
  sl.registerLazySingleton<CompanyService>(() => CompanyService(sl()));
  sl.registerLazySingleton<ContactService>(() => ContactService(sl()));
  sl.registerLazySingleton<UsersService>(() => UsersService(sl()));

// Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(authService: sl()));
  sl.registerLazySingleton(() => CompanyRepository(companyService: sl()));
  sl.registerLazySingleton(
      () => ContactRepository(contactService: sl(), authService: sl()));
  sl.registerLazySingleton(() => UserRepository(usersService: sl()));

// Cubits
  sl.registerFactory(() => AuthCubit(authRepository: sl()));
  sl.registerFactory(() => CompanyCubit(companyRepository: sl()));
  sl.registerFactory(() => ContactCubit(contactRepository: sl()));
  sl.registerFactory(() => UserCubit(userRepository: sl()));
}
