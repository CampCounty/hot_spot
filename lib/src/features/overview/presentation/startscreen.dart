import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class StartScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  const StartScreen(
      {super.key,
      required this.databaseRepository,
      required AuthRepository authRepository});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/hintergründe/Blancscreen.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay image
          Positioned(
            top: 100,
            left: 100,
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/images/hintergründe/hslogo 5.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
