class CustomisedUser {
  String uid;
  bool state = false;
  bool hasBeenContacted = false;
  bool hasTemperature = false;
  bool hasCough = false;
  bool hasSenseLoss = false;

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

  bool get gotTemperature {
    return hasTemperature;
  }

  set gotTemperature(bool currentState) {
    hasTemperature = currentState;
  }

  bool get gotCough {
    return hasCough;
  }

  set gotCough(bool currentState) {
    hasCough = currentState;
  }

  bool get gotSenseLoss {
    return hasSenseLoss;
  }

  set gotSenseLoss(bool currentState) {
    hasSenseLoss = currentState;
  }

  Map<String, dynamic> toMap() => {
        "id": uid,
        "state": state,
        "contact": hasBeenContacted,
      };

  static CustomisedUser fromMap(Map<String, dynamic> map) {
    return CustomisedUser(
      map['id'],
    );
  }
}
