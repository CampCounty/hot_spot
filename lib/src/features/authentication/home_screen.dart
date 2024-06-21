import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  const HomeScreen({super.key, required this.databaseRepository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 43, 50, 43),
      ),
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
                    const SizedBox(height: 20),
                    // TODO: Kategorie Elemente einfügen
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
