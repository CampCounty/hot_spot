import 'package:cloud_firestore/cloud_firestore.dart';

class FangData {
  final String id;
  final String userID;
  final String fischart;
  final double groesse;
  final double gewicht;
  final String gewaesser;
  final DateTime datum;
  final String? bildUrl;
  final String? angelmethode;
  final String? naturkoeder;

  FangData({
    required this.id,
    required this.userID,
    required this.fischart,
    required this.groesse,
    required this.gewicht,
    required this.gewaesser,
    required this.datum,
    this.bildUrl,
    this.angelmethode,
    this.naturkoeder,
  });

  factory FangData.fromMap(Map<String, dynamic> map, String id) {
    return FangData(
      id: id,
      userID: map['userID'] as String,
      fischart: map['fischart'] as String,
      groesse: (map['groesse'] as num).toDouble(),
      gewicht: (map['gewicht'] as num).toDouble(),
      gewaesser: map['gewaesser'] as String,
      datum: (map['datum'] as Timestamp).toDate(),
      bildUrl: map['bildUrl'] as String?,
      angelmethode: map['angelmethode'] as String?,
      naturkoeder: map['naturkoeder'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'fischart': fischart,
      'groesse': groesse,
      'gewicht': gewicht,
      'gewaesser': gewaesser,
      'datum': Timestamp.fromDate(datum),
      'bildUrl': bildUrl,
      'angelmethode': angelmethode,
      'naturkoeder': naturkoeder,
    };
  }

  FangData copyWith({
    String? id,
    String? userID,
    String? fischart,
    double? groesse,
    double? gewicht,
    String? gewaesser,
    DateTime? datum,
    String? bildUrl,
    String? angelmethode,
    String? naturkoeder,
  }) {
    return FangData(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      fischart: fischart ?? this.fischart,
      groesse: groesse ?? this.groesse,
      gewicht: gewicht ?? this.gewicht,
      gewaesser: gewaesser ?? this.gewaesser,
      datum: datum ?? this.datum,
      bildUrl: bildUrl ?? this.bildUrl,
      angelmethode: angelmethode ?? this.angelmethode,
      naturkoeder: naturkoeder ?? this.naturkoeder,
    );
  }

  @override
  String toString() {
    return 'FangData(id: $id, userID: $userID, fischart: $fischart, groesse: $groesse, gewicht: $gewicht, gewaesser: $gewaesser, datum: $datum, bildUrl: $bildUrl, angelmethode: $angelmethode, naturkoeder: $naturkoeder)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FangData &&
        other.id == id &&
        other.userID == userID &&
        other.fischart == fischart &&
        other.groesse == groesse &&
        other.gewicht == gewicht &&
        other.gewaesser == gewaesser &&
        other.datum == datum &&
        other.bildUrl == bildUrl &&
        other.angelmethode == angelmethode &&
        other.naturkoeder == naturkoeder;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userID.hashCode ^
        fischart.hashCode ^
        groesse.hashCode ^
        gewicht.hashCode ^
        gewaesser.hashCode ^
        datum.hashCode ^
        bildUrl.hashCode ^
        angelmethode.hashCode ^
        naturkoeder.hashCode;
  }
}
