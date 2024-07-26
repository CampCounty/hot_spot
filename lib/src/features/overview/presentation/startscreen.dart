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
    required String username,
    required String profileImageUrl,
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
                  Text(
                    "Willkommen bei Hot Spot",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 212, 178, 124),
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: const Color.fromARGB(255, 5, 4, 4)
                              .withOpacity(0.9),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Container(
                        height: 2.0,
                        width: 300.0,
                        color: const Color.fromARGB(255, 95, 114, 95),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Subtitle
                  Text(
                    "die App",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 212, 178, 124),
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: const Color.fromARGB(255, 5, 4, 4)
                              .withOpacity(0.9),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "von Angler - für Angler",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 212, 178, 124),
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: const Color.fromARGB(255, 5, 4, 4)
                              .withOpacity(0.9),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    // Enables scrolling
                    child: Container(
                      // Container for image and shadow
                      decoration: BoxDecoration(
                        // Apply shadow to container
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 15, 49, 20)
                                .withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 25,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        // Clip rounded corners
                        borderRadius: BorderRadius.circular(25.0),
                        child: SizedBox(
                          // Define image size
                          height: 200,
                          width: 300,
                          child: Image.asset(
                            'assets/images/hintergründe/pic5.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Container(
                        height: 1.0,
                        width: 200.0,
                        color: const Color.fromARGB(255, 95, 114, 95),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 20),

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
                      SizedBox(height: 10.0),
                      Text(
                        "+ finde neue Spots",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 41, 42, 42),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "+ behalte deine Fänge im Blick",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 41, 42, 42),
                        ),
                      ),
                      SizedBox(height: 10.0),
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
                      backgroundColor: const Color.fromARGB(255, 95, 114, 95),
                      foregroundColor: const Color.fromARGB(255, 250, 250, 249),
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
                      backgroundColor: const Color.fromARGB(255, 95, 114, 95),
                      foregroundColor: const Color.fromARGB(255, 249, 249, 248),
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
