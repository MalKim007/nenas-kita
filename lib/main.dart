import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nenas_kita/app.dart';
import 'package:nenas_kita/features/settings/providers/settings_providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive for local settings storage
  await initSettingsStorage();

  // Run app with Riverpod ProviderScope
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
