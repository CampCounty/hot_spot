import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';

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
  bool showPassword = false;
  bool _isLoading = false;

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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bitte geben Sie eine E-Mail-Adresse ein';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Bitte geben Sie eine gültige E-Mail-Adresse ein';
    }
    return null;
  }

  String? validatePw(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bitte geben Sie ein Passwort ein';
    }
    if (value.length < 6) {
      return 'Das Passwort muss mindestens 6 Zeichen lang sein';
    }
    return null;
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Passwort zurücksetzen'),
          content: const Text('Diese Funktion ist noch nicht implementiert.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    Row(
                      children: [
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Container(
                          height: 2.0,
                          width: 200.0,
                          color: const Color.fromARGB(255, 95, 114, 95),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                      ],
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
                      onPressed: _showForgotPasswordDialog,
                      child: const Text(
                        "Passwort vergessen?",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              String email = _emailController.text.trim();
                              String password = _pwController.text.trim();

                              try {
                                await widget.authRepository
                                    .signUpWithEmailAndPassword(
                                        email, password);
                                Navigator.pushReplacement(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                      databaseRepository:
                                          widget.databaseRepository,
                                      authRepository: widget.authRepository,
                                      username: '',
                                      profileImageUrl: '',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print('Login fehlgeschlagen: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Login fehlgeschlagen: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 95, 114, 95),
                        foregroundColor:
                            const Color.fromARGB(255, 251, 251, 250),
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
}
