import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';
import 'package:hot_spot/src/features/overview/presentation/startscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:hot_spot/src/data/fang_data.dart';

class Profile extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  const Profile({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedState;
  final List<String> _states = [
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

  String username = "Daniel";
  String profileImageUrl = 'assets/images/hintergründe/hslogo 5.png';

  bool _isEditing = false;
  bool _isLiked = false;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      String uid = widget.authRepository.getCurrentUserId();
      Map<String, dynamic>? userData =
          await widget.databaseRepository.getUserProfile(uid);
      if (userData != null) {
        setState(() {
          username = userData['username'] ?? "Daniel";
          _usernameController.text = username;
          _locationController.text = userData['location'] ?? "";
          _selectedState = userData['state'];
          profileImageUrl = userData['profileImageUrl'] ??
              'assets/images/hintergründe/hslogo 5.png';
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this._image = imageTemporary);
    } catch (e) {
      print('Image picker error: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        String uid = widget.authRepository.getCurrentUserId();
        String? imageUrl;
        if (_image != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child('$uid.jpg');
          await ref.putFile(_image!);
          imageUrl = await ref.getDownloadURL();
        }

        Map<String, dynamic> userData = {
          'username': _usernameController.text,
          'location': _locationController.text,
          'state': _selectedState,
          'profileImageUrl': imageUrl ?? profileImageUrl,
        };

        await widget.databaseRepository.saveUserProfile(uid, userData);

        setState(() {
          username = _usernameController.text;
          profileImageUrl = imageUrl ?? profileImageUrl;
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil erfolgreich gespeichert')),
        );
      } catch (e) {
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fehler beim Speichern des Profils')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                          _isEditing ? _buildEditForm() : _buildProfileView(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
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
            _buildDrawerItem(
                Icons.home, 'Home', () => _navigateToHome(context)),
            _buildDrawerItem(
                Icons.add, 'Fang melden', () => _navigateToAddFang(context)),
            _buildDrawerItem(
                Icons.person_2_rounded, 'Profil', () => Navigator.pop(context)),
            _buildDrawerItem(
                Icons.list_outlined, 'Hitliste', () => Navigator.pop(context)),
            _buildDrawerItem(
                Icons.settings, 'Settings', () => Navigator.pop(context)),
            _buildDrawerItem(Icons.info, 'About', () => Navigator.pop(context)),
            _buildDrawerItem(
                Icons.logout, 'Logout', () => _navigateToStartScreen(context)),
          ],
        ),
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 43, 43, 43)),
      title:
          Text(title, style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
      onTap: onTap,
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.push(
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
  }

  void _navigateToAddFang(BuildContext context) {
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
  }

  void _navigateToStartScreen(BuildContext context) {
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
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : AssetImage(profileImageUrl) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera),
                                    title: const Text('Kamera'),
                                    onTap: () {
                                      pickImage(ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.image),
                                    title: const Text('Galerie'),
                                    onTap: () {
                                      pickImage(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Profil",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 40.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte gib einen Username ein';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Wohnort',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte gib einen Wohnort ein';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Bundesland',
              border: OutlineInputBorder(),
            ),
            value: _selectedState,
            items: _states.map((String state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedState = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte wähle ein Bundesland aus';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfile,
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      children: [
        Card(
          color: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : (profileImageUrl.startsWith('http')
                                ? NetworkImage(profileImageUrl)
                                : AssetImage(profileImageUrl)) as ImageProvider,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 40.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                    'Wohnort: ${_locationController.text}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Bundesland: $_selectedState',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Bearbeiten'),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Color.fromARGB(255, 109, 130, 110).withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Meine Fänge',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 42, 40, 40),
          ),
        ),
        const SizedBox(height: 10),
        _buildFaengeList(),
      ],
    );
  }

  Widget _buildFaengeList() {
    return FutureBuilder<List<FangData>>(
      future: widget.databaseRepository
          .getUserFaenge(widget.authRepository.getCurrentUserId()),
      builder: (context, AsyncSnapshot<List<FangData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Fehler beim Laden der Fänge: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Keine Fänge gefunden',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        int totalFishes = snapshot.data!.length;

        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FangData fang = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: fang.bildUrl != null && fang.bildUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                fang.bildUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error,
                                      color: Colors.red);
                                },
                              ),
                            )
                          : const Icon(Icons.image_not_supported,
                              color: Colors.white),
                      title: Text(
                        fang.fischart,
                        style: TextStyle(
                            color: Color.fromARGB(255, 12, 56, 15),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gefangen am: ${DateFormat('dd.MM.yyyy').format(fang.datum)}',
                            style: TextStyle(
                                color: const Color.fromARGB(179, 40, 39, 39)),
                          ),
                          Text(
                            'Größe: ${fang.groesse.toStringAsFixed(2)} cm',
                            style: TextStyle(
                                color: const Color.fromARGB(179, 40, 39, 39)),
                          ),
                          Text(
                            'Gewicht: ${fang.gewicht.toStringAsFixed(2)} g',
                            style: TextStyle(
                                color: const Color.fromARGB(179, 40, 39, 39)),
                          ),
                          Text(
                            'Gewässer: ${fang.gewaesser}',
                            style: TextStyle(
                                color: const Color.fromARGB(1179, 40, 39, 39)),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Hier können Sie eine Detailansicht für den Fang öffnen
                      },
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(
                color: const Color.fromARGB(255, 19, 18, 18).withOpacity(0.3),
                thickness: 1,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Zahlen & Fakten',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 105, 99, 99),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Gesamtanzahl gefangener Fische',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phishing_rounded,
                            color: Colors.white, size: 40),
                        const SizedBox(width: 10),
                        Text(
                          '$totalFishes',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                  color: _isLiked ? Colors.red : Colors.white,
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                      _isFollowing ? Icons.person_remove : Icons.person_add),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      _isFollowing = !_isFollowing;
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
