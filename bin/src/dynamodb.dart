part of dartup_controll;

class Dynamodb{
  Future<Map> get(String tabel, Map jsonKey){
    return new Future.sync((){
      String key = JSON.encode(jsonToDynamo(jsonKey)["M"]);
      var args = ["--output", "json",
                  "--region", "eu-west-1",
                  "dynamodb", "get-item",
                  "--table-name", tabel,
                  "--key", key];
      return Process.run("aws",args);
    }).then((ProcessResult p){
      if(p.stderr.isNotEmpty){
        throw new Exception(p.stderr);
      }
      var dynamoJson = JSON.decode(p.stdout);
      return dynamoToJson({"M": dynamoJson["Item"]});
    });
  }
  
  Future set(String tabel, Map jsonItem){
    return new Future.sync((){
      String item = JSON.encode(jsonToDynamo(jsonItem)['M']);
      var args = ["--output", "json",
                  "--region", "eu-west-1",
                  "dynamodb", "put-item",
                  "--table-name", tabel,
                  "--item", item];
      return Process.run("aws",args);
    }).then((ProcessResult p){
      if(p.stderr.isNotEmpty){
        throw new Exception(p.stderr);
      }
    });
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