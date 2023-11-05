import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/utils/config.dart';
import 'core/utils/device_util.dart';
import 'core/utils/logger.dart';
import 'core/utils/url_strategy/url_strategy.dart';
import 'core/utils/version_util.dart';
import 'firebase_options.dart';
import 'map/application/map_tiles/map_tile_info_service.dart';
import 'map/data/repositories/firestore_map_tile_repository.dart';

Future<void> _initializeFirebase(Config config) async {
  logger.i(
      '[Config] useFirebaseEmulators=${config.useFirebaseEmulators}, offlineEditingEnabled=${config.offlineEditingEnabled}');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (config.useFirebaseEmulators) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);

      await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);

      await FirebaseStorage.instance.useStorageEmulator('127.0.0.1', 9199);

      logger.i('Firebase Emulators initialized.');
    } catch (ex, st) {
      logger.w("Error on useEmulator: $ex\n$st");
    }
  }

  FirebaseFirestore.instance.settings = const Settings(
    sslEnabled: false,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  try {
    await FirebaseFirestore.instance.enablePersistence(
        PersistenceSettings(synchronizeTabs: config.offlineEditingEnabled));
  } catch (ex) {
    logger.w("Error on set EnablePersistence: $ex");
  }
}

Future<Override> _initMapTileInfoService() async {
  final service = MapTileInfoService(
    repository: FirestoreMapTileRepository(),
  );
  await service.isInitialized;
  return mapTileInfoServiceProvider.overrideWith(
    (ref) => service,
  );
}

Future<List<Override>> _getOverrides() async {
  final List<Override> overrides = [];

  overrides.addAll([
    // ...await _initAuthProviders(),
    // await _initSharedPhotoRepository(),
    // await _initBookmarkRepository(),
    await _initMapTileInfoService(),
    // _getRouterProvider(),
  ]);
  return overrides;
}

Future<void> main() async {
  // ignore: unused_local_variable
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  usePathUrlStrategy();

  await config.configure();
  if (config.isDebugMode) {
    logger.d("env=${config.toJsonString()}");
  }

  await _initializeFirebase(config);

  final versionInfo = await initVersionInfoProvider();
  final deviceInfo = await initDeviceInfoProvider();

  final overrides = await _getOverrides();

  runApp(
    ProviderScope(
      overrides: [
        versionInfo.providerOverride,
        deviceInfo.providerOverride,
        ...overrides,
      ],
      child: const MyApp(),
    ),
  );
}
