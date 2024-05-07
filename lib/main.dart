import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/mock_database.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/signup_confirm.dart';
import 'package:hot_spot/src/features/overview/presentation/startscreen.dart';

void main() {
  MockDatabase mockDatabase = MockDatabase();
  runApp(MaterialApp(
    home: SignupScreen(
      databaseRepository: mockDatabase,
    ),
  ));
}
