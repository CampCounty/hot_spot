import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hot_spot/src/features/authentication/home_screen.dart';

class AddFang2 extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  final FangData fangData;

  const AddFang2({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
    required String username,
    required String profileImageUrl,
    required this.fangData,
  }) : super(key: key);

  @override
  State<AddFang2> createState() => _AddFang2State();
}

class _AddFang2State extends State<AddFang2> {
  static const TextStyle blackTextStyle = TextStyle(color: Colors.black);

  String? selectedAngelmethode;
  String? selectedKoeder;
  bool isNaturkoeder = true;
  bool isKunstkoeder = false;
  File? _image;
  final picker = ImagePicker();
  String? uploadedImageUrl;

  Future<List<String>> getAngelmethoden() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Angelmethoden').get();
      List<String> methoden = querySnapshot.docs.map((doc) => doc.id).toList();
      return methoden;
    } catch (e) {
      print("Fehler beim Laden der Angelmethoden: $e");
      return [];
    }
  }

  Future<List<String>> getKoeder(String koederType) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(koederType).get();
      List<String> koeder = querySnapshot.docs.map((doc) => doc.id).toList();
      return koeder;
    } catch (e) {
      print("Fehler beim Laden der Köder: $e");
      return [];
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Kein Bild ausgewählt.');
      }
    });
  }

  Future<String?> uploadImage() async {
    if (_image == null) return null;

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String fileName =
          'Userpics/user_$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      print('Bild erfolgreich hochgeladen. Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Fehler beim Hochladen des Bildes: $e');
      return null;
    }
  }

  Future<void> _saveFangToFirebase() async {
    if (selectedAngelmethode == null || selectedKoeder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Bitte wählen Sie Angelmethode und Köder aus.',
                style: blackTextStyle)),
      );
      return;
    }

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Kein Benutzer angemeldet');
      }

      if (_image != null) {
        uploadedImageUrl = await uploadImage();
        if (uploadedImageUrl == null) {
          throw Exception('Fehler beim Hochladen des Bildes');
        }
      }

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      Map<String, dynamic> fangData = widget.fangData.toMap();
      fangData.addAll({
        'angelmethode': selectedAngelmethode,
        'koederTyp': isNaturkoeder ? 'Naturköder' : 'Kunstköder',
        'koeder': selectedKoeder,
        'bildUrl': uploadedImageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await userDoc.collection('faenge').add(fangData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fang erfolgreich gespeichert!')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            databaseRepository: widget.databaseRepository,
            authRepository: widget.authRepository,
            profileImageUrl: '',
            username: '',
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Fehler beim Speichern des Fangs: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Fehler beim Speichern: $e', style: blackTextStyle)),
      );
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
                image: AssetImage('assets/images/hintergründe/Blancscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(height: 50),
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
                  Text(
                    "Fang eintragen 2",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<List<String>>(
                    future: getAngelmethoden(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Fehler: ${snapshot.error}",
                            style: blackTextStyle);
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        List<String> angelmethoden = snapshot.data!;
                        return DropdownButtonFormField<String>(
                          value: selectedAngelmethode,
                          decoration: InputDecoration(
                            labelText: 'Angelmethode',
                            labelStyle: blackTextStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: angelmethoden.map((String methode) {
                            return DropdownMenuItem<String>(
                              value: methode,
                              child: Text(methode, style: blackTextStyle),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedAngelmethode = newValue;
                            });
                          },
                          style: blackTextStyle,
                        );
                      } else {
                        return Text("Keine Angelmethoden gefunden",
                            style: blackTextStyle);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: Text("Naturköder", style: blackTextStyle),
                          value: isNaturkoeder,
                          onChanged: (bool? value) {
                            setState(() {
                              isNaturkoeder = value ?? false;
                              if (isNaturkoeder) {
                                isKunstkoeder = false;
                              }
                              selectedKoeder = null;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text("Kunstköder", style: blackTextStyle),
                          value: isKunstkoeder,
                          onChanged: (bool? value) {
                            setState(() {
                              isKunstkoeder = value ?? false;
                              if (isKunstkoeder) {
                                isNaturkoeder = false;
                              }
                              selectedKoeder = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (isNaturkoeder || isKunstkoeder)
                    FutureBuilder<List<String>>(
                      future: getKoeder(
                          isNaturkoeder ? 'Naturköder' : 'Kunstköder'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Fehler: ${snapshot.error}",
                              style: blackTextStyle);
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          List<String> koeder = snapshot.data!;
                          return DropdownButtonFormField<String>(
                            value: selectedKoeder,
                            decoration: InputDecoration(
                              labelText: 'Köder',
                              labelStyle: blackTextStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: koeder.map((String koeder) {
                              return DropdownMenuItem<String>(
                                value: koeder,
                                child: Text(koeder, style: blackTextStyle),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedKoeder = newValue;
                              });
                            },
                            style: blackTextStyle,
                          );
                        } else {
                          return Text("Keine Köder gefunden",
                              style: blackTextStyle);
                        }
                      },
                    ),
                  const SizedBox(height: 20),
                  if (_image != null)
                    Image.file(
                      _image!,
                      height: 200,
                    )
                  else
                    Text('Kein Bild ausgewählt', style: blackTextStyle),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => getImage(ImageSource.camera),
                        child: Text('Foto aufnehmen',
                            style: TextStyle(color: Colors.black)),
                      ),
                      ElevatedButton(
                        onPressed: () => getImage(ImageSource.gallery),
                        child: Text('Aus Galerie wählen',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveFangToFirebase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 79, 106, 78),
                      foregroundColor: const Color.fromARGB(255, 223, 242, 224),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Fang melden',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.check, color: Colors.white),
                      ],
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
}
