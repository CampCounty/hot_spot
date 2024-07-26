class FangData {
  String? fischart;
  int? groesse;
  int? gewicht;
  String? datum;
  String? uhrzeit;
  String? ort;
  String? bundesland;
  String? gewaesser;

  FangData({
    this.fischart,
    this.groesse,
    this.gewicht,
    this.datum,
    this.uhrzeit,
    this.ort,
    this.bundesland,
    this.gewaesser,
  });

  Map<String, dynamic> toMap() {
    return {
      'fischart': fischart,
      'groesse': groesse,
      'gewicht': gewicht,
      'datum': datum,
      'uhrzeit': uhrzeit,
      'ort': ort,
      'bundesland': bundesland,
      'gewaesser': gewaesser,
    };
  }
}
