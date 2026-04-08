import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void serverLocator() {
  // getIt.registerLazySingleton<ApiService>(() => ApiService(Dio()));

  // getIt.registerLazySingleton<AuthDataSource>(
  //   () => AuthDataSourceImpl(apiService: getIt<ApiService>()),
  // );
  // getIt.registerLazySingleton<AuthRepo>(
  //   () => AuthRepoImpl(authDataSource: getIt<AuthDataSource>()),
  // );

  // getIt.registerLazySingleton<HomeRemoteDataSource>(
  //   () => HomeRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  // );
  // getIt.registerLazySingleton<HomeRepo>(
  //   () => HomeRepoImpl(homeRemoteDataSource: getIt<HomeRemoteDataSource>()),
  // );
}
