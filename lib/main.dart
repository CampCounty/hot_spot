import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hot_spot/src/firebase_options.dart';
import 'package:hot_spot/src/app.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/data/mock_database.dart';
import 'package:hot_spot/src/firebase_options.dart';

Future<void> main() async {
  DatabaseRepository mockDatabase = MockDatabase();
  AuthRepository authRepository = AuthRepository(FirebaseAuth.instance);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App(
    authRepository: authRepository,
    databaseRepository: mockDatabase,
  ));
}
