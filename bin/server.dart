library dartup_server_runner;

import "dart:io";

import "server_lib.dart";
import "wrappers/github_wrapper.dart";

import "package:di/di.dart";
import "package:http/http.dart" as http;
import "package:redstone/server.dart" as app;

main(List<String> args){
  app.addModule(new Module()
    ..bind(http.Client)
    ..bind(Map,toValue: Platform.environment, withAnnotation: const EnvVars())
    ..bind(Auth)
    ..bind(DynamoCli,toValue: dynamodbCli)
    ..bind(Dynamodb)
    ..bind(Github, toImplementation: GithubWrapper));
  
  app.setupConsoleLog();
  app.start(port:8081);
}