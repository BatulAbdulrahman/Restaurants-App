import 'dart:async';
import 'package:get_it/get_it.dart';
import 'core/services/connectivity/connectivity_service.dart';
import 'core/services/connectivity/connectivity_service_impl.dart';
import 'core/services/key_storage/key_storage_service.dart';
import 'core/services/key_storage/key_storage_service_impl.dart';
import 'core/services/navigation/navigation_service.dart';
import 'core/services/navigation/navigation_service_impl.dart';
import 'core/utils/file_helper.dart';

GetIt locator = GetIt.instance;

/// Setup function that is run before the App is run.
///   - Sets up singletons that can be called from anywhere
/// in the app by using locator<Service>() call.
///   - Also sets up factor methods for view models.

Future<void> setupLocator() async {
  // Services

  locator.registerLazySingleton<NavigationService>(
    () => NavigationServiceImpl(),
  );

  locator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(),
  );

  // Data sources

  await _setupSharedPreferences();

  // Utils   Specialization
  locator.registerLazySingleton<FileHelper>(() => FileHelperImpl());
}

Future<void> _setupSharedPreferences() async {
  final instance = await KeyStorageServiceImpl.getInstance();
  locator.registerLazySingleton<KeyStorageService>(() => instance!);
}
