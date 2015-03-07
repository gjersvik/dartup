library dartup_controll;

import "dart:async";
import "dart:convert";
import "dart:io";

import "package:dartup/github_client_id.dart";
import "package:dartup/secret.dart";

import "package:di/di.dart";
import "package:http/http.dart" as http;
import "package:redstone/server.dart" as app;
import "package:shelf/shelf.dart" as shelf;

part "src/interceptor/cors.dart";
part "src/routers/ping.dart";
part "src/auth_manager.dart";
part "src/dynamodb.dart";

Future<bool> auth(String token){
  return new Future.value(false);
}

main(List<String> args){
  app.addModule(new Module()
    ..bind(AuthManager));
  
  app.setupConsoleLog();
  app.start(port:8081);
}