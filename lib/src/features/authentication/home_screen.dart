import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const HomeScreen({
    super.key,
    required this.databaseRepository,
    required this.authRepository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String username =
        "Daniel"; // Ersetzen Sie dies durch den tatsächlichen Benutzernamen
    String profileImageUrl =
        'assets/images/hintergründe/hslogo 5.png'; // Ersetzen Sie dies durch die tatsächliche URL des Profilbildes

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/hintergründe/Blancscreen.png'), // Pfad zu Ihrem Hintergrundbild
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors
                      .transparent, // Hintergrund transparent, damit das Bild sichtbar ist
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
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(profileImageUrl),
                          radius: 30,
                        ),
                        SizedBox(width: 10),
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add,
                    color: Color.fromARGB(255, 43, 43, 43)),
                title: const Text('Fang melden',
                    style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_2_rounded,
                    color: Color.fromARGB(255, 43, 43, 43)),
                title: const Text('Profil',
                    style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile page
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_outlined,
                    color: Color.fromARGB(255, 43, 43, 43)),
                title: const Text('Hitliste',
                    style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to hit list page
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
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
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

            // Custom menu button
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.menu,
                    color: Color.fromARGB(255, 250, 249, 249)),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),

            // Overlay image
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/hintergründe/hslogo 5.png',
                  height: 100, // Adjust the height as needed
                  width: 100, // Adjust the width as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
