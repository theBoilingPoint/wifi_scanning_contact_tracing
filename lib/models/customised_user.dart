class CustomisedUser {
  String uid;
  bool state;

  CustomisedUser(this.uid, this.state);

  String get userId {
    return uid;
  }

  set userId(String id) {
    uid = id;
  }

  bool get infectionState {
    return state;
  }

  set infectionState(bool currentState) {
    state = currentState;
  }

  Map<String, dynamic> toMap() => {
    "id": uid,
    "state": state,
  };

  static CustomisedUser fromMap(Map<String, dynamic> map){
    return CustomisedUser(
        map['id'],
        map['state'],
    );
  }

}