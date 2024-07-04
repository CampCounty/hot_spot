import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const HomeScreen({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
  }) : super(key: key);

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
          decoration: BoxDecoration(
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
                    Text(
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
                          style: TextStyle(
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
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.add, color: Colors.white),
                title:
                    Text('Fang melden', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_2_rounded, color: Colors.white),
                title: Text('Profil', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile page
                },
              ),
              ListTile(
                leading: Icon(Icons.list_outlined, color: Colors.white),
                title: Text('Hitliste', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to hit list page
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings page
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.white),
                title: Text('About', style: TextStyle(color: Colors.white)),
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
                icon: Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),

            // Overlay image
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(
                  'assets/images/hintergründe/hslogo 5.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
