import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluhg/core/data_source/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSource{
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage flutterSecureStorage;

  LocalSource({required this.sharedPreferences, required this.flutterSecureStorage});

  /// set value of example
  Future<bool> setExample(String value)async {
    return await sharedPreferences.setString(KEY_EXAMPLE, value);
  }

  /// get value of example
  String? getExample(){
    return sharedPreferences.getString(KEY_EXAMPLE);
  }

  /// set value of secure example
  Future<void> setSecureExample(String value)async{
    await flutterSecureStorage.write(key: KEY_EXAMPLE, value: value);
  }

  /// get value of secure example
  Future<String?> getSecureExample() async{
    return await flutterSecureStorage.read(key: KEY_EXAMPLE);
  }
}