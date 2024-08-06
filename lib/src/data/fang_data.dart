import 'package:cloud_firestore/cloud_firestore.dart';

class FangData {
  final String id;
  final String userID;
  final String username;
  final String fischart;
  final double groesse;
  final double gewicht;
  final String gewaesser;
  final DateTime datum;
  final String? bildUrl;
  final String? angelmethode;
  final String? koeder;
  final String? koederTyp;
  final String? naturkoeder;
  final bool isPB;

  FangData({
    required this.id,
    required this.userID,
    required this.username,
    required this.fischart,
    required this.groesse,
    required this.gewicht,
    required this.gewaesser,
    required this.datum,
    this.bildUrl,
    this.angelmethode,
    this.koeder,
    this.koederTyp,
    this.naturkoeder,
    this.isPB = false,
  });

  factory FangData.fromMap(Map<String, dynamic> map, String id) {
    return FangData(
      id: id,
      userID: map['userID'] ?? '',
      username: map['username'] ?? '',
      fischart: map['fischart'] ?? '',
      groesse: (map['groesse'] ?? 0).toDouble(),
      gewicht: (map['gewicht'] ?? 0).toDouble(),
      gewaesser: map['gewaesser'] ?? '',
      datum: (map['datum'] as Timestamp).toDate(),
      bildUrl: map['bildUrl'],
      angelmethode: map['angelmethode'],
      koeder: map['koeder'],
      koederTyp: map['koederTyp'],
      naturkoeder: map['naturkoeder'],
      isPB: map['isPB'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'username': username,
      'fischart': fischart,
      'groesse': groesse,
      'gewicht': gewicht,
      'gewaesser': gewaesser,
      'datum': Timestamp.fromDate(datum),
      'bildUrl': bildUrl,
      'angelmethode': angelmethode,
      'koeder': koeder,
      'koederTyp': koederTyp,
      'naturkoeder': naturkoeder,
      'isPB': isPB,
    };
  }

  FangData copyWith({
    String? id,
    String? userID,
    String? username,
    String? fischart,
    double? groesse,
    double? gewicht,
    String? gewaesser,
    DateTime? datum,
    String? bildUrl,
    String? angelmethode,
    String? koeder,
    String? koederTyp,
    String? naturkoeder,
    bool? isPB,
  }) {
    return FangData(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      username: username ?? this.username,
      fischart: fischart ?? this.fischart,
      groesse: groesse ?? this.groesse,
      gewicht: gewicht ?? this.gewicht,
      gewaesser: gewaesser ?? this.gewaesser,
      datum: datum ?? this.datum,
      bildUrl: bildUrl ?? this.bildUrl,
      angelmethode: angelmethode ?? this.angelmethode,
      koeder: koeder ?? this.koeder,
      koederTyp: koederTyp ?? this.koederTyp,
      naturkoeder: naturkoeder ?? this.naturkoeder,
      isPB: isPB ?? this.isPB,
    );
  }

  @override
  String toString() {
    return 'FangData(id: $id, userID: $userID, username: $username, fischart: $fischart, groesse: $groesse, gewicht: $gewicht, gewaesser: $gewaesser, datum: $datum, bildUrl: $bildUrl, angelmethode: $angelmethode, koeder: $koeder, koederTyp: $koederTyp, naturkoeder: $naturkoeder, isPB: $isPB)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FangData &&
        other.id == id &&
        other.userID == userID &&
        other.username == username &&
        other.fischart == fischart &&
        other.groesse == groesse &&
        other.gewicht == gewicht &&
        other.gewaesser == gewaesser &&
        other.datum == datum &&
        other.bildUrl == bildUrl &&
        other.angelmethode == angelmethode &&
        other.koeder == koeder &&
        other.koederTyp == koederTyp &&
        other.naturkoeder == naturkoeder &&
        other.isPB == isPB;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userID.hashCode ^
        username.hashCode ^
        fischart.hashCode ^
        groesse.hashCode ^
        gewicht.hashCode ^
        gewaesser.hashCode ^
        datum.hashCode ^
        bildUrl.hashCode ^
        angelmethode.hashCode ^
        koeder.hashCode ^
        koederTyp.hashCode ^
        naturkoeder.hashCode ^
        isPB.hashCode;
  }
}
