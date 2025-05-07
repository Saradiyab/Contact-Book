import 'package:contact_app1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:contact_app1/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:contact_app1/features/auth/data/datasources/auth_service.dart';
import 'package:contact_app1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:contact_app1/features/auth/domain/repositories/auth_repository.dart';
import 'package:contact_app1/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:contact_app1/features/company/data/datasources/company_remote_data_source.dart';
import 'package:contact_app1/features/company/data/datasources/company_remote_data_source_impl.dart';

import 'package:contact_app1/features/company/data/datasources/company_service.dart';
import 'package:contact_app1/features/company/data/repositories/company_repository_impl.dart';
import 'package:contact_app1/features/company/domain/repositories/company_repository.dart';
import 'package:contact_app1/features/company/presentation/bloc/company_cubit.dart';
import 'package:contact_app1/features/contact/data/datasources/contact_remote_data_source.dart';
import 'package:contact_app1/features/contact/data/datasources/contact_remote_data_source_impl.dart';

import 'package:contact_app1/features/contact/data/datasources/contact_service.dart';
import 'package:contact_app1/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:contact_app1/features/contact/domain/repositories/contact_repository.dart';
import 'package:contact_app1/features/contact/presentation/bloc/conatct_cubit.dart';
import 'package:contact_app1/features/user/data/datasources/user_remote_data_source.dart';
import 'package:contact_app1/features/user/data/datasources/user_remote_data_source_impl.dart';

import 'package:contact_app1/features/user/data/datasources/users_service.dart';
import 'package:contact_app1/features/user/data/repositories/user_repository_impl.dart';
import 'package:contact_app1/features/user/domain/repositories/user_repository.dart';
import 'package:contact_app1/features/user/presentation/bloc/user_cubit.dart';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio setup
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

  // Services / Datasources
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<CompanyService>(() => CompanyService(sl()));
  sl.registerLazySingleton<ContactService>(() => ContactService(sl()));
  sl.registerLazySingleton<UsersService>(() => UsersService(sl()));

  sl.registerLazySingleton<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSourceImpl(companyService: sl()),
  );

  sl.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(contactService: sl()),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(userservice: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(authService: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl()),
  );

  sl.registerLazySingleton<CompanyRepository>(
    () => CompanyRepositoryImpl(companyRemoteDataSource: sl()),
  );

  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(
      contactRemoteDataSource: sl(),
      authService: sl(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Cubits
  sl.registerFactory(() => AuthCubit(authRepository: sl()));
  sl.registerFactory(() => CompanyCubit(companyRepository: sl()));
  sl.registerFactory(() => ContactCubit(contactRepository: sl()));
  sl.registerFactory(() => UserCubit(userRepository: sl()));
}
