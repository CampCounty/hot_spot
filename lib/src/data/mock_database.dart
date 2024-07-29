import 'package:hot_spot/src/data/fang_data.dart';

// Erweiterung für Iterable, um den Durchschnitt zu berechnen
extension IterableAverage on Iterable<double> {
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
      rethrow;
    }
  }

  Future<void> addFang(FangData newFang) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _faenge.add(newFang);
    } catch (e) {
      throw DatabaseException('Ungültige Fangdaten: $e');
    }
  }

  Future<double> getAverageFangGroesse(String userId) async {
    try {
      final userFaenge = _faenge.where((fang) => fang.userID == userId);
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
      userID: 'Max',
      fischart: 'Aal',
      groesse: 45,
      gewicht: 1.2,
      gewaesser: 'Spree',
      datum: DateTime.now(),
      bildUrl: null,
      angelmethode: null,
      naturkoeder: null,
      username: 'MockUser',
    );
    await db.addFang(newFang);
    final faenge = await db.getFaenge();
    print(faenge);
    final averageGroesse = await db.getAverageFangGroesse('Max');
    print('Durchschnittliche Größe der Fänge von Max: $averageGroesse cm');
  } catch (e) {
    print('Fehler: $e');
  }
}
