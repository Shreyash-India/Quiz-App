import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAIL";

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        Constants.sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> getUerLoggedInSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final isLoggedIn =
        sharedPreferences.getBool(Constants.sharedPreferenceUserLoggedInKey);
    if (isLoggedIn == null || isLoggedIn == false) {
      return false;
    } else {
      return true;
    }
  }

  static void isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(
        "Is User Active ${sharedPreferences.getBool(Constants.sharedPreferenceUserLoggedInKey)}");
  }
}
