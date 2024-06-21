import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class AddFang extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  const AddFang({super.key, required this.databaseRepository});

  @override
  State<AddFang> createState() => _AddFangState();
}

class _AddFangState extends State<AddFang> {
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
                      padding: const EdgeInsets.all(32.0),
                      child: Image.asset(
                        "assets/images/hintergründe/hslogo 5.png",
                        width: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Fang eintragen",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
                  ),
                  const SizedBox(height: 24),
                  FutureBuilder(
                    future: widget.databaseRepository.getFischArten(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        // FALL: Future ist komplett und hat Daten!
                        List<String> fischarten = snapshot.data!;
                        return DropdownMenu(
                          width: 150,
                          label: const Text('Fischart'),
                          dropdownMenuEntries:
                              fischarten.map((String fischArt) {
                            return DropdownMenuEntry(
                                value: fischArt, label: fischArt);
                          }).toList(),
                        );
                      } else if (snapshot.connectionState !=
                          ConnectionState.done) {
                        // FALL: Sind noch im Ladezustand
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        // FALL: Es gab nen Fehler
                        return const Icon(Icons.error);
                      }
                    },
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
