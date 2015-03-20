part of dartup_controll;

abstract class Github{
  String get clientId;
 
  Future<Map> auth(String code);
  Future<Map> user(String token);
}