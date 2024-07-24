import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/overview/domain/menue.dart';

class Hitliste extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  const Hitliste(
      {super.key,
      required this.databaseRepository,
      required this.authRepository});

  @override
  State<Hitliste> createState() => _HitlisteState();
}

class _HitlisteState extends State<Hitliste> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedFish;
  List<String> fishTypes = [];
  List<Map<String, String>> tableData = [
    {"Username": "Daniel", "Größe": "50cm", "Gewässer": "See"},
    {"Username": "Anna", "Größe": "45cm", "Gewässer": "Fluss"},
    {"Username": "Max", "Größe": "55cm", "Gewässer": "Teich"},
    {"Username": "Paul", "Größe": "40cm", "Gewässer": "Fluss"},
    // Weitere Einträge hier
  ];

  @override
  void initState() {
    super.initState();
    _loadFishTypes();
  }

  Future<void> _loadFishTypes() async {
    List<String> types = await widget.databaseRepository.getFischArten();
    setState(() {
      fishTypes = types;
      if (fishTypes.isNotEmpty) {
        selectedFish = fishTypes.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String username =
        "Daniel"; // Ersetzen Sie dies durch den tatsächlichen Benutzernamen
    String profileImageUrl =
        'assets/images/hintergründe/hslogo 5.png'; // Ersetzen Sie dies durch die tatsächliche URL des Profilbildes

    // Sortiere tableData basierend auf der Größe (Größte zuerst)
    List<Map<String, String>> sortedTableData = List.from(tableData);
    sortedTableData.sort((a, b) {
      final sizeA = _parseSize(a['Größe'] ?? '0cm');
      final sizeB = _parseSize(b['Größe'] ?? '0cm');
      return sizeB.compareTo(sizeA); // Größere Größe zuerst
    });

    return Scaffold(
      key: _scaffoldKey,
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
                image: AssetImage(
                  'assets/images/hintergründe/Blancscreen.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        'assets/images/hintergründe/hslogo 5.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Hitliste",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
                    textAlign: TextAlign.center, // Zentriert den Text
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons
                          .arrow_drop_down), // Icon links neben der Dropdown-Liste
                      const SizedBox(width: 10),
                      Container(
                        width: 200, // Angepasste Breite der Dropdown-Liste
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Farbe der Umrandung
                            width: 2.0, // Breite der Umrandung
                          ),
                          borderRadius:
                              BorderRadius.circular(5.0), // Abgerundete Ecken
                        ),
                        child: DropdownButton<String>(
                          value: selectedFish,
                          hint: const Text('Wähle eine Fischart'),
                          isExpanded: true,
                          items: fishTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(child: Text(value)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedFish = newValue;
                            });
                          },
                          underline:
                              Container(), // Um die Standard-Unterlinie zu entfernen
                          dropdownColor: Colors
                              .white, // Hintergrundfarbe des Dropdown-Menüs
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons
                          .arrow_drop_down), // Icon rechts neben der Dropdown-Liste
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Wähle eine Fischart',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center, // Zentriert den Text
                  ),
                  const SizedBox(height: 20),
                  // Tabelle hinzufügen
                  Container(
                    width: double
                        .infinity, // Setzt die Breite auf 100% des Containers
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          8.0), // Abgerundete Ecken für den Container
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Schattenfarbe
                          spreadRadius: 2, // Verbreiterung des Schattens
                          blurRadius: 5, // Unschärfe des Schattens
                          offset:
                              const Offset(0, 4), // Verschiebung des Schattens
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Ermöglicht horizontales Scrollen
                      child: DataTable(
                        columnSpacing: 16.0, // Abstand zwischen den Spalten
                        dataRowHeight: 50.0, // Höhe der Zeilen
                        headingRowHeight: 56.0, // Höhe der Überschrift
                        columns: [
                          DataColumn(
                            label: Container(
                              width: 50, // Breite der Spalte
                              child: Center(
                                child: Text(
                                  'Platz',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Fett
                                    color: Color.fromARGB(255, 243, 241,
                                        241), // Farbe der Überschrift
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 150, // Breite der Spalte
                              child: Center(
                                child: Text(
                                  'Username',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Fett
                                    color: const Color.fromARGB(255, 243, 241,
                                        241), // Farbe der Überschrift
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 50, // Breite der Spalte
                              child: Center(
                                child: Text(
                                  'Größe',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Fett
                                    color: const Color.fromARGB(255, 243, 241,
                                        241), // Farbe der Überschrift
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 150, // Breite der Spalte
                              child: Center(
                                child: Text(
                                  'Gewässer',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Fett
                                    color: const Color.fromARGB(255, 243, 241,
                                        241), // Farbe der Überschrift
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          sortedTableData.length,
                          (index) {
                            final data = sortedTableData[index];
                            final isTopThree = index <
                                3; // Überprüfen, ob der Platz einer der ersten drei ist
                            return DataRow(
                              cells: [
                                DataCell(
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                        fontWeight: isTopThree
                                            ? FontWeight.bold
                                            : FontWeight
                                                .normal, // Fett für die ersten drei Plätze
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      data['Username'] ?? '',
                                      style: TextStyle(
                                        fontWeight: isTopThree
                                            ? FontWeight.bold
                                            : FontWeight
                                                .normal, // Fett für die ersten drei Plätze
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      data['Größe'] ?? '',
                                      style: TextStyle(
                                        fontWeight: isTopThree
                                            ? FontWeight.bold
                                            : FontWeight
                                                .normal, // Fett für die ersten drei Plätze
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      data['Gewässer'] ?? '',
                                      style: TextStyle(
                                        fontWeight: isTopThree
                                            ? FontWeight.bold
                                            : FontWeight
                                                .normal, // Fett für die ersten drei Plätze
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
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
        ],
      ),
    );
  }

  int _parseSize(String size) {
    final match = RegExp(r'(\d+)').firstMatch(size);
    return match != null ? int.parse(match.group(0)!) : 0;
  }
}
