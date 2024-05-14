import 'package:fan_floating_menu/fan_floating_menu.dart';
import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class Profile extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  const Profile({super.key, required this.databaseRepository});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(48.0),
        child: FanFloatingMenu(
          expandItemsCurve: Curves.elasticInOut,
          toggleButtonColor: Color.fromARGB(255, 41, 64, 42),
          menuItems: [
            FanMenuItem(
                onTap: () {},
                icon: Icons.set_meal_rounded,
                menuItemIconColor: Color.fromARGB(248, 41, 56, 41),
                title: 'Fang hinzufügen'),
            FanMenuItem(
                onTap: () {},
                icon: Icons.waves_outlined,
                menuItemIconColor: Color.fromARGB(248, 41, 56, 41),
                title: 'Gewässer'),
            FanMenuItem(
                onTap: () {},
                icon: Icons.emoji_events_rounded,
                menuItemIconColor: Color.fromARGB(248, 41, 56, 41),
                title: 'Hitliste'),
            FanMenuItem(
                onTap: () {},
                icon: Icons.person_2_rounded,
                menuItemIconColor: Color.fromARGB(248, 41, 56, 41),
                title: 'Profil'),
          ],
        ),
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
              padding: (EdgeInsets.all(16)),
              child: Form(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Image.network("https://imgur.com/ClS7mSV.png"),
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      "Profil",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 40.0),
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
