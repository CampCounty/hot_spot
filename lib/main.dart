import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hot_spot/firebase_options.dart';
import 'package:hot_spot/src/app.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/data/mock_database.dart';

Future<void> main() async {
  DatabaseRepository mockDatabase = MockDatabase();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App(mockDatabase));
}
