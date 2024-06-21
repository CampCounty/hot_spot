import 'package:flutter/material.dart';
import 'package:hot_spot/src/app.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/data/mock_database.dart';

void main() {
  DatabaseRepository mockDatabase = MockDatabase();

  runApp(App(mockDatabase));
}
