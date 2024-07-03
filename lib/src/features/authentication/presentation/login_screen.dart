import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  //Konstruktor
  const LoginScreen(
      {super.key,
      required this.databaseRepository,
      required this.authRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // state:
  late TextEditingController _emailController;
  late TextEditingController _pwController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _pwController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  bool showPassword = false;

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
              padding: (const EdgeInsets.all(16)),
              child: Form(
                  child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                          'assets/images/hintergründe/hslogo 5.png'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Login",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
                  ),
                  const SizedBox(height: 80),
                  TextFormField(
                    controller: _emailController,
                    validator: validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 49, 117, 52)),
                        ),
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _pwController,
                    validator: validatePw,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 49, 117, 52))),
                        labelText: "Passwort",
                        labelStyle: const TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await widget.authRepository.signUpWithEmailAndPassword(
                          _emailController.text, _pwController.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                  databaseRepository: widget.databaseRepository,
                                  authRepository: widget.authRepository)));
                      // Handle button press here (e.g., form submission)
                    },
                    child: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(
                          255, 49, 117, 52), // Set the button color to green
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}

String? validateEmail(String? input) {
  if (input == null || input.isEmpty) {
    return 'Email darf nicht leer sein';
  }
  if (input.length <= 5) {
    return 'Email muss mehr als 5 Zeichen haben';
  }
  if (!input.contains('@')) {
    return 'Email muss ein "@" Zeichen enthalten';
  }
  if (!(input.endsWith('.com') || input.endsWith('.de'))) {
    return 'Email muss mit ".com" oder ".de" enden';
  }
  return null;
}

String? validatePw(String? input) {
  if (input == null || input.isEmpty) {
    return 'Passwort darf nicht leer sein';
  }
  if (input.length < 6 || input.length > 12) {
    return 'Passwort muss zwischen 6 und 12 Zeichen lang sein';
  }
  return null;
}

bool validateRepeatPw(String? firstPw, String? secondPw) {
  if (firstPw == secondPw) {
    return true;
  } else {
    return false;
  }
}
