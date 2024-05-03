import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                Center(child: Image.network("https://imgur.com/ClS7mSV.png")),
                SizedBox(height: 32),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
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
                          borderRadius: BorderRadius.circular(5.0),
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
