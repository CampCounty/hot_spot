import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart';

class App extends StatelessWidget {
  final DatabaseRepository databaseRepository;
  const App(this.databaseRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(
        databaseRepository: databaseRepository,
      ),
    );
  }
}
