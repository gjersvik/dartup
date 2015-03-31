library dartup_server_runner;

import "server_lib.dart";
import "wrappers/github_wrapper.dart";
import "wrappers/s3_datastore.dart";

import "package:di/di.dart";
import "package:redstone/server.dart" as app;

main(List<String> args){
  
  
  app.addModule(new Module()
    ..bind(Auth)
    ..bind(DataStore, toValue: new S3DataStore())
    ..bind(Users)
    ..bind(GitHub, toImplementation: GitHubWrapper));
  
  app.setupConsoleLog();
  app.start(port:8081);
}