import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: Stack(
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

            // Center the content
            Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Center content vertically
                children: [
                  // Overlay image
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset(
                      'assets/images/hintergründe/hslogo 5.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Add space between logo and text (optional)
                  const SizedBox(height: 20.0),

                  // Text widget for your desired text
                  const Text(
                    "Willkommen bei Hot Spot",
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Color.fromARGB(255, 212, 178, 124)),
                  ),
                  const SizedBox(height: 10.0), // Add space before divider
                  Row(
                    // Create a row with padding
                    children: [
                      const Expanded(child: SizedBox()), // Add space on left
                      Container(
                        // Create divider container
                        height: 1.0,
                        width: 150.0, // Set divider width
                        color: const Color.fromARGB(255, 251, 250, 250),
                      ),
                      const Expanded(child: SizedBox()), // Add space on right
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    "die App von Angler - für Angler",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 41, 42, 42)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Column(
                    children: [
                      Text(
                        "+ teile deine Fänge",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 41, 42, 42)),
                      ),
                      Text(
                        "+ verbinde dich mit anderen Anglern",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 41, 42, 42)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
