import 'package:hot_spot/src/features/overview/domain/angelarten.dart';
import 'package:hot_spot/src/features/overview/domain/fang_eintragen.dart';
import 'package:hot_spot/src/features/overview/domain/fischarten.dart';
import 'package:hot_spot/src/features/overview/domain/koeder.dart';

import 'package:hot_spot/src/features/overview/domain/profile.dart';
import 'package:hot_spot/src/data/database_repository.dart';

class MockDatabase implements DatabaseRepository {
  List<Profile> profile = [];

  List<Fang> faenge = [
    Fang(
        userID: 'DW',
        gewaesser: 'Elbe',
        datum: '14.05.2024',
        uhrzeit: '15:00 Uhr',
        fischart: [Fischarten(fischarten: 'Aal')],
        angelart: [Angelart(angelmethode: 'Grundangeln')],
        bait: [Koeder(name: 'Teig')],
        groesse: 50.0,
        gewicht: 1500.0,
        release: true),
    Fang(
        userID: 'Kai',
        gewaesser: 'Elbe',
        datum: '14.05.2024',
        uhrzeit: '15:00 Uhr',
        fischart: [Fischarten(fischarten: 'Aal')],
        angelart: [Angelart(angelmethode: 'Grundangeln')],
        bait: [Koeder(name: 'Teig')],
        groesse: 50.0,
        gewicht: 1500.0,
        release: true),
    Fang(
        userID: 'IW',
        gewaesser: 'Elbe',
        datum: '14.05.2024',
        uhrzeit: '15:00 Uhr',
        fischart: [Fischarten(fischarten: 'Karpfen')],
        angelart: [Angelart(angelmethode: 'Grundangeln')],
        bait: [Koeder(name: 'Teig')],
        groesse: 50.0,
        gewicht: 1500.0,
        release: true),
  ];
  Profile angemeldetUser = Profile(
    userID: "DW",
    vorname: "Daniel",
    nachname: "Werner",
    postleitzahl: 06792,
    wohnort: "Sandersdorf",
    bundesland: '',
    email: "xy.dd@.de",
    geburtstag: "13.04.1972",
  );

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
    "Fliege",
    "Sonstiges",
  ];
  List<String> methoden = [
    "grundangeln",
    "posenangeln",
    "feedern",
    "spinnangeln",
    "fliegenfischen",
    "schleppangeln",
    "stippangeln",
    "dropshot",
    "brandungsangeln",
    "pilken",
    "hochseeangeln",
    "spirolinoangeln",
    "sonstiges",
  ];

  List<String> bundeslaender = [
    'Baden-Württemberg',
    'Bayern',
    'Berlin',
    'Brandenburg',
    'Bremen',
    'Hamburg',
    'Hessen',
    'Mecklenburg-Vorpommern',
    'Niedersachsen',
    'Nordrhein-Westfalen',
    'Rheinlamd-Pfalz',
    'Saarland',
    'Sachsen',
    'Sachsen-Anhalt',
    'Schleswig-Holstein',
    'Thüringen',
  ];

  List<String> fischarten = [
    'Aal',
    'Aland',
    'Äsche',
    'Bachforelle',
    'Bachsaibling',
    'Barbe',
    'Barsch',
    'Blauleng',
    'Brasse',
    'Conger',
    'Döbel',
    'Dornhai',
    'Dorsch',
    'Elritze',
    'Flunder',
    'Giebel',
    'Goldforelle',
    'Graskarpfen',
    'Grundel',
    'Gründling',
    'Güster',
    'Hasel',
    'Hecht',
    'Heilbutt',
    'Hering',
    'Hornhecht',
    'Huchen',
    'Karausche',
    'Karpfen',
    'Katzenwels / Zwergwels',
    'Kaulbarsch',
    'Kliesche',
    'Knurrhahn',
    'Köhler',
    'Lachs',
    'Lachsforelle',
    'Laube / Ukelei',
    'Lederkarpfen',
    'Leng',
    'Lumb',
    'Makrele',
    'Maräne',
    'Marmorkarpfen',
    'Meeräsche',
    'Meerforelle',
    'Moderlieschen',
    'Nase',
    'Pollack',
    'Quappe',
    'Rapfen',
    'Regenbogenforelle',
    'Rotauge',
    'Rotbarsch',
    'Rotfeder',
    'Saibling/Seesaibling',
    'Schellfisch',
    'Schleie',
    'Schmerlen',
    'Scholle',
    'Schuppenkarpfen',
    'Seeforelle',
    'Seehecht',
    'Seerüssling',
    'Seeteufel',
    'Seezunge',
    'Silberkarpfen',
    'Spiegelkarpfen',
    'Steinbeisser',
    'Steinbutt',
    'Stint',
    'Stör',
    'Wels',
    'Wildkarpfen',
    'Wittling',
    'Wolfsbarsch',
    'Wolgazander',
    'Zährte',
    'Zander',
    'Zeilenkarpfen',
    'Zope',
    ''
  ];

  Future<List<Fang>> getFang() async {
    await Future.delayed(const Duration(seconds: 2));
    return faenge;
  }

  @override
  List<Fang> getFaenge() {
    return faenge;
  }

  @override
  void addFang(Fang newFang) {
    faenge.add(newFang);
  }

  @override
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
