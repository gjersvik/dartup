import "package:unittest/unittest.dart";

import "test_server.dart" as server;
import "test_common.dart" as common;

main(){
  group("Common", common.main);
  group("Server", server.main);
}