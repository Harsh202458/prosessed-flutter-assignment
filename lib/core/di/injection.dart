import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:shopsphere/core/network/auth_interceptor.dart';
import 'package:shopsphere/core/network/connectivity_cubit.dart';
import 'package:shopsphere/core/network/connectivity_service.dart';
import 'package:shopsphere/core/network/dio_client.dart';
import 'package:shopsphere/core/network/session_expiry_notifier.dart';
import 'package:shopsphere/core/router/app_router.dart';
import 'package:shopsphere/core/storage/settings_storage.dart';
import 'package:shopsphere/core/storage/token_storage.dart';
import 'package:shopsphere/core/theme/theme_cubit.dart';
import 'package:shopsphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:shopsphere/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shopsphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopsphere/features/auth/domain/usecases/check_session.dart';
import 'package:shopsphere/features/auth/domain/usecases/get_current_user.dart';
import 'package:shopsphere/features/auth/domain/usecases/login.dart';
import 'package:shopsphere/features/auth/domain/usecases/logout.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopsphere/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:shopsphere/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:shopsphere/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopsphere/features/cart/domain/repositories/cart_repository.dart';
import 'package:shopsphere/features/cart/domain/usecases/place_order.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/products/data/datasources/product_local_data_source.dart';
import 'package:shopsphere/features/products/data/datasources/product_remote_data_source.dart';
import 'package:shopsphere/features/products/data/repositories/product_repository_impl.dart';
import 'package:shopsphere/features/products/domain/repositories/product_repository.dart';
import 'package:shopsphere/features/products/domain/usecases/get_categories.dart';
import 'package:shopsphere/features/products/domain/usecases/get_product_details.dart';
import 'package:shopsphere/features/products/domain/usecases/get_products.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shopsphere/features/products/presentation/cubit/categories_cubit.dart';
import 'package:shopsphere/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:shopsphere/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shopsphere/features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:shopsphere/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:shopsphere/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:shopsphere/features/wishlist/presentation/cubit/wishlist_cubit.dart';

/// Global service locator. Only the composition root and route builders use
/// it; widgets receive their blocs through `BlocProvider`.
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();
  final cartBox = await Hive.openBox<String>(CartLocalDataSourceImpl.boxName);
  final settingsBox = await Hive.openBox<String>(SettingsStorage.boxName);
  final productsBox = await Hive.openBox<String>(
    ProductLocalDataSourceImpl.boxName,
  );
  _registerCore(settingsBox);
  _registerAuth();
  _registerProducts(productsBox);
  _registerCart(cartBox);
  _registerWishlist(
    await Hive.openBox<String>(WishlistLocalDataSourceImpl.boxName),
  );
  sl.registerLazySingleton<GoRouter>(() => createRouter(sl()));
}

void _registerCore(Box<String> settingsBox) {
  sl
    ..registerLazySingleton(() => SettingsStorage(settingsBox))
    ..registerLazySingleton(() => ThemeCubit(sl()))
    ..registerLazySingleton<ConnectivityService>(ConnectivityPlusService.new)
    ..registerLazySingleton(() => ConnectivityCubit(sl()))
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
    ..registerLazySingleton(() => GetCurrentUser(sl()))
    ..registerLazySingleton(() => ProfileCubit(sl()))
    ..registerLazySingleton(
      () => AuthBloc(checkSession: sl(), logout: sl(), sessionExpiry: sl()),
    )
    ..registerFactory(() => LoginCubit(sl()));
}

void _registerProducts(Box<String> productsBox) {
  sl
    ..registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(productsBox),
    )
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(remote: sl(), local: sl()),
    )
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => GetCategories(sl()))
    ..registerLazySingleton(() => GetProductDetails(sl()))
    ..registerFactory(() => ProductListBloc(sl()))
    ..registerFactory(() => CategoriesCubit(sl()))
    ..registerFactory(() => ProductDetailsCubit(sl()));
}

void _registerCart(Box<String> cartBox) {
  sl
    ..registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(cartBox),
    )
    ..registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(local: sl(), remote: sl()),
    )
    ..registerLazySingleton(
      () => PlaceOrder(cartRepository: sl(), authRepository: sl()),
    )
    ..registerLazySingleton(
      () => CartCubit(repository: sl(), placeOrder: sl()),
    );
}

void _registerWishlist(Box<String> wishlistBox) {
  sl
    ..registerLazySingleton<WishlistLocalDataSource>(
      () => WishlistLocalDataSourceImpl(wishlistBox),
    )
    ..registerLazySingleton<WishlistRepository>(
      () => WishlistRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => WishlistCubit(sl()));
}
