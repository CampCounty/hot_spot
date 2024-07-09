import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hot_spot/src/firebase_options.dart';
import 'package:hot_spot/src/app.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/data/mock_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DatabaseRepository mockDatabase = MockDatabase();
  AuthRepository authRepository = AuthRepository(FirebaseAuth.instance);
  runApp(
    App(
      authRepository: authRepository,
      databaseRepository: mockDatabase,
    ),
  );
}
