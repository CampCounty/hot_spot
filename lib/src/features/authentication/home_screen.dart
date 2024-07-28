import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:hot_spot/src/features/authentication/presentation/fang_details_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const HomeScreen({
    super.key,
    required this.databaseRepository,
    required this.authRepository,
    required String username,
    required String profileImageUrl,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<FangData>> _getLatestFaenge() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('faenge')
          .orderBy('datum', descending: true)
          .limit(5)
          .get();

      return querySnapshot.docs
          .map((doc) {
            try {
              return FangData.fromMap(
                  doc.data() as Map<String, dynamic>, doc.id);
            } catch (e) {
              print('Error parsing fang data: $e');
              return null;
            }
          })
          .whereType<FangData>()
          .toList();
    } catch (e) {
      print('Error fetching latest faenge: $e');
      return [];
    }
  }

  void _logout() async {
    await widget.authRepository.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    String username = "Daniel"; // Replace with actual username
    String profileImageUrl =
        'assets/images/hintergründe/hslogo 5.png'; // Replace with actual profile image URL

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add,
                    color: Color.fromARGB(255, 43, 43, 43)),
                title: const Text('Fang melden',
                    style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
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
                leading: const Icon(Icons.person_2_rounded,
                    color: Color.fromARGB(255, 43, 43, 43)),
                title: const Text('Profil',
                    style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        databaseRepository: widget.databaseRepository,
                        authRepository: widget.authRepository,
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
                },
              ),
              ListTile(
                leading: const Icon(Icons.info,
                    color: Color.fromARGB(255, 43, 43, 43)),
                title: const Text('About',
                    style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout,
                    color: Color.fromARGB(255, 43, 43, 43)),
                title: const Text('Logout',
                    style: TextStyle(color: Color.fromARGB(255, 43, 43, 43))),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/hintergründe/Blancscreen.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/hintergründe/hslogo 5.png',
                  height: 150,
                  width: 150,
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              bottom: 0,
              child: FutureBuilder<List<FangData>>(
                future: _getLatestFaenge(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Keine Fänge gefunden'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        FangData fang = snapshot.data![index];
                        return Card(
                          margin: const EdgeInsets.all(16),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white.withOpacity(0.9),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FangDetailsScreen(fang: fang),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (fang.bildUrl != null &&
                                    fang.bildUrl!.isNotEmpty)
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15)),
                                      child: Image.network(
                                        fang.bildUrl!,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height:
                                            (MediaQuery.of(context).size.width *
                                                    0.9) *
                                                (2 / 3),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9) *
                                                (2 / 3),
                                            color: Colors.grey[300],
                                            child: Icon(Icons.error,
                                                color: Colors.red, size: 50),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          (MediaQuery.of(context).size.width *
                                                  0.9) *
                                              (2 / 3),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15)),
                                      ),
                                      child: Icon(Icons.image_not_supported,
                                          size: 50, color: Colors.grey[600]),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fang.fischart,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                          'Größe: ${fang.groesse.toStringAsFixed(2)} cm'),
                                      Text(
                                          'Gewicht: ${fang.gewicht.toStringAsFixed(2)} g'),
                                      Text(
                                          'Gefangen am: ${DateFormat('dd.MM.yyyy').format(fang.datum)}'),
                                      Text('Gewässer: ${fang.gewaesser}'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          LikeButton(
                                            fangId: fang.id,
                                            initialIsLiked: false,
                                          ),
                                          SizedBox(width: 16),
                                          FollowButton(
                                            userId: fang.userID,
                                            initialIsFollowing: false,
                                          ),
                                        ],
                                      ),
                                      Text(fang.userID,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  final String fangId;
  final bool initialIsLiked;

  const LikeButton(
      {Key? key, required this.fangId, required this.initialIsLiked})
      : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.initialIsLiked;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : null,
      ),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        // Hier müssen Sie die Like-Funktion implementieren
        // z.B. Firestore aktualisieren
      },
    );
  }
}

class FollowButton extends StatefulWidget {
  final String userId;
  final bool initialIsFollowing;

  const FollowButton(
      {Key? key, required this.userId, required this.initialIsFollowing})
      : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.initialIsFollowing;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFollowing ? Icons.person : Icons.person_add,
        color: isFollowing ? Colors.blue : null,
      ),
      onPressed: () {
        setState(() {
          isFollowing = !isFollowing;
        });
        // Hier müssen Sie die Follow-Funktion implementieren
        // z.B. Firestore aktualisieren
      },
    );
  }
}
