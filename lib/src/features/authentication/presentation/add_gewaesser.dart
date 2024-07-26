import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/overview/domain/menue.dart';

class AddGewaesser extends StatefulWidget {
  const AddGewaesser(
      {super.key,
      required this.databaseRepository,
      required this.authRepository,
      required this.username,
      required this.profileImageUrl});

  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  final String username;
  final String profileImageUrl;

  @override
  _AddGewaesserState createState() => _AddGewaesserState();
}

class _AddGewaesserState extends State<AddGewaesser> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBundesland;
  String? selectedLandkreis;
  String? gewaesserName;
  String? ort;

  List<String> bundeslaender = [];
  List<String> landkreise = [];

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
      });
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
      });
    } catch (e) {
      print('Fehler beim Laden der Landkreise: $e');
    }
  }

  Future<void> _addGewaesser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('Bundesländer')
            .doc(selectedBundesland)
            .collection('Landkreis')
            .doc(selectedLandkreis)
            .collection('Gewässer')
            .doc(gewaesserName)
            .set({
          'name': gewaesserName,
          'ort': ort,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Gewässer erfolgreich hinzugefügt,vielen Dank für deine Mitarbeit'),
          ),
        );
        setState(() {
          selectedLandkreis = null;
          gewaesserName = null;
          ort = null;
        });
      } catch (e) {
        print('Fehler beim Hinzufügen des Gewässers: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fehler beim Hinzufügen des Gewässers')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        username: widget.username,
        profileImageUrl: widget.profileImageUrl,
        databaseRepository: widget.databaseRepository,
        authRepository: widget.authRepository,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
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
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.asset(
                                'assets/images/hintergründe/hslogo 5.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Neues Gewässer hinzufügen",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 25.0),
                          ),
                        ),
                        const SizedBox(height: 100),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Bundesland',
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
                              selectedLandkreis = null;
                              if (newValue != null) {
                                _loadLandkreise(newValue);
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte wählen Sie ein Bundesland aus';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Landkreis',
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
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte wähle einen Landkreis aus';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Gewässername',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              gewaesserName = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte gib einen Gewässernamen ein';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Ort',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              ort = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte gib einen Ort ein';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _addGewaesser,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Gewässer speichern'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
