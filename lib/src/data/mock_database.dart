// Modellklasse für Fangdaten
class FangData {
  final String id;
  final String userId;
  final String fischart;
  final int groesse;
  final int gewicht;
  final String datum;
  final String uhrzeit;
  final String ort;
  final String bundesland;
  final String gewaesser;

  FangData({
    required this.id,
    required this.userId,
    required this.fischart,
    required this.groesse,
    required this.gewicht,
    required this.datum,
    required this.uhrzeit,
    required this.ort,
    required this.bundesland,
    required this.gewaesser,
  }) {
    assert(groesse > 0, 'Größe muss positiv sein');
    assert(gewicht > 0, 'Gewicht muss positiv sein');
  }
}

// Erweiterung für Iterable, um den Durchschnitt zu berechnen
extension IterableAverage on Iterable<int> {
  double get average {
    if (isEmpty) return 0.0;
    return reduce((a, b) => a + b) / length;
  }
}

// Mock-Datenbankklasse
class MockDatabase {
  final List<FangData> _faenge = [];

  Future<List<FangData>> getFaenge() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return _faenge;
    } catch (e) {
      //print('Unexpected error: $e');
      rethrow;
    }
  }

  Future<void> addFang(FangData newFang) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _faenge.add(newFang);
    } on ArgumentError catch (e) {
      throw DatabaseException('Ungültige Fangdaten: $e');
    }
  }

  Future<double> getAverageFangGroesse(String userId) async {
    try {
      final userFaenge = _faenge.where((fang) => fang.userId == userId);
      if (userFaenge.isEmpty) return 0.0;
      return userFaenge.map((fang) => fang.groesse).average;
    } catch (e) {
      rethrow;
    }
  }
}

// Eigene Ausnahme für Datenbankfehler
class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

// Beispiel für die Verwendung:
void main() async {
  final db = MockDatabase();
  try {
    final newFang = FangData(
      id: '4',
      userId: 'Max',
      fischart: 'Aal',
      groesse: 45,
      gewicht: 1200,
      datum: '2024-07-27', // Beispiel-Datum
      uhrzeit: '12:00', // Beispiel-Uhrzeit
      ort: 'Berlin',
      bundesland: 'Berlin',
      gewaesser: 'Spree',
    );
    await db.addFang(newFang);
    final faenge = await db.getFaenge();
    print(faenge);
    final averageGroesse = await db.getAverageFangGroesse('Max');
    print('Durchschnittliche Größe der Fänge von Max: $averageGroesse cm');
  } catch (e) {
    //print('Fehler: $e');
  }
}
