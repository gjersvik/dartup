library dartup_controll;

import "package:redstone/server.dart" as app;

part "src/ping.dart";

@app.Route("/")
helloWorld() => "Hello, World!";

main(List<String> args){
  app.setupConsoleLog();
  app.start();
}