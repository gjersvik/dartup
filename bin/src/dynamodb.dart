part of dartup_server;

Future<Map> dynamodbCli(String action, Map args){
  return new Future.sync((){
    var a = ["--output", "json", "--region", "eu-west-1", "dynamodb"];
    a.add(action);
    args.forEach((k,v){
      a.add("--$key");
      if(v is! String){
        v = JSON.encode(v);
      }
      a.add(v);
    });
    return Process.run("aws",a);
  }).then((ProcessResult res){
    if(res.exitCode != 0){
      throw new Exception(res.stdout);
    }
    return JSON.decode(UTF8.decode(res.stdout));
  });
}
typedef Future<Map> DynamoCli(String action, Map args);

class Dynamodb{
  DynamoCli _cli;

  Dynamodb(this._cli);

  Future<Map> get(String table, Map jsonKey){
    return _cli("get-item",{
      "table-name": table,
      "key": jsonToDynamo(jsonKey)["M"]
    }).then((Map p) => dynamoToJson({"M": p["Item"]}));
  }
  
  Future set(String table, Map jsonItem){
    return _cli("put-item", {
      "table-name": table,
      "item": jsonToDynamo(jsonItem)['M']
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