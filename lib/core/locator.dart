// This is a single stop for all dependencies
// required in our app - like localStorage, etc.

import 'package:get_it/get_it.dart';

import 'package:enono/data/local/local_database_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async{
  final localStorageService = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(localStorageService);
}