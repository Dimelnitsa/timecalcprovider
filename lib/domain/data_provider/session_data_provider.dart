import 'package:shared_preferences/shared_preferences.dart';

class SessionDataProvider{

  Future<void> saveLastSet(String nameSession) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('last_opened', nameSession);
  }

  Future<String?> getLastSet() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('last_opened');
  }


}