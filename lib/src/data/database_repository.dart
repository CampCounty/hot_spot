import 'package:hot_spot/src/features/overview/domain/fang_eintragen.dart';

abstract class DatabaseRepository {
  Future<List<Fang>> getUserFaenge(profile);
  Future<void> addFang(Fang newFang);
  Future<List<Fang>> getFaenge();
  Future<List<String>> getFischArten();
}
