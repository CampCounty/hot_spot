import 'package:cloud_firestore/cloud_firestore.dart';

class FangData {
  String? id;
  String? userId;
  String? fischart;
  int? groesse;
  int? gewicht;
  String? datum;
  String? uhrzeit;
  String? ort;
  String? bundesland;
  String? gewaesser;
  DateTime? timestamp;

  FangData({
    this.id,
    this.userId,
    this.fischart,
    this.groesse,
    this.gewicht,
    this.datum,
    this.uhrzeit,
    this.ort,
    this.bundesland,
    this.gewaesser,
    this.timestamp,
  });

  FangData.fromMap(Map<String, dynamic> map, this.id) {
    userId = map['userId'];
    fischart = map['fischart'];
    groesse = map['groesse'];
    gewicht = map['gewicht'];
    datum = map['datum'];
    uhrzeit = map['uhrzeit'];
    ort = map['ort'];
    bundesland = map['bundesland'];
    gewaesser = map['gewaesser'];
    timestamp = (map['timestamp'] as Timestamp?)?.toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fischart': fischart,
      'groesse': groesse,
      'gewicht': gewicht,
      'datum': datum,
      'uhrzeit': uhrzeit,
      'ort': ort,
      'bundesland': bundesland,
      'gewaesser': gewaesser,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
    };
  }
}
