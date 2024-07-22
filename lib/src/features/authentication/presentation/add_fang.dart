import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class AddFang extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const AddFang({
    super.key,
    required this.databaseRepository,
    required this.authRepository,
  });

  @override
  State<AddFang> createState() => _AddFangState();
}

class _AddFangState extends State<AddFang> {
  String? selectedFischart;
  final TextEditingController _groesseController = TextEditingController();
  final TextEditingController _gewichtController = TextEditingController();

  final TextEditingController _datumController = TextEditingController();
  final TextEditingController _uhrzeitController = TextEditingController();
  final TextEditingController _ortController = TextEditingController();
  final TextEditingController _gewaesserController = TextEditingController();
  String? _selectedBundesland;

  final List<String> _bundeslaender = [
    'Baden-Württemberg',
    'Bayern',
    'Berlin',
    'Brandenburg',
    'Bremen',
    'Hamburg',
    'Hessen',
    'Mecklenburg-Vorpommern',
    'Niedersachsen',
    'Nordrhein-Westfalen',
    'Rheinland-Pfalz',
    'Saarland',
    'Sachsen',
    'Sachsen-Anhalt',
    'Schleswig-Holstein',
    'Thüringen',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _datumController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Datumauswahl abgebrochen'),
        ),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _uhrzeitController.text = picked.format(context);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Standortberechtigung verweigert')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Standortberechtigung dauerhaft verweigert')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _ortController.text = '${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Abrufen des Standorts: $e')),
      );
    }
  }

  Future<void> _saveFangToFirebase() async {
    if (selectedFischart == null ||
        _groesseController.text.isEmpty ||
        _datumController.text.isEmpty ||
        _uhrzeitController.text.isEmpty ||
        _ortController.text.isEmpty ||
        _selectedBundesland == null ||
        _gewaesserController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bitte füllen Sie alle erforderlichen Felder aus.')),
      );
      return;
    }

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Kein Benutzer angemeldet');
      }

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      await userDoc.collection('faenge').add({
        'fischart': selectedFischart,
        'groesse': int.parse(_groesseController.text),
        'gewicht': _gewichtController.text.isNotEmpty
            ? int.parse(_gewichtController.text)
            : null,
        'datum': _datumController.text,
        'uhrzeit': _uhrzeitController.text,
        'ort': _ortController.text,
        'bundesland': _selectedBundesland,
        'gewaesser': _gewaesserController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fang erfolgreich gespeichert!')),
      );

      // Navigieren zum HomeScreen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            databaseRepository: widget.databaseRepository,
            authRepository: widget.authRepository,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Speichern: $e')),
      );
    }
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
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _datumController,
                                decoration: InputDecoration(
                                  labelText: 'Datum',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  await _selectDate(context);
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _uhrzeitController,
                                decoration: InputDecoration(
                                  labelText: 'Uhrzeit',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  await _selectTime(context);
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _ortController,
                                decoration: InputDecoration(
                                  labelText: 'Ort',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.gps_fixed),
                                    onPressed: _getCurrentLocation,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedBundesland,
                                decoration: InputDecoration(
                                  labelText: 'Bundesland',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: _bundeslaender.map((String bundesland) {
                                  return DropdownMenuItem<String>(
                                    value: bundesland,
                                    child: Text(bundesland),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedBundesland = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _gewaesserController,
                                decoration: InputDecoration(
                                  labelText: 'Gewässername',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: _saveFangToFirebase,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 79, 106, 78),
                                    foregroundColor: const Color.fromARGB(
                                        255, 223, 242, 224),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Speichern',
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
