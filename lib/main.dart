import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/mock_database.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';

import 'package:hot_spot/src/features/authentication/presentation/sign_up_screen.dart';

void main() {
  MockDatabase mockDatabase = MockDatabase();
  runApp(MaterialApp(
    home: HomeScreen(
      databaseRepository: mockDatabase,
    ),
  ));
}
