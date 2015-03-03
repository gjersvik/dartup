library dartup_prototype_dynamodb;

import "dart:async";
import "dart:convert";
import "dart:io";


printStream(Stream<List<int>> stream ){
  UTF8.decodeStream(stream).then(print);
}

main(){
  // put data into dynamodb
  
  var args = ["--output", "json", "--region", "eu-west-1", "dynamodb", "put-item", "--table-name", "dartup_prototype", "--item"];
  var item = {
    "id": {"S": "test-item"},
    "map": {"M": {
      "item1": {"N": "42"}
    }}
  };
  args.add(JSON.encode(item));
  Process.start("aws",args).then((Process p){
    printStream(p.stderr);
    printStream(p.stdout);
  });
  
  // get data back from dynamodb
  args = ["--output", "json", "--region", "eu-west-1", "dynamodb", "get-item", "--table-name", "dartup_prototype", "--key"];
  item = {
    "id": {"S": "test-item"}
  };
  args.add(JSON.encode(item));
  Process.start("aws",args).then((Process p){
    printStream(p.stderr);
    printStream(p.stdout);
  });
}