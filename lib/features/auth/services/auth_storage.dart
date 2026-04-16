import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserRole {
  static const guru = 'guru';
  static const kepsek = 'kepsek';
  static const admin = 'admin';
}

class AuthStorage {
  static const _tokenKey = 'token';
  static const _userKey = 'user';

  // ================= TOKEN =================
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ================= USER =================
  Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);

    if (data == null) return null;

    return jsonDecode(data);
  }

  // ================= ROLE =================
  Future<String?> getRole() async {
    final user = await getUser();
    return user?['role'];
  }

  Future<bool> isGuru() async {
    return (await getRole()) == UserRole.guru;
  }

  Future<bool> isKepsek() async {
    return (await getRole()) == UserRole.kepsek;
  }

  Future<bool> isAdmin() async {
    return (await getRole()) == UserRole.admin;
  }

  // ================= CLEAR =================
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}