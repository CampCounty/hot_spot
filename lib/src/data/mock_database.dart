import 'package:hot_spot/src/features/overview/domain/fang_eintragen.dart';

import 'package:hot_spot/src/features/overview/domain/profile.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class MockDatabase implements DatabaseRepository {
  List<Profile> profile = [];
  List<Fang> faenge = [];
  Profile angemeldetUser = Profile(
      userID: "DW",
      vorname: "Daniel",
      nachname: "Werner",
      postleitzahl: 06792,
      Wohnort: "Sandersdorf",
      e_mail: "xy.dd@.de",
      Geburtstag: "13.04.1972");

  List<String> naturkoeder = [
    "Teig",
    "Mais",
    "Bienenmade",
    "Kaese",
    "Boilie",
    "Pellet",
    "Dentrobena",
    "Made",
    "Tauwurm",
    "Fischfetzen",
    "Koederfisch",
    "Sonstiges"
  ];
  List<String> kunstkoeder = [
    "Blinker",
    "Spinner",
    "Wobbler",
    "Gummifisch",
    "Twister",
    "Jerkbait",
    "Popper",
    "Spoon",
    "Fliege" "Sonstiges"
  ];
  List<String> methoden = [
    "grundangeln",
    "posenangeln",
    "feedern",
    "spinangeln",
    "flugangeln",
    "schleppangeln"
  ];

  List<Fang> getFaenge() {
    return faenge;
  }

  void addFang(Fang newFang) {
    faenge.add(newFang);
  }

  List<Fang> getUserFaenge(Profile profile) {
    List<Fang> ausgewaehlteFaenge = [];
    for (Fang fang in faenge) {
      if (fang.userID == profile.userID) {
        ausgewaehlteFaenge.add(fang);
      }
    }
    return ausgewaehlteFaenge;
  }
}
