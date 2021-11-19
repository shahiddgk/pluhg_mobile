
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pluhg/core/data_source/local_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator=GetIt.instance;

initLocator()async{
  const flutterSecureStorage = FlutterSecureStorage();
  SharedPreferences preferences=await SharedPreferences.getInstance();
  locator.registerSingleton(LocalSource(sharedPreferences: preferences, flutterSecureStorage: flutterSecureStorage));
}