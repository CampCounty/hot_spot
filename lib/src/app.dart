import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/sign_up_screen.dart';

class App extends StatelessWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  const App(
      {super.key,
      required this.authRepository,
      required this.databaseRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
        databaseRepository: databaseRepository,
        authRepository: authRepository,
      ),
    );
  }
}
