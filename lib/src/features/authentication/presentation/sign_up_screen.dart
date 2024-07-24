import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart'; // Neuer Import

class SignupScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const SignupScreen(
      {super.key,
      required this.databaseRepository,
      required this.authRepository});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _emailController;
  late TextEditingController _pwController;

  bool get showPassword => false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _pwController = TextEditingController();
  }

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
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                          'assets/images/hintergründe/hslogo 5.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Registrieren",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
                  ),
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Container(
                        height: 2.0,
                        width: 250.0,
                        color: const Color.fromARGB(255, 95, 114, 95),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "erstelle hier dein Konto für Hot Spot",
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
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
                                color: Color.fromARGB(255, 96, 104, 96))),
                        labelText: "Passwort",
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
                        labelText: "Passwort wiederholen",
                        labelStyle: const TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(
                            databaseRepository: widget.databaseRepository,
                            authRepository: widget.authRepository,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Bereits registriert ?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 49, 117, 52),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await widget.authRepository.signUpWithEmailAndPassword(
                          _emailController.text, _pwController.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    databaseRepository:
                                        widget.databaseRepository,
                                    authRepository: widget.authRepository,
                                    username: '',
                                    profileImageUrl: '',
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 95, 114, 95),
                      foregroundColor: const Color.fromARGB(255, 250, 249, 248),
                    ),
                    child: const Text('Registrieren'),
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
