part of dartup_server;

abstract class GitHub{
  String get clientId;
 
  Future<Map> auth(String code);
  Future<Map> user(String token);
}