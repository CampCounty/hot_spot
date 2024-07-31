import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/overview/domain/menue.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class Statistiken extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const Statistiken({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
    required String username,
    required String profileImageUrl,
  }) : super(key: key);

  @override
  _StatistikenState createState() => _StatistikenState();
}

class _StatistikenState extends State<Statistiken> {
  String username = "";
  String profileImageUrl = 'assets/images/hintergründe/hslogo 5.png';
  int totalCatches = 0;
  Map<String, int> fishCounts = {};
  Map<int, int> monthlyFishCounts = {};

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadStatistics();
  }

  Future<void> _loadProfileData() async {
    try {
      String uid = widget.authRepository.getCurrentUserId();
      Map<String, dynamic>? userData =
          await widget.databaseRepository.getUserProfile(uid);
      if (userData != null) {
        setState(() {
          username = userData['username'] ?? "";
          profileImageUrl = userData['profileImageUrl'] ??
              'assets/images/hintergründe/hslogo 5.png';
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  Future<void> _loadStatistics() async {
    try {
      String uid = widget.authRepository.getCurrentUserId();
      List<FangData> faenge =
          await widget.databaseRepository.getUserFaenge(uid);
      Map<String, int> tempFishCounts = {};
      Map<int, int> tempMonthlyFishCounts = {};
      for (var fang in faenge) {
        tempFishCounts[fang.fischart] =
            (tempFishCounts[fang.fischart] ?? 0) + 1;
        int month = fang.datum.month;
        tempMonthlyFishCounts[month] = (tempMonthlyFishCounts[month] ?? 0) + 1;
      }
      setState(() {
        totalCatches = faenge.length;
        fishCounts = Map.fromEntries(tempFishCounts.entries.toList()
          ..sort((e1, e2) => e2.value.compareTo(e1.value)));
        monthlyFishCounts = tempMonthlyFishCounts;
      });
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  List<PieChartSectionData> _getSections() {
    List<PieChartSectionData> sections = [];
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.purple,
    ];

    fishCounts.entries.take(5).toList().asMap().forEach((index, entry) {
      sections.add(PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value.toDouble(),
        title: '',
        radius: 100,
      ));
    });

    return sections;
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(12, (index) {
      int month = index + 1;
      return BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(
            toY: monthlyFishCounts[month]?.toDouble() ?? 0,
            color: Colors.blue,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        username: username,
        profileImageUrl: profileImageUrl,
        databaseRepository: widget.databaseRepository,
        authRepository: widget.authRepository,
      ),
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                        child: Center(
                          child: Image.asset(
                            'assets/images/hintergründe/hslogo 5.png',
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Statistiken',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 32,
                            ),
                            child: Card(
                              color: Colors.white.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Gesamtanzahl der Fänge',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$totalCatches',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: Colors.black, thickness: 1),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 32,
                            ),
                            child: Card(
                              color: Colors.white.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Top 5 Fischarten',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    AspectRatio(
                                      aspectRatio: 1.3,
                                      child: PieChart(
                                        PieChartData(
                                          sections: _getSections(),
                                          sectionsSpace: 0,
                                          centerSpaceRadius: 40,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      children: fishCounts.entries
                                          .take(5)
                                          .map((entry) {
                                        int index = fishCounts.keys
                                            .toList()
                                            .indexOf(entry.key);
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 15,
                                                height: 15,
                                                color: [
                                                  Colors.blue,
                                                  Colors.green,
                                                  Colors.red,
                                                  Colors.yellow,
                                                  Colors.purple
                                                ][index % 5],
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  '${entry.key}: ${entry.value}',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: Colors.black, thickness: 1),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 32,
                            ),
                            child: Card(
                              color: Colors.white.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Fänge pro Monat',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    AspectRatio(
                                      aspectRatio: 1.7,
                                      child: BarChart(
                                        BarChartData(
                                          alignment:
                                              BarChartAlignment.spaceAround,
                                          maxY: monthlyFishCounts.values.isEmpty
                                              ? 0
                                              : monthlyFishCounts.values
                                                  .reduce(
                                                      (a, b) => a > b ? a : b)
                                                  .toDouble(),
                                          barTouchData:
                                              BarTouchData(enabled: false),
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (value, meta) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Text(
                                                      DateFormat('MMM').format(
                                                          DateTime(2023,
                                                              value.toInt())),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            leftTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            topTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            rightTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                          ),
                                          gridData:
                                              const FlGridData(show: false),
                                          borderData: FlBorderData(show: false),
                                          barGroups: _getBarGroups(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: Colors.black, thickness: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
