import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/sign_up_screen.dart'; // Updated import path

class StartScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  const StartScreen({
    super.key,
    required this.databaseRepository,
    required this.authRepository,
  });

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  get databaseRepository => null;

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
                mainAxisAlignment: MainAxisAlignment.start,
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

                  // Add space between logo and text
                  const SizedBox(height: 20.0),

                  // Welcome text
                  const Text(
                    "Willkommen bei Hot Spot",
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color.fromARGB(255, 212, 178, 124),
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Container(
                        height: 1.0,
                        width: 150.0,
                        color: const Color.fromARGB(255, 251, 250, 250),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Subtitle
                  const Text(
                    "die App von Angler - für Angler",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 41, 42, 42),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Feature list
                  const Column(
                    children: [
                      Text(
                        "+ teile deine Fänge",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 41, 42, 42),
                        ),
                      ),
                      Text(
                        "+ finde neue Spots",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 41, 42, 42),
                        ),
                      ),
                      Text(
                        "+ behalte deine Fänge im Blick",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 41, 42, 42),
                        ),
                      ),
                      Text(
                        "+ verbinde dich mit anderen Anglern",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 41, 42, 42),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Login and Register buttons at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 49, 117, 52),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Navigate to LoginScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(
                            authRepository: widget.authRepository,
                            databaseRepository: widget.databaseRepository,
                          ),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 49, 117, 52),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen(
                                  databaseRepository: widget.databaseRepository,
                                  authRepository: widget.authRepository))
                          // Navigate to Register page (to be implemented)
                          // For now, we'll just print a message
                          );
                    },
                    child: const Text('Registrieren'),
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
