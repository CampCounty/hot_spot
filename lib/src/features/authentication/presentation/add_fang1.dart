import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:intl/intl.dart';

class AddFang1 extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const AddFang1({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
  }) : super(key: key);

  @override
  State<AddFang1> createState() => _AddFang1State();
}

class _AddFang1State extends State<AddFang1> {
  final TextEditingController _datumController = TextEditingController();
  final TextEditingController _uhrzeitController = TextEditingController();
  final TextEditingController _ortController = TextEditingController();
  String? _selectedBundesland;
  final TextEditingController _gewaesserController = TextEditingController();

  final List<String> _bundeslaender = [
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _datumController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Datumauswahl abgebrochen'),
        ),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _uhrzeitController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Form(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Image.asset(
                          "assets/images/hintergründe/hslogo 5.png",
                          width: 200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Details eintragen",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 40.0,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _datumController,
                      decoration: InputDecoration(
                        labelText: 'Datum',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        await _selectDate(context);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _uhrzeitController,
                      decoration: InputDecoration(
                        labelText: 'Uhrzeit',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        await _selectTime(context);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ortController,
                      decoration: InputDecoration(
                        labelText: 'Ort',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedBundesland,
                      decoration: InputDecoration(
                        labelText: 'Bundesland',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _bundeslaender.map((String bundesland) {
                        return DropdownMenuItem<String>(
                          value: bundesland,
                          child: Text(bundesland),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBundesland = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _gewaesserController,
                      decoration: InputDecoration(
                        labelText: 'Gewässername',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
