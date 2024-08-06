import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:intl/intl.dart';
import 'package:hot_spot/src/features/authentication/presentation/fang_details_screen.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:hot_spot/src/features/authentication/presentation/hitliste.dart';
import 'package:hot_spot/src/features/overview/presentation/startscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileWidget extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  final String userId;

  const ProfileWidget({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
    required this.userId,
  }) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late Future<Map<String, dynamic>?> _userProfileFuture;
  late Future<List<FangData>> _userFaengeFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _updateAllPBStatus();
  }

  void _loadUserData() {
    String userId = widget.userId.isNotEmpty
        ? widget.userId
        : widget.authRepository.getCurrentUserId();
    if (userId.isNotEmpty) {
      _userProfileFuture = widget.databaseRepository.getUserProfile(userId);
      _userFaengeFuture = widget.databaseRepository.getUserFaenge(userId);
    } else {
      _userProfileFuture = Future.value(null);
      _userFaengeFuture = Future.value([]);
    }
  }

  Future<void> _updateAllPBStatus() async {
    await widget.databaseRepository.updateAllFaengePBStatus();
    setState(() {
      _loadUserData(); // Daten neu laden nach der Aktualisierung
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/hintergründe/Blancscreen.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hintergründe/Blancscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<Map<String, dynamic>?>(
                  future: _userProfileFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Fehler beim Laden des Profils'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('Kein Profil gefunden'));
                    } else {
                      final userProfile = snapshot.data!;
                      return _buildProfileHeader(userProfile);
                    }
                  },
                ),
                SizedBox(height: 20),
                FutureBuilder<List<FangData>>(
                  future: _userFaengeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Fehler beim Laden der Fänge'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Keine Fänge gefunden'));
                    } else {
                      return _buildFaengeList(snapshot.data!);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 191, 226, 193),
            ),
            child: Text(
              'Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    databaseRepository: widget.databaseRepository,
                    authRepository: widget.authRepository,
                    username: '',
                    profileImageUrl: '',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Fang melden'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFang(
                    databaseRepository: widget.databaseRepository,
                    authRepository: widget.authRepository,
                    username: '',
                    profileImageUrl: '',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Hitliste'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Hitliste(
                    databaseRepository: widget.databaseRepository,
                    authRepository: widget.authRepository,
                    username: '',
                    profileImageUrl: '',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await widget.authRepository.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StartScreen(
                    databaseRepository: widget.databaseRepository,
                    authRepository: widget.authRepository,
                    username: '',
                    profileImageUrl: '',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> userProfile) {
    String currentUserId = widget.authRepository.getCurrentUserId();
    bool isCurrentUser = currentUserId == widget.userId;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(userProfile['profileImageUrl'] ?? ''),
              ),
              if (isCurrentUser)
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(136, 23, 50, 10),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => _changeProfilePicture(widget.userId),
                    color: Color.fromARGB(255, 176, 243, 188),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            userProfile['username'] ?? '',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (isCurrentUser) Text(userProfile['email'] ?? ''),
          SizedBox(height: 8),
          Text(userProfile['location'] ?? 'Nicht angegeben'),
          SizedBox(height: 16),
          if (isCurrentUser)
            ElevatedButton(
              child: Text('Profil bearbeiten'),
              onPressed: () => _editProfile(userProfile),
            ),
        ],
      ),
    );
  }

  Widget _buildFaengeList(List<FangData> faenge) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: faenge.length,
      itemBuilder: (context, index) {
        final fang = faenge[index];
        print(
            'Fang ${fang.fischart}: isPB = ${fang.isPB}'); // Debugging-Ausgabe
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hintergründe/Blancscreen.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: fang.bildUrl != null && fang.bildUrl!.isNotEmpty
                  ? Image.network(fang.bildUrl!,
                      width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.photo, size: 50),
              title: Row(
                children: [
                  Expanded(child: Text(fang.fischart)),
                  if (fang.isPB)
                    Text(
                      'PB',
                      style: TextStyle(
                        color: Color.fromARGB(255, 245, 184, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Größe: ${fang.groesse.toStringAsFixed(2)} cm'),
                  Text('Gewicht: ${fang.gewicht.toStringAsFixed(2)} g'),
                  Text('Datum: ${DateFormat('dd.MM.yyyy').format(fang.datum)}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FangDetailsScreen(
                      fang: fang,
                      databaseRepository: widget.databaseRepository,
                      authRepository: widget.authRepository,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _changeProfilePicture(String userId) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        String url = await uploadImageToStorage(File(pickedFile.path));

        await widget.databaseRepository.updateProfilePicture(userId, url);

        setState(() {
          _loadUserData();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profilbild erfolgreich aktualisiert')),
        );
      } catch (e) {
        print('Error updating profile picture: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Aktualisieren des Profilbildes')),
        );
      }
    }
  }

  void _editProfile(Map<String, dynamic> currentProfile) {
    String currentUserId = widget.authRepository.getCurrentUserId();
    if (currentUserId != widget.userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sie können nur Ihr eigenes Profil bearbeiten')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profil bearbeiten'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: currentProfile['username'],
                decoration: InputDecoration(labelText: 'Benutzername'),
                onChanged: (value) {
                  currentProfile['username'] = value;
                },
              ),
              TextFormField(
                initialValue: currentProfile['email'],
                decoration: InputDecoration(labelText: 'E-Mail'),
                onChanged: (value) {
                  currentProfile['email'] = value;
                },
              ),
              TextFormField(
                initialValue: currentProfile['location'],
                decoration: InputDecoration(labelText: 'Wohnort'),
                onChanged: (value) {
                  currentProfile['location'] = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Abbrechen'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('Speichern'),
            onPressed: () async {
              try {
                await widget.databaseRepository
                    .updateUserProfile(widget.userId, currentProfile);
                setState(() {
                  _loadUserData();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profil erfolgreich aktualisiert')),
                );
              } catch (e) {
                print('Error updating profile: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Fehler beim Aktualisieren des Profils')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<String> uploadImageToStorage(File image) async {
    // Implementieren Sie hier die Logik zum Hochladen des Bildes
    // und geben Sie die URL zurück
    throw UnimplementedError(
        'Methode zum Hochladen des Bildes noch nicht implementiert');
  }
}
