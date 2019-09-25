import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

String generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

Future<void> setStringItem(key, value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<String> getStringItem(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool> clearAll() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}

Future getUserInfo() async {
  String userName = await getStringItem('userName');
  String userId = await getStringItem('userId');
  return userName != null || userId != null;
}
