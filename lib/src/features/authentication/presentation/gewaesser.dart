import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class Gewaesser extends StatefulWidget {
  const Gewaesser(
      {super.key,
      required DatabaseRepository databaseRepository,
      required AuthRepository authRepository,
      required String username,
      required String profileImageUrl});

  @override
  State<Gewaesser> createState() => _GewaesserState();
}

class _GewaesserState extends State<Gewaesser> {
  String? selectedBundesland;
  String? selectedLandkreis;
  String? selectedGewaesser;

  List<String> bundeslaender = [];
  List<String> landkreise = [];
  List<String> gewaesser = [];

  @override
  void initState() {
    super.initState();
    _loadBundeslaender();
  }

  Future<void> _loadBundeslaender() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Bundesländer').get();
      setState(() {
        bundeslaender =
            querySnapshot.docs.map((doc) => doc.id as String).toList();
        print('Geladene Bundesländer: $bundeslaender'); // Debugging-Ausgabe
      });
      if (bundeslaender.isNotEmpty) {
        selectedBundesland = bundeslaender.first;
        _loadLandkreise(selectedBundesland!);
      }
    } catch (e) {
      print('Fehler beim Laden der Bundesländer: $e');
    }
  }

  Future<void> _loadLandkreise(String bundesland) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Bundesländer')
          .doc(bundesland)
          .collection('Landkreis')
          .get();
      setState(() {
        landkreise = querySnapshot.docs.map((doc) => doc.id as String).toList();
        print('Geladene Landkreise: $landkreise'); // Debugging-Ausgabe
        selectedLandkreis = null;
        selectedGewaesser = null;
      });
    } catch (e) {
      print('Fehler beim Laden der Landkreise: $e');
    }
  }

  Future<void> _loadGewaesser(String landkreis) async {
    try {
      if (selectedBundesland == null) return;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Bundesländer')
          .doc(selectedBundesland)
          .collection('Landkreis')
          .doc(landkreis)
          .collection('Gewässer')
          .get();
      setState(() {
        gewaesser = querySnapshot.docs.map((doc) => doc.id as String).toList();
        print('Geladene Gewässer: $gewaesser'); // Debugging-Ausgabe
        selectedGewaesser = null;
      });
    } catch (e) {
      print('Fehler beim Laden der Gewässer: $e');
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
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/images/hintergründe/hslogo 5.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Gewässer",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 40.0),
                    ),
                    const SizedBox(height: 100),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Wähle Bundesland',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedBundesland,
                      items: bundeslaender.map((String bundesland) {
                        return DropdownMenuItem<String>(
                          value: bundesland,
                          child: Text(bundesland),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBundesland = newValue;
                          if (newValue != null) {
                            _loadLandkreise(newValue);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Wähle Landkreis',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedLandkreis,
                      items: landkreise.map((String landkreis) {
                        return DropdownMenuItem<String>(
                          value: landkreis,
                          child: Text(landkreis),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLandkreis = newValue;
                          if (newValue != null) {
                            _loadGewaesser(newValue);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Wähle Gewässer',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedGewaesser,
                      items: gewaesser.map((String gewaesser) {
                        return DropdownMenuItem<String>(
                          value: gewaesser,
                          child: Text(gewaesser),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGewaesser = newValue;
                        });
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
