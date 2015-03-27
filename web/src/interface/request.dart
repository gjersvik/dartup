part of dartup_client;

typedef Future<Map> Request(String method, String uri,{
  Map<String,String> headers,
  Map json
});