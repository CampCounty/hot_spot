import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/mock_database.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart';

void main() {
  MockDatabase mockDatabase = MockDatabase();
  runApp(MaterialApp(
    home: AddFang(
      databaseRepository: mockDatabase,
    ),
  ));
}
