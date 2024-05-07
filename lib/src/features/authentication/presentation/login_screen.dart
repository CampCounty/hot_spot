import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class LoginScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  const LoginScreen({super.key, required this.databaseRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
                ),
                SizedBox(height: 80),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 2, 247, 165)),
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
                )
              ],
            )),
          ),
        ),
      ]),
    );
  }
}
