part of dartup_server;

class Datastore{
  DynamoDb _db;

  Datastore(this._db);

  Future<Map> get(String table, String key, value){
    return _db.getItem(table, {key:jsonToDynamo(value)})
        .then((Map p) => dynamoToJson({"M": p["Item"]}));
  }
  
  Future set(String table, Map jsonItem){
    return _db.putItem(table, jsonToDynamo(jsonItem)['M']);
  }

  dynamic dynamoToJson(Map dynamoJson){
    var type = dynamoJson.keys.first;
    var value = dynamoJson.values.first;
    if(type == "S"){
      return value;
    }
    if(type == "N"){
      return num.parse(value);
    }
    if(type == "BOOL"){
      return value == "true";
    }
    if(type == "NULL"){
      return null;
    }
    if(type == "M"){
      return new Map.fromIterables(value.keys,value.values.map(dynamoToJson));
    }
    if(type == "L"){
      return value.map(dynamoToJson).toList();
    }
    throw new Exception("DynamoDb type: $type is not supored");
  }
  
  Map jsonToDynamo(var json){
    if(json is String){
      return {"S": json};
    }
    if(json is num){
      return {"N": json.toString()};
    }
    if(json is bool){
      return {"BOOL": json.toString()};
    }
    if(json == null){
      return {"NULL": "true"};
    }
    if(json is Map){
      return {"M": new Map.fromIterables(json.keys,json.values.map(jsonToDynamo))};
    }
    if(json is List){
      return {"L": json.map(jsonToDynamo).toList()};
    }
    throw new Exception("The value $json do not seem to be valid JSON");
  }
}