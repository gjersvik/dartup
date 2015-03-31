part of dartup_server;

class DynamoDbDataStore implements DataStore{
  DynamoDb _db;

  DynamoDbDataStore(this._db);

  /// get json data from persistent storage.
  ///
  /// Returns empty map if no object is found, or throws a DataStoreException.
  Future<Map> get(String container, String key, value){
    //TODO Need to return {} on empty object.
    //TODO Have it throw DataStoreException on DynamoDb exceptions.
    return _db.getItem(container, {key:jsonToDynamo(value)})
        .then((Map p) => dynamoToJson({"M": p["Item"]}));
  }

  /// updated or creates a new json document from persistent storage.
  ///
  /// Returns null on when data is persistent.
  /// Throws an DataStoreException on underlying failure.
  /// Throws DataStoreError on malformed data.
  Future set(String table, Map jsonItem){
    //TODO Have it throw [DataStoreException] on DynamoDb exceptions.
    //TODO Have it throw [ArgumentError] on malformed data.
    return _db.putItem(table, jsonToDynamo(jsonItem)['M']).then((_) => null);
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