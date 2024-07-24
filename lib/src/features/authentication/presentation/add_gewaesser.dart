import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:hot_spot/src/features/authentication/presentation/hitliste.dart';
import 'package:hot_spot/src/features/authentication/presentation/login_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/profile.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.profileImageUrl,
    required this.databaseRepository,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hintergründe/Blancscreen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(profileImageUrl),
                        radius: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home,
                  color: Color.fromARGB(255, 43, 43, 43)),
              title: const Text('Home',
                  style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      databaseRepository: databaseRepository,
                      authRepository: authRepository,
                      username: '',
                      profileImageUrl: '',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.add, color: Color.fromARGB(255, 43, 43, 43)),
              title: const Text('Fang melden',
                  style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFang(
                      databaseRepository: databaseRepository,
                      authRepository: authRepository,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_2_rounded,
                  color: Color.fromARGB(255, 43, 43, 43)),
              title: const Text('Profil',
                  style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(
                      databaseRepository: databaseRepository,
                      authRepository: authRepository,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_outlined,
                  color: Color.fromARGB(255, 43, 43, 43)),
              title: const Text('Hitliste',
                  style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Hitliste(
                      databaseRepository: databaseRepository,
                      authRepository: authRepository,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings,
                  color: Color.fromARGB(255, 43, 43, 43)),
              title: const Text('Settings',
                  style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: const Icon(Icons.info,
                  color: Color.fromARGB(255, 43, 43, 43)),
              title: const Text('About',
                  style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
              onTap: () {
                Navigator.pop(context);
                // Navigate to about page
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout,
                  color: Color.fromARGB(255, 43, 43, 43)),
              title: const Text('Logout',
                  style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      databaseRepository: databaseRepository,
                      authRepository: authRepository,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
  String? ort; // Neues Feld hinzufügen

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
          'ort': ort, // Ort hinzufügen
          // Add more fields if needed
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gewässer erfolgreich hinzugefügt')),
        );
        setState(() {
          selectedLandkreis = null;
          gewaesserName = null;
          ort = null; // Ort zurücksetzen
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
                key: _formKey,
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
                      "Neues Gewässer hinzufügen",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 40.0),
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
                          return 'Bitte wählen Sie einen Landkreis aus';
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
                          return 'Bitte geben Sie einen Gewässernamen ein';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Ort', // Neues Feld hinzufügen
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          ort = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte geben Sie einen Ort ein'; // Validierung hinzufügen
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addGewaesser,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Gewässer hinzufügen'),
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
