import 'package:shared_preferences/shared_preferences.dart';

/*
This is a null safety class
 */
class UserPreference {
  static SharedPreferences _preferences;

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String userId) async {
    await _preferences.setString("id", userId);
  }

  static String getUsername() {
    final id = _preferences.getString("id");
    return id == null ? "" : id;
  }

  static Future setInfectionState(bool isInfected) async {
    await _preferences.setBool("infectionState", isInfected);
  }

  static bool getInfectionState() {
    bool infection = _preferences.getBool("infectionState");
    return infection == null ? false : infection;
  }

  static Future setContactedState(bool isContacted) async {
    await _preferences.setBool("contactedState", isContacted);
  }

  static bool getContactedState() {
    bool contacted = _preferences.getBool("contactedState");
    return contacted == null ? false : contacted;
  }

  static Future setHasFever(bool hasFever) async {
    await _preferences.setBool("feverState", hasFever);
  }

  static bool getHasFever() {
    bool fever = _preferences.getBool("feverState");
    return fever == null ? false : fever;
  }

  static Future setHasCough(bool hasCough) async {
    await _preferences.setBool("coughState", hasCough);
  }

  static bool getHasCough() {
    bool cough = _preferences.getBool("coughState");;
    return cough == null ? false : cough;
  }

  static Future setHasSenseLoss(bool hasSenseLoss) async {
    await _preferences.setBool("senseLossState", hasSenseLoss);
  }

  static bool getHasSenseLoss() {
    bool senseLoss = _preferences.getBool("senseLossState");
    return senseLoss == null ? false : senseLoss;
  }

  static Future setIsolationDue(String isolationDue) async {
    await _preferences.setString("isolationDue", isolationDue);
  }

  static String getIsolationDue() {
    String isolation = _preferences.getString("isolationDue");
    return  isolation == null ? "" : isolation;
  }
}