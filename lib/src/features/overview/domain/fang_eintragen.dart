import 'angelarten.dart';
import 'koeder.dart';

class Fang {
  String userID;
  String gewaesser;
  String datum;
  String uhrzeit;
  String fischart;
  List<Angelart> angelart;
  List<Koeder> bait;
  double groesse;
  double gewicht;
  bool release;

  Fang({
    required this.userID,
    required this.gewaesser,
    required this.datum,
    required this.uhrzeit,
    required this.fischart,
    required this.angelart,
    required this.bait,
    required this.groesse,
    required this.gewicht,
    required this.release,
  });
}