import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class Gewaesser extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  const Gewaesser({super.key, required this.databaseRepository});

  @override
  State<Gewaesser> createState() => _GewaesserState();
}

class _GewaesserState extends State<Gewaesser> {
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
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                          'assets/images/hintergründe/hslogo 5.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Gewässer",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
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
