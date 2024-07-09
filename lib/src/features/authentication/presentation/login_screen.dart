import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart'; // Updated import path

class LoginScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const LoginScreen({
    super.key,
    required this.databaseRepository,
    required this.authRepository,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              padding: const EdgeInsets.all(16),
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
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 40.0),
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
                            color: Color.fromARGB(255, 49, 117, 52),
                          ),
                        ),
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
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
                            color: Color.fromARGB(255, 49, 117, 52),
                          ),
                        ),
                        labelText: "Passwort",
                        labelStyle: const TextStyle(color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(showPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        _showForgotPasswordDialog();
                      },
                      child: const Text(
                        "Passwort vergessen?",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _pwController.text.trim();

                        try {
                          await widget.authRepository
                              .signUpWithEmailAndPassword(email, password);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                databaseRepository: widget.databaseRepository,
                                authRepository: widget.authRepository,
                              ),
                            ),
                          );
                        } catch (e) {
                          print('Login fehlgeschlagen: $e');
                        }
                      },
                      child: const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: const Color.fromARGB(255, 49, 117, 52),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String _email = '';

        return AlertDialog(
          title: const Text("Passwort zurücksetzen"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  "Geben Sie Ihre E-Mail-Adresse ein, um Anweisungen zum Zurücksetzen Ihres Passworts zu erhalten."),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "E-Mail",
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  _email = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Senden"),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Eine E-Mail zum Zurücksetzen des Passworts wurde gesendet"),
                    ),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Fehler beim Senden der Passwort-Zurücksetzungs-E-Mail"),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
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
