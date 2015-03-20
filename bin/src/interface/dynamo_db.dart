part of dartup_server;

abstract class DynamoDb{
  Future<Map> getItem(String table, Map key);
  Future putItem(String table, Map item);
}