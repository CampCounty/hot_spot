import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart';

class SignupScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const SignupScreen({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
  }) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _pwController;
  late TextEditingController _repeatPwController;
  late TextEditingController _usernameController;

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _pwController = TextEditingController();
    _repeatPwController = TextEditingController();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _repeatPwController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hintergründe/Blancscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
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
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 40.0),
                    ),
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
                      "Erstelle hier dein Konto für Hot Spot",
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _usernameController,
                      labelText: "Benutzername",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte geben Sie einen Benutzernamen ein';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _emailController,
                      labelText: "Email",
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _pwController,
                      labelText: "Passwort",
                      obscureText: !_showPassword,
                      validator: validatePw,
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _repeatPwController,
                      labelText: "Passwort wiederholen",
                      obscureText: !_showPassword,
                      validator: (value) =>
                          validateRepeatPw(_pwController.text, value),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(
                            databaseRepository: widget.databaseRepository,
                            authRepository: widget.authRepository,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Bereits registriert?",
                        style:
                            TextStyle(color: Color.fromARGB(255, 49, 117, 52)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 95, 114, 95),
                        foregroundColor:
                            const Color.fromARGB(255, 250, 249, 248),
                      ),
                      child: const Text('Registrieren'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color.fromARGB(255, 49, 117, 52)),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: suffixIcon,
      ),
    );
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.authRepository.signUpWithEmailAndPassword(
          _emailController.text,
          _pwController.text,
          _usernameController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              databaseRepository: widget.databaseRepository,
              authRepository: widget.authRepository,
              username: _usernameController.text,
              profileImageUrl: '',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrierung fehlgeschlagen: $e')),
        );
      }
    }
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

String? validateRepeatPw(String firstPw, String? secondPw) {
  if (secondPw == null || secondPw.isEmpty) {
    return 'Bitte wiederholen Sie das Passwort';
  }
  if (firstPw != secondPw) {
    return 'Die Passwörter stimmen nicht überein';
  }
  return null;
}
