import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:shopsphere/core/network/auth_interceptor.dart';
import 'package:shopsphere/core/network/dio_client.dart';
import 'package:shopsphere/core/network/session_expiry_notifier.dart';
import 'package:shopsphere/core/router/app_router.dart';
import 'package:shopsphere/core/storage/token_storage.dart';
import 'package:shopsphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:shopsphere/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shopsphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopsphere/features/auth/domain/usecases/check_session.dart';
import 'package:shopsphere/features/auth/domain/usecases/login.dart';
import 'package:shopsphere/features/auth/domain/usecases/logout.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopsphere/features/products/data/datasources/product_remote_data_source.dart';
import 'package:shopsphere/features/products/data/repositories/product_repository_impl.dart';
import 'package:shopsphere/features/products/domain/repositories/product_repository.dart';
import 'package:shopsphere/features/products/domain/usecases/get_categories.dart';
import 'package:shopsphere/features/products/domain/usecases/get_product_details.dart';
import 'package:shopsphere/features/products/domain/usecases/get_products.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shopsphere/features/products/presentation/cubit/categories_cubit.dart';
import 'package:shopsphere/features/products/presentation/cubit/product_details_cubit.dart';

/// Global service locator. Only the composition root and route builders use
/// it; widgets receive their blocs through `BlocProvider`.
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();
  _registerCore();
  _registerAuth();
  _registerProducts();
  sl.registerLazySingleton<GoRouter>(() => createRouter(sl()));
}

void _registerCore() {
  sl
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton(() => TokenStorage(sl()))
    ..registerLazySingleton(SessionExpiryNotifier.new)
    ..registerLazySingleton<Dio>(
      () => DioClient.create(
        interceptors: [
          AuthInterceptor(
            tokenStorage: sl(),
            sessionExpiry: sl(),
            refreshDio: DioClient.create(),
          ),
        ],
      ),
    );
}

void _registerAuth() {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), tokenStorage: sl()),
    )
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    ..registerLazySingleton(() => CheckSession(sl()))
    ..registerLazySingleton(
      () => AuthBloc(checkSession: sl(), logout: sl(), sessionExpiry: sl()),
    )
    ..registerFactory(() => LoginCubit(sl()));
}

void _registerProducts() {
  sl
    ..registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => GetCategories(sl()))
    ..registerLazySingleton(() => GetProductDetails(sl()))
    ..registerFactory(() => ProductListBloc(sl()))
    ..registerFactory(() => CategoriesCubit(sl()))
    ..registerFactory(() => ProductDetailsCubit(sl()));
}
