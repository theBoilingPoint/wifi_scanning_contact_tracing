class CustomisedUser {
  String uid;
  bool state = false;
  bool hasBeenContacted = false;

  CustomisedUser(this.uid);

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

  bool get isContacted {
    return hasBeenContacted;
  }

  set isContacted(bool currentState) {
    hasBeenContacted = currentState;
  }

  Map<String, dynamic> toMap() => {
    "id": uid,
    "state": state,
    "contact": hasBeenContacted,
  };

  static CustomisedUser fromMap(Map<String, dynamic> map){
    return CustomisedUser(
        map['id'],
    );
  }

}