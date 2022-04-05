// ignore_for_file: prefer_const_declarations, unused_field

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService extends GetxService {
  static late SharedPreferences _preferences;

  static final _keyIsFirstLog = 'isFirstLog';
  static final _keyIsLogged = '_keyIsLogged';
  static final _keyStatus = 'unlogged';
  static final _keyUserId = 'userId';
  static final _keyC1 = '0';
  static final _keyC2 = '1';
  static final _keyC3 = '2';
  static final _keyC4 = '3';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future clear() async {
    _preferences.clear();
  }

  static Future setIsFirstLog(bool userId) async {
    await _preferences.setBool(_keyIsFirstLog, userId);
  }

  static bool? getIsFirstLog() {
    final data = _preferences.getBool(_keyIsFirstLog);

    if (data != null) return data;
    return null;
  }

    static Future setIsLogged(bool userId) async {
    await _preferences.setBool(_keyIsLogged, userId);
  }

  static bool? getIsLogged() {
    final data = _preferences.getBool(_keyIsLogged);

    if (data != null) return data;
    return null;
  }

  static Future setStatus(String status) async {
    await _preferences.setString(_keyStatus, status);
  }

  static String? getStatus() {
    final data = _preferences.getString(_keyStatus);

    if (data != null) return data;
    return null;
  }

  static Future setC1(int c1) async {
    await _preferences.setInt(_keyC1, c1);
  }

  static int? getC1() {
    final data = _preferences.getInt(_keyC1);

    if (data != null) return data;
    return null;
  }

  static Future setC2(int c2) async {
    await _preferences.setInt(_keyC2, c2);
  }

  static int? getC2() {
    final data = _preferences.getInt(_keyC2);

    if (data != null) return data;
    return null;
  }

  static Future setC3(int c3) async {
    await _preferences.setInt(_keyC3, c3);
  }

  static int? getC3() {
    final data = _preferences.getInt(_keyC3);

    if (data != null) return data;
    return null;
  }

  static Future setC4(int c4) async {
    await _preferences.setInt(_keyC4, c4);
  }

  static int? getC4() {
    final data = _preferences.getInt(_keyC4);

    if (data != null) return data;
    return null;
  }
}
