import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang2.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_gewaesser.dart';
import 'package:hot_spot/src/features/authentication/presentation/gewaesser.dart';
import 'package:hot_spot/src/features/authentication/presentation/hitliste.dart';
import 'package:hot_spot/src/features/overview/presentation/startscreen.dart';

class App extends StatelessWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const App({
    super.key,
    required this.authRepository,
    required this.databaseRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
        databaseRepository: databaseRepository,
        authRepository: authRepository,
        username: '',
        profileImageUrl: '',
      ),
    );
  }
}
