import 'package:contact_app1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:contact_app1/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:contact_app1/features/auth/data/datasources/auth_service.dart';
import 'package:contact_app1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:contact_app1/features/auth/domain/repositories/auth_repository.dart';
import 'package:contact_app1/features/auth/domain/usecases/check_token.dart';
import 'package:contact_app1/features/auth/domain/usecases/get_token.dart';
import 'package:contact_app1/features/auth/domain/usecases/login_user.dart';
import 'package:contact_app1/features/auth/domain/usecases/logout_user.dart';
import 'package:contact_app1/features/auth/domain/usecases/register_user.dart';
import 'package:contact_app1/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:contact_app1/features/company/data/datasources/company_remote_data_source.dart';
import 'package:contact_app1/features/company/data/datasources/company_remote_data_source_impl.dart';

import 'package:contact_app1/features/company/data/datasources/company_service.dart';
import 'package:contact_app1/features/company/data/repositories/company_repository_impl.dart';
import 'package:contact_app1/features/company/domain/repositories/company_repository.dart';
import 'package:contact_app1/features/company/domain/useCases/get_company_details.dart';
import 'package:contact_app1/features/company/domain/useCases/update_company.dart';
import 'package:contact_app1/features/company/presentation/bloc/company_cubit.dart';
import 'package:contact_app1/features/contact/data/datasources/contact_remote_data_source.dart';
import 'package:contact_app1/features/contact/data/datasources/contact_remote_data_source_impl.dart';

import 'package:contact_app1/features/contact/data/datasources/contact_service.dart';
import 'package:contact_app1/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:contact_app1/features/contact/domain/repositories/contact_repository.dart';
import 'package:contact_app1/features/contact/domain/usecases/create_contact.dart';
import 'package:contact_app1/features/contact/domain/usecases/delete_contact.dart';
import 'package:contact_app1/features/contact/domain/usecases/delete_one_contact.dart';
import 'package:contact_app1/features/contact/domain/usecases/fetch_contacts.dart';
import 'package:contact_app1/features/contact/domain/usecases/send_email.dart';
import 'package:contact_app1/features/contact/domain/usecases/toggle_favorite.dart';
import 'package:contact_app1/features/contact/domain/usecases/update_contact.dart';
import 'package:contact_app1/features/contact/presentation/bloc/conatct_cubit.dart';
import 'package:contact_app1/features/user/data/datasources/user_remote_data_source.dart';
import 'package:contact_app1/features/user/data/datasources/user_remote_data_source_impl.dart';

import 'package:contact_app1/features/user/data/datasources/users_service.dart';
import 'package:contact_app1/features/user/data/repositories/user_repository_impl.dart';
import 'package:contact_app1/features/user/domain/repositories/user_repository.dart';
import 'package:contact_app1/features/user/domain/usecases/create_user.dart';
import 'package:contact_app1/features/user/domain/usecases/delete_all_users.dart';
import 'package:contact_app1/features/user/domain/usecases/get_users.dart';
import 'package:contact_app1/features/user/domain/usecases/update_user.dart';
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

//remot data source
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

//Repository
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

  ////// Use Cases
  //company
  sl.registerLazySingleton<UpdateCompany>(() => UpdateCompany(sl()));
  sl.registerLazySingleton<GetCompanyDetails>(() => GetCompanyDetails(sl()));

//user
  sl.registerLazySingleton<CreateUser>(() => CreateUser(sl()));
  sl.registerLazySingleton<UpdateUser>(() => UpdateUser(sl()));
  sl.registerLazySingleton<GetUsers>(() => GetUsers(sl()));
  sl.registerLazySingleton<DeleteAllUsers>(() => DeleteAllUsers(sl()));

  //contsct
  sl.registerLazySingleton<CreateContact>(() => CreateContact(sl()));
  sl.registerLazySingleton<UpdateContact>(() => UpdateContact(sl()));
  sl.registerLazySingleton<FetchContacts>(() => FetchContacts(sl()));
  sl.registerLazySingleton<DeleteContact>(() => DeleteContact(sl()));
  sl.registerLazySingleton<DeleteOneContact>(() => DeleteOneContact(sl()));
  sl.registerLazySingleton<SendEmail>(() => SendEmail(sl()));
  sl.registerLazySingleton<ToggleFavorite>(() => ToggleFavorite(sl()));

  // auth use cases
  sl.registerLazySingleton<CheckToken>(() => CheckToken(sl()));
  sl.registerLazySingleton<GetToken>(() => GetToken(sl()));
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl()));
  sl.registerLazySingleton<LogoutUser>(() => LogoutUser(sl()));
  sl.registerLazySingleton<RegisterUser>(() => RegisterUser(sl()));

  // Cubits
  sl.registerFactory(() => AuthCubit(
        checkTokenUseCase: sl(),
        getTokenUseCase: sl(),
        loginUserUseCase: sl(),
        registerUserUseCase: sl(),
        logoutUserUseCase: sl(),
      ));

  sl.registerFactory(() => CompanyCubit(
        getCompanyDetailsUseCase: sl(),
        updateCompanyUseCase: sl(),
      ));

  sl.registerFactory(() => ContactCubit(
      createContactUseCase: sl(),
      deleteContactUseCase: sl(),
      deleteOneContactUseCase: sl(),
      fetchContactsUseCase: sl(),
      sendEmailUseCase: sl(),
      toggleFavoriteUseCase: sl(),
      updateContactUseCase: sl()));

  sl.registerFactory(() => UserCubit(
      createUserUseCase: sl(),
      deleteAllUsersUseCase: sl(),
      getUsersUseCase: sl(),
      updateUserUseCase: sl()));
}
