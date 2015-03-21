library dartup_server_runner;

import "dart:io";

import "server_lib.dart";
import "wrappers/github_wrapper.dart";
import "wrappers/dynamo_db_wrapper.dart";

import "package:di/di.dart";
import "package:http/http.dart" as http;
import "package:redstone/server.dart" as app;

main(List<String> args){
  app.addModule(new Module()
    ..bind(http.Client)
    ..bind(Map,toValue: Platform.environment, withAnnotation: const EnvVars())
    ..bind(Auth)
    ..bind(DataStore)
    ..bind(Github, toImplementation: GithubWrapper)
    ..bind(DynamoDb, toImplementation: DynamoDbWrapper));
  
  app.setupConsoleLog();
  app.start(port:8081);
}