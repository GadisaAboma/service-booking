import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  late SharedPreferences _prefs;
  final RxBool isLoggedIn = false.obs;

  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = _prefs.getBool('isLoggedIn') ?? false;
    return this;
  }

  Future<void> login() async {
    isLoggedIn.value = true;
    await _prefs.setBool('isLoggedIn', true);
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    await _prefs.setBool('isLoggedIn', false);
  }
}
