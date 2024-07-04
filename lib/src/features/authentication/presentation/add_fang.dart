import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang1.dart';

class AddFang extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const AddFang({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
  }) : super(key: key);

  @override
  State<AddFang> createState() => _AddFangState();
}

class _AddFangState extends State<AddFang> {
  String? selectedFischart;
  final TextEditingController _groesseController = TextEditingController();
  final TextEditingController _gewichtController = TextEditingController();

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
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 40.0,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "wähle deine Fischart ",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<List<String>>(
                      future: widget.databaseRepository.getFischArten(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          List<String> fischarten = snapshot.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButtonFormField<String>(
                                value: selectedFischart,
                                decoration: InputDecoration(
                                  labelText: 'Fischart',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: fischarten.map((String fischArt) {
                                  return DropdownMenuItem<String>(
                                    value: fischArt,
                                    child: Text(fischArt),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedFischart = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 36),
                              const Text(
                                "bitte gib die Größe ein",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextFormField(
                                controller: _groesseController,
                                decoration: InputDecoration(
                                  labelText: 'Größe (in cm)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 36),
                              const Text(
                                "bitte gib das Gewicht ein *",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextFormField(
                                controller: _gewichtController,
                                decoration: InputDecoration(
                                  labelText: 'Gewicht (in g)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const Text(
                                "* Angabe freiwillig",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 50),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddFang1(
                                          databaseRepository:
                                              widget.databaseRepository,
                                          authRepository: widget.authRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 79, 106, 78),
                                    foregroundColor:
                                        Color.fromARGB(255, 223, 242, 224),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Weiter',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.connectionState !=
                            ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Icon(Icons.error);
                        }
                      },
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
