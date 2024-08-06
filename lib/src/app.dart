import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
// ignore: unused_import
import 'package:hot_spot/src/features/authentication/presentation/map_screen.dart';

class App extends StatelessWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const App({
    Key? key,
    required this.authRepository,
    required this.databaseRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<String>(
        future: authRepository.getCurrentUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return HomeScreen(
              databaseRepository: databaseRepository,
              authRepository: authRepository,
              username: snapshot.data ?? '',
              profileImageUrl:
                  '', // Hier können Sie später die Logik für das Profilbild hinzufügen
            );
          }
          // Während des Ladens zeigen wir einen Ladeindikator an
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
