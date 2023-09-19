class Preferences {
  static const String firstLoginUser = "firstLoginUser";
  static const String firstReadSms = "firstReadSms";
  static const String lastDateReadSms = "lastDateReadSms";

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();
  factory Preferences() => _instance;
  Preferences._internal();
}
