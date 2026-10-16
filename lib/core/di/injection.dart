import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:shopsphere/core/network/dio_client.dart';
import 'package:shopsphere/core/router/app_router.dart';

/// Global service locator. Only the composition root and route builders use
/// it; widgets receive their blocs through `BlocProvider`.
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();

  sl
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<Dio>(DioClient.create)
    ..registerLazySingleton<GoRouter>(createRouter);
}
