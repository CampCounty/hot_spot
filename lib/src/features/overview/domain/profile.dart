class Profile {
  // Attribute
  String userID;
  String vorname;
  String nachname;
  int postleitzahl;
  String wohnort;
  String bundesland;
  String email;
  String geburtstag;

  Profile({
    required this.userID,
    required this.vorname,
    required this.nachname,
    required this.postleitzahl,
    required this.wohnort,
    required this.bundesland,
    required this.email,
    required this.geburtstag,
  });
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'vorname': vorname,
      'nachname': nachname,
      'postleitzahl': postleitzahl,
      'wohnort': wohnort,
      'bundesland': bundesland,
      'email': email,
      'geburtstag': geburtstag,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      userID: map["userID"],
      vorname: map["vorname"],
      nachname: map["nachname"],
      postleitzahl: map["postleitzahl"],
      wohnort: map["wohnort"],
      bundesland: map["bundesland"],
      email: map["email"],
      geburtstag: map["geburtstag"],
    );
  }
}
