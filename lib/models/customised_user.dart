class CustomisedUser {
  final String uid;
  bool state = false;

  CustomisedUser(this.uid);

  String get userId {
    return uid;
  }

  bool get infectionState {
    return state;
  }

  set infectionState(bool currentState) {
    state = currentState;
  }

  // factory CustomisedUser.fromJson(Map<String, dynamic> json) => CustomisedUser(
  //   uid: json["id"],
  //   state: json["infection_state"],
  // );

  Map<String, dynamic> toMap() => {
    "id": uid,
    "state": state,
  };
}