import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:hot_spot/src/features/authentication/presentation/add_fang2.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFang extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  final String username;
  final String profileImageUrl;

  const AddFang({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
    required this.username,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  State<AddFang> createState() => _AddFangState();
}

class _AddFangState extends State<AddFang> {
  String? selectedFischart;
  final TextEditingController _groesseController = TextEditingController();
  final TextEditingController _gewichtController = TextEditingController();
  final TextEditingController _datumController = TextEditingController();
  final TextEditingController _uhrzeitController = TextEditingController();
  final TextEditingController _ortController = TextEditingController();
  final TextEditingController _gewaesserController = TextEditingController();
  String? _selectedBundesland;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _getBundeslaender() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('metadata').doc('bundeslaender').get();
      return List<String>.from(doc['liste'] as List);
    } catch (e) {
      print('Error getting bundeslaender: $e');
      return [];
    }
  }

  Future<List<String>> _getFischArten() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('metadata').doc('fischarten').get();
      return List<String>.from(doc['arten'] as List);
    } catch (e) {
      print('Error getting fischarten: $e');
      return [];
    }
  }

  static const TextStyle blackLabelStyle = TextStyle(color: Colors.black);

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
        const SnackBar(content: Text('Datumauswahl abgebrochen')),
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
        _uhrzeitController.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Standortberechtigung verweigert')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Standortberechtigung dauerhaft verweigert')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _ortController.text = '${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Abrufen des Standorts: $e')),
      );
    }
  }

  void _navigateToNextScreen() async {
    if (selectedFischart == null ||
        _groesseController.text.isEmpty ||
        _gewichtController.text.isEmpty ||
        _datumController.text.isEmpty ||
        _uhrzeitController.text.isEmpty ||
        _gewaesserController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bitte füllen Sie alle erforderlichen Felder aus.')),
      );
      return;
    }

    String tempId = FirebaseFirestore.instance.collection('faenge').doc().id;

    DateTime fangDatum;
    try {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
      String dateTimeString =
          '${_datumController.text} ${_uhrzeitController.text}';
      fangDatum = dateFormat.parse(dateTimeString);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ungültiges Datum oder Uhrzeitformat: $e')),
      );
      return;
    }

    String currentUserID = widget.authRepository.getCurrentUserId();
    String currentUsername = await widget.authRepository.getCurrentUsername();

    FangData fangData = FangData(
      id: tempId,
      userID: currentUserID,
      fischart: selectedFischart!,
      groesse: double.tryParse(_groesseController.text) ?? 0.0,
      gewicht: double.tryParse(_gewichtController.text) ?? 0.0,
      gewaesser: _gewaesserController.text,
      datum: fangDatum,
      bildUrl: null,
      angelmethode: null,
      naturkoeder: null,
      username: currentUsername,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddFang2(
          databaseRepository: widget.databaseRepository,
          authRepository: widget.authRepository,
          username: currentUsername,
          profileImageUrl: widget.profileImageUrl,
          fangData: fangData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.all(8),
              child: Form(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Image.asset(
                          "assets/images/hintergründe/hslogo 5.png",
                          width: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Fang eintragen",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<String>>(
                      future: _getFischArten(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          List<String> fischarten = snapshot.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButtonFormField<String>(
                                value: selectedFischart,
                                decoration: InputDecoration(
                                  labelText: 'Fischart',
                                  labelStyle: blackLabelStyle,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: fischarten.map((String fischArt) {
                                  return DropdownMenuItem<String>(
                                    value: fischArt,
                                    child:
                                        Text(fischArt, style: blackLabelStyle),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedFischart = newValue;
                                  });
                                },
                                style: blackLabelStyle,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _groesseController,
                                      decoration: InputDecoration(
                                        labelText: 'Größe (cm)',
                                        labelStyle: blackLabelStyle,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: blackLabelStyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _gewichtController,
                                      decoration: InputDecoration(
                                        labelText: 'Gewicht (g)',
                                        labelStyle: blackLabelStyle,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: blackLabelStyle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _datumController,
                                      decoration: InputDecoration(
                                        labelText: 'Datum',
                                        labelStyle: blackLabelStyle,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        await _selectDate(context);
                                      },
                                      style: blackLabelStyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _uhrzeitController,
                                      decoration: InputDecoration(
                                        labelText: 'Uhrzeit',
                                        labelStyle: blackLabelStyle,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        await _selectTime(context);
                                      },
                                      style: blackLabelStyle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _ortController,
                                decoration: InputDecoration(
                                  labelText: 'Ort',
                                  labelStyle: blackLabelStyle,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.gps_fixed),
                                    onPressed: _getCurrentLocation,
                                  ),
                                ),
                                style: blackLabelStyle,
                              ),
                              const SizedBox(height: 16),
                              FutureBuilder<List<String>>(
                                future: _getBundeslaender(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButtonFormField<String>(
                                      value: _selectedBundesland,
                                      decoration: InputDecoration(
                                        labelText: 'Bundesland',
                                        labelStyle: blackLabelStyle,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      items: snapshot.data!
                                          .map((String bundesland) {
                                        return DropdownMenuItem<String>(
                                          value: bundesland,
                                          child: Text(bundesland,
                                              style: blackLabelStyle),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedBundesland = newValue;
                                        });
                                      },
                                      style: blackLabelStyle,
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _gewaesserController,
                                decoration: InputDecoration(
                                  labelText: 'Gewässername',
                                  labelStyle: blackLabelStyle,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                style: blackLabelStyle,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: _navigateToNextScreen,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 79, 106, 78),
                                    foregroundColor: const Color.fromARGB(
                                        255, 223, 242, 224),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'weiter',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.arrow_forward),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.connectionState !=
                            ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Icon(Icons.error);
                        }
                      },
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

  @override
  void dispose() {
    _groesseController.dispose();
    _gewichtController.dispose();
    _datumController.dispose();
    _uhrzeitController.dispose();
    _ortController.dispose();
    _gewaesserController.dispose();
    super.dispose();
  }
}
