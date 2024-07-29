import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:hot_spot/src/features/authentication/presentation/fang_details_screen.dart';
import 'package:hot_spot/src/features/authentication/presentation/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:intl/intl.dart';
import 'package:hot_spot/src/features/overview/presentation/startscreen.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  final String username;
  final String profileImageUrl;

  const HomeScreen({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
    required this.username,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _username;
  late String _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _profileImageUrl = widget.profileImageUrl;
    refreshProfile();
  }

  Future<void> refreshProfile() async {
    String userId = widget.authRepository.getCurrentUserId();
    Map<String, dynamic>? userProfile =
        await widget.databaseRepository.getUserProfile(userId);
    if (userProfile != null && mounted) {
      setState(() {
        _username = userProfile['username'] ?? '';
        _profileImageUrl = userProfile['profileImageUrl'] ?? '';
      });
    }
  }

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
    try {
      await widget.authRepository.logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => StartScreen(
            databaseRepository: widget.databaseRepository,
            authRepository: widget.authRepository,
            username: '',
            profileImageUrl: '',
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Fehler beim Ausloggen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Fehler beim Ausloggen. Bitte versuchen Sie es erneut.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          backgroundImage: _profileImageUrl.isNotEmpty
                              ? NetworkImage(_profileImageUrl)
                              : AssetImage(
                                      'assets/images/hintergründe/hslogo 5.png')
                                  as ImageProvider,
                          onBackgroundImageError: (_, __) {
                            setState(() {
                              _profileImageUrl =
                                  'assets/images/hintergründe/hslogo 5.png';
                            });
                          },
                          radius: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _username,
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
                        username: _username,
                        profileImageUrl: _profileImageUrl,
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
                  ).then((_) => refreshProfile());
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
                  height: 120, // Reduced by 20%
                  width: 120, // Reduced by 20%
                ),
              ),
            ),
            Positioned(
              top: 150, // Adjusted to accommodate smaller logo
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
                          margin: const EdgeInsets.all(12), // Reduced margin
                          elevation: 4, // Slightly reduced elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Slightly reduced border radius
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
                                          top: Radius.circular(12)),
                                      child: Image.network(
                                        fang.bildUrl!,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.72, // Reduced by 20%
                                        height:
                                            (MediaQuery.of(context).size.width *
                                                    0.72) *
                                                (2 / 3), // Reduced by 20%
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.72,
                                            height: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.72) *
                                                (2 / 3),
                                            color: Colors.grey[300],
                                            child: Icon(Icons.error,
                                                color: Colors.red,
                                                size: 40), // Reduced icon size
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.72,
                                      height:
                                          (MediaQuery.of(context).size.width *
                                                  0.72) *
                                              (2 / 3),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12)),
                                      ),
                                      child: Icon(Icons.image_not_supported,
                                          size: 40,
                                          color: Colors
                                              .grey[600]), // Reduced icon size
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(
                                      12), // Reduced padding
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fang.fischart,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight
                                                .bold), // Reduced font size
                                      ),
                                      SizedBox(height: 6), // Reduced spacing
                                      Text(
                                          'Größe: ${fang.groesse.toStringAsFixed(2)} cm',
                                          style: TextStyle(
                                              fontSize:
                                                  12)), // Reduced font size
                                      Text(
                                          'Gewicht: ${fang.gewicht.toStringAsFixed(2)} g',
                                          style: TextStyle(
                                              fontSize:
                                                  12)), // Reduced font size
                                      Text(
                                          'Gefangen am: ${DateFormat('dd.MM.yyyy').format(fang.datum)}',
                                          style: TextStyle(
                                              fontSize:
                                                  12)), // Reduced font size
                                      Text('Gewässer: ${fang.gewaesser}',
                                          style: TextStyle(
                                              fontSize:
                                                  12)), // Reduced font size
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6), // Reduced padding
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
                                          SizedBox(
                                              width: 12), // Reduced spacing
                                          FollowButton(
                                            userId: fang.userID,
                                            initialIsFollowing: false,
                                          ),
                                        ],
                                      ),
                                      Text(fang.username,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize:
                                                  12)), // Reduced font size
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

// LikeButton and FollowButton classes remain unchanged

// LikeButton and FollowButton classes remain unchanged
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
        // TODO: Implement like functionality
        // e.g. Update Firestore
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
        // TODO: Implement follow functionality
        // e.g. Update Firestore
      },
    );
  }
}
