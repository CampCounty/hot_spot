import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart';

class SignupConfirmScreen extends StatelessWidget {
  final DatabaseRepository databaseRepository;

  const SignupConfirmScreen({super.key, required this.databaseRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          SingleChildScrollView(
            child: Padding(
              padding: (EdgeInsets.all(16)),
              child: Form(
                  child: Column(
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Image.network("https://imgur.com/ClS7mSV.png"),
                  )),
                  SizedBox(height: 24),
                  const Text(
                    "Registrierung erfolgreich",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
                  ),
                  SizedBox(height: 48),
                  const Text(
                    "Willkommen bei Hot Spot",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                  ),
                  SizedBox(height: 440),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                    databaseRepository: databaseRepository,
                                  )));
                      // Handle button press here (e.g., form submission)
                    },
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color.fromARGB(
                          255, 168, 241, 172), // Set the button color to green
                    ),
                  )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
