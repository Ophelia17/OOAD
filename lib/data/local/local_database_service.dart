import 'package:shared_preferences/shared_preferences.dart'; //the package/library used

// we have to store some things, like logged in status etc

class LocalStorageService {
  //Member Data:
  static late LocalStorageService _instance;
  static late SharedPreferences _preferences;

  //Keys: (all data will be stored in format of key value pairs)
  static const String isLoggedInKey = 'is_logged_in_key';
  static const String isLoggedInWithGoogleKey = 'login_google_key';
  static const String uidKey = 'uid';

  //Functions:
  static Future<LocalStorageService> getInstance() async {
    _instance = LocalStorageService();
    //await keyword is used to tell the program that we have
    //to wait till an async function gives us(returns) something
    _preferences = await SharedPreferences.getInstance();
    return _instance;
  }

  //Function to get something stored on the phone
  //dynamic means that the datatype of the value that
  //will be returned is not fixed
  dynamic _getFromDisk(String key) {
    final value = _preferences.get(key);
    print('$value : $key of type ${value.runtimeType}');
    return value;
  }

  //Function to store something on the phone
  //the "T" used here is to tell that the content can be of any data type
  void _saveToDisk<T>(String key, T content) {
    if (content is bool) {
      _preferences.setBool(key, content);
      //it will update the value or in case no such
      //key exists, it will create new key in storage
      //with specified content
    }
    if (content is String) {
      _preferences.setString(key, content);
    }
  }

  //All the functions used above are private
  //Now declaring public functions
  //There will be different getters and setters for
  //each key that we have, each accessing one of the
  //above defined 2 functions

  //Setters:
  //NOTE: return types are avoided for setters
  set uid(String uid){
    _saveToDisk(uidKey, uid);
  }

  set isLoggedIn(bool isLoggedIn) {
    _saveToDisk(isLoggedInKey, isLoggedIn);
  }

  set isLoggedInWithGoogle(bool loginWithGoogle) {
    _saveToDisk(isLoggedInWithGoogleKey, loginWithGoogle);
  }

  //Getters:
  String get uid {
    return _getFromDisk(uidKey);
  }

  bool get isLoggedIn {
    return _getFromDisk(isLoggedInKey) ?? false;
    //Use of "??":
    //In case we haven't previously stored any value
    //for the isLoggedInKey, we will get a null value
    //If _getFromDisk(isLoggedInKey) returns NULL,
    //function will return value after the ??, i.e. false in this case
  }

  bool get isLoggedInWithGoogle {
    return _getFromDisk(isLoggedInWithGoogleKey) ?? false;
  }
}
