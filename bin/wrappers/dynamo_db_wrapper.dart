library dartup_server_wrapper_dynamodb;

import "dart:async";
import "dart:io";
import "dart:convert";

import "../server_lib.dart";

class DynamoDbWrapper extends DynamoDb{
  
  @override
  Future<Map> getItem(String table, Map key) =>
      _cli("get-item", {"table-name": table, "key": key});

  @override
  Future putItem(String table, Map item) =>
    _cli("put-item", {"table-name": table, "item": item});
  
  _cli(String action, Map args){
    return new Future.sync((){
      var a = ["--output", "json", "--region", "eu-west-1", "dynamodb"];
      a.add(action);
      args.forEach((k,v){
        a.add("--$k");
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
}