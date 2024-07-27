import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:hot_spot/src/features/authentication/presentation/hitliste.dart';
import 'package:hot_spot/src/features/authentication/presentation/profile.dart';
import 'package:hot_spot/src/features/overview/presentation/startscreen.dart';

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
                      username: '',
                      profileImageUrl: '',
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
                      username: '',
                      profileImageUrl: '',
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
                    builder: (context) => StartScreen(
                      databaseRepository: databaseRepository,
                      authRepository: authRepository,
                      username: '',
                      profileImageUrl: '',
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
