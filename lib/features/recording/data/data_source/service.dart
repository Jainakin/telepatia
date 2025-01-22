import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/state/recordings_notifier.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
  );

  print("service is now initialized");
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  service.on("stop").listen((event) {
    service.stopSelf();
    print("background process is now stopped");
  });

  service.on("start").listen((event) {
    print("background process is now started");
  });

  service.on("record").listen((event) {
    print("service is now recording");
    Future.delayed(const Duration(seconds: 1), () {
      final container = ProviderContainer();
      final recordingsNotifier =
          container.read(recordingsNotifierProvider.notifier);
      recordingsNotifier.record();
      print("service is successfully running ${DateTime.now().second}");
    });
  });

  service.on("upload").listen((event) async {
    await Firebase.initializeApp();

    print("service is now uploading");
    Future.delayed(const Duration(seconds: 1), () {
      final container = ProviderContainer();
      final recordingsNotifier =
          container.read(recordingsNotifierProvider.notifier);
      recordingsNotifier.stopRecording();
      print("service is successfully running ${DateTime.now().second}");
    });
  });
}
