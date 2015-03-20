part of dartup_server;

abstract class Github{
  String get clientId;
 
  Future<Map> auth(String code);
  Future<Map> user(String token);
}