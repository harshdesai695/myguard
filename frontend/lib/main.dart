import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myguard_frontend/app.dart';
import 'package:myguard_frontend/firebase_options.dart';
import 'package:myguard_frontend/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  runApp(const MyGuardApp());
}
