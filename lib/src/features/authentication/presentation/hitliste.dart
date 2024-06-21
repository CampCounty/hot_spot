import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class Hitliste extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  const Hitliste({super.key, required this.databaseRepository});

  @override
  State<Hitliste> createState() => _HitlisteState();
}

class _HitlisteState extends State<Hitliste> {
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
                  const SizedBox(height: 10),
                  const Text(
                    "Hitliste",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
                  ),
                  const SizedBox(height: 10),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: widget.databaseRepository.getFaenge().length,
                  //   itemBuilder: (context, index) {
                  //     return Text(
                  //       widget.databaseRepository.getFaenge()[index].userID,
                  //     );
                  //   },
                  // )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
