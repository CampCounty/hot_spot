import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang.dart';
import 'package:hot_spot/src/features/authentication/presentation/profileScreen.dart';
import 'package:hot_spot/src/features/overview/presentation/startscreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hot_spot/src/data/fang_data.dart';

class StatistikScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const StatistikScreen({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
  }) : super(key: key);

  @override
  _StatistikScreenState createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _username = '';
  late String _profileImageUrl = '';
  late Future<List<FangData>> _fangDataFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fangDataFuture = _loadFangData();
  }

  Future<void> _loadUserData() async {
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

  Future<List<FangData>> _loadFangData() async {
    String userId = widget.authRepository.getCurrentUserId();
    return await widget.databaseRepository.getUserFaenge(userId);
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
        const SnackBar(
            content:
                Text('Fehler beim Ausloggen. Bitte versuchen Sie es erneut.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
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
                icon: const Icon(Icons.menu, color: Colors.white),
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
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Positioned(
              top: 140,
              left: 20,
              right: 20,
              bottom: 20,
              child: _buildStatistikContent(),
            ),
          ],
        ),
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
                        backgroundImage: _profileImageUrl.isNotEmpty
                            ? NetworkImage(_profileImageUrl)
                            : const AssetImage(
                                    'assets/images/hintergründe/hslogo 5.png')
                                as ImageProvider,
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
            _buildDrawerItem(Icons.home, 'Home', () => Navigator.pop(context)),
            _buildDrawerItem(Icons.add, 'Fang melden', () {
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
            }),
            _buildDrawerItem(Icons.person, 'Profil', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileWidget(
                    databaseRepository: widget.databaseRepository,
                    authRepository: widget.authRepository,
                    userId: widget.authRepository.getCurrentUserId(),
                  ),
                ),
              );
            }),
            _buildDrawerItem(
                Icons.bar_chart, 'Statistik', () => Navigator.pop(context)),
            _buildDrawerItem(
                Icons.settings, 'Einstellungen', () => Navigator.pop(context)),
            _buildDrawerItem(Icons.info, 'Über', () => Navigator.pop(context)),
            _buildDrawerItem(Icons.logout, 'Logout', _logout),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildStatistikContent() {
    return FutureBuilder<List<FangData>>(
      future: _fangDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Fehler: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Keine Fangdaten verfügbar'));
        } else {
          List<FangData> faenge = snapshot.data!;
          Map<String, int> fischArtenCount = {};
          Map<String, int> koederCount = {};
          for (var fang in faenge) {
            fischArtenCount[fang.fischart] =
                (fischArtenCount[fang.fischart] ?? 0) + 1;
            if (fang.koeder != null) {
              koederCount[fang.koeder!] = (koederCount[fang.koeder!] ?? 0) + 1;
            }
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildCard(
                    'Gesamtanzahl gefangener Fische',
                    value: '${faenge.length}',
                  ),
                  const SizedBox(height: 20),
                  if (fischArtenCount.isNotEmpty) ...[
                    _buildCard(
                      'Verteilung der Fischarten',
                      content: Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child: PieChart(
                              PieChartData(
                                sections:
                                    _createPieChartSections(fischArtenCount),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildLegend(fischArtenCount),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (koederCount.isNotEmpty) ...[
                    _buildCard(
                      'Am häufigsten verwendete Köder',
                      content: Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child: PieChart(
                              PieChartData(
                                sections: _createPieChartSections(koederCount),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildLegend(koederCount),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildCard(String title, {String? value, Widget? content}) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (value != null) ...[
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
              if (content != null) ...[
                const SizedBox(height: 10),
                content,
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections(
      Map<String, int> dataCount) {
    List<Color> colors = [
      Color.fromARGB(255, 229, 225, 224),
      Colors.blue,
      Color.fromARGB(255, 172, 95, 40),
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.brown,
    ];

    int total = dataCount.values.reduce((a, b) => a + b);

    return dataCount.entries.map((entry) {
      int index = dataCount.keys.toList().indexOf(entry.key);
      double percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 4, 4, 4),
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, int> dataCount) {
    List<Color> colors = [
      Color.fromARGB(255, 229, 225, 224),
      Colors.blue,
      Color.fromARGB(255, 172, 95, 40),
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.brown,
    ];

    return Column(
      children: dataCount.entries.map((entry) {
        int index = dataCount.keys.toList().indexOf(entry.key);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: colors[index % colors.length],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${entry.key}: ${entry.value}'),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
