import 'package:cloud_firestore/cloud_firestore.dart';

class FangData {
  final String id;
  final String fischart;
  final double groesse;
  final double gewicht;
  final DateTime datum;
  final String gewaesser;
  final String? bildUrl;
  final String userID;
  final String username;
  final String? angelmethode;
  final String? naturkoeder;

  FangData({
    required this.id,
    required this.fischart,
    required this.groesse,
    required this.gewicht,
    required this.datum,
    required this.gewaesser,
    this.bildUrl,
    required this.userID,
    required this.username,
    this.angelmethode,
    this.naturkoeder,
  });

  factory FangData.fromMap(Map<String, dynamic> map, String id) {
    return FangData(
      id: id,
      fischart: map['fischart'] ?? '',
      groesse: (map['groesse'] ?? 0.0).toDouble(),
      gewicht: (map['gewicht'] ?? 0.0).toDouble(),
      datum: (map['datum'] as Timestamp).toDate(),
      gewaesser: map['gewaesser'] ?? '',
      bildUrl: map['bildUrl'],
      userID: map['userID'] ?? '',
      username: map['username'] ?? 'Unbekannter Angler',
      angelmethode: map['angelmethode'],
      naturkoeder: map['naturkoeder'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fischart': fischart,
      'groesse': groesse,
      'gewicht': gewicht,
      'datum': Timestamp.fromDate(datum),
      'gewaesser': gewaesser,
      'bildUrl': bildUrl,
      'userID': userID,
      'username': username,
      'angelmethode': angelmethode,
      'naturkoeder': naturkoeder,
    };
  }

  FangData copyWith({
    String? id,
    String? fischart,
    double? groesse,
    double? gewicht,
    DateTime? datum,
    String? gewaesser,
    String? bildUrl,
    String? userID,
    String? username,
    String? angelmethode,
    String? naturkoeder,
  }) {
    return FangData(
      id: id ?? this.id,
      fischart: fischart ?? this.fischart,
      groesse: groesse ?? this.groesse,
      gewicht: gewicht ?? this.gewicht,
      datum: datum ?? this.datum,
      gewaesser: gewaesser ?? this.gewaesser,
      bildUrl: bildUrl ?? this.bildUrl,
      userID: userID ?? this.userID,
      username: username ?? this.username,
      angelmethode: angelmethode ?? this.angelmethode,
      naturkoeder: naturkoeder ?? this.naturkoeder,
    );
  }

  @override
  String toString() {
    return 'FangData(id: $id, fischart: $fischart, groesse: $groesse, gewicht: $gewicht, datum: $datum, gewaesser: $gewaesser, bildUrl: $bildUrl, userID: $userID, username: $username, angelmethode: $angelmethode, naturkoeder: $naturkoeder)';
  }
}
