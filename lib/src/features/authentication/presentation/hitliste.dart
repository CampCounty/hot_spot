import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/overview/domain/menue.dart';
import 'package:hot_spot/src/data/fang_data.dart';

class Hitliste extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  const Hitliste(
      {Key? key,
      required this.databaseRepository,
      required this.authRepository,
      required String username,
      required String profileImageUrl})
      : super(key: key);

  @override
  State<Hitliste> createState() => _HitlisteState();
}

class _HitlisteState extends State<Hitliste> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedFish;
  List<String> fishTypes = [];
  List<FangData> fangList = [];

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
        _loadFaenge(selectedFish!);
      }
    });
  }

  Future<void> _loadFaenge(String fischart) async {
    List<FangData> faenge =
        await widget.databaseRepository.getFaengeByFischart(fischart);
    setState(() {
      fangList = faenge;
      fangList.sort((a, b) =>
          b.groesse.compareTo(a.groesse)); // Sortiere nach Größe absteigend
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        username:
            "Username", // Ersetzen Sie dies durch den tatsächlichen Benutzernamen
        profileImageUrl: 'assets/images/hintergründe/hslogo 5.png',
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
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_drop_down),
                      const SizedBox(width: 10),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0),
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
                              _loadFaenge(selectedFish!);
                            });
                          },
                          underline: Container(),
                          dropdownColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Wähle eine Fischart',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (fangList.isEmpty)
                    const Text("Noch keine Daten",
                        style: TextStyle(fontSize: 18))
                  else
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 16.0,
                          dataRowHeight: 50.0,
                          headingRowHeight: 56.0,
                          columns: [
                            DataColumn(label: _buildColumnHeader('Platz', 50)),
                            DataColumn(
                                label: _buildColumnHeader('Username', 150)),
                            DataColumn(label: _buildColumnHeader('Größe', 50)),
                            DataColumn(
                                label: _buildColumnHeader('Gewässer', 150)),
                          ],
                          rows: List<DataRow>.generate(
                            fangList.length,
                            (index) => _buildDataRow(index, fangList[index]),
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

  Widget _buildColumnHeader(String text, double width) {
    return Container(
      width: width,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 243, 241, 241),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(int index, FangData fang) {
    final isTopThree = index < 3;
    final textStyle = TextStyle(
      fontWeight: isTopThree ? FontWeight.bold : FontWeight.normal,
    );

    return DataRow(
      cells: [
        DataCell(Center(child: Text((index + 1).toString(), style: textStyle))),
        DataCell(Center(child: Text(fang.username, style: textStyle))),
        DataCell(Center(
            child: Text('${fang.groesse.toStringAsFixed(2)} cm',
                style: textStyle))),
        DataCell(Center(child: Text(fang.gewaesser, style: textStyle))),
      ],
    );
  }
}
