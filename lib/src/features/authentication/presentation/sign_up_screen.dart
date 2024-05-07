import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/signup_confirm.dart';

class SignupScreen extends StatelessWidget {
  final DatabaseRepository databaseRepository;

  const SignupScreen({super.key, required this.databaseRepository});

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
                    "Registrieren",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
                  ),
                  SizedBox(height: 80),
                  TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 2, 247, 165)),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 247, 165))),
                        labelText: "Passwort",
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 247, 165))),
                        labelText: "Passwort wiederholen",
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupConfirmScreen(
                                    databaseRepository: databaseRepository,
                                  )));
                      // Handle button press here (e.g., form submission)
                    },
                    child: Text('Registrieren'),
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
