library dartup_server_test;

import "dart:async";

import "package:unittest/unittest.dart";
import "package:mock/mock.dart";

import '../bin/server_lib.dart';

part "server/mocks.dart";
part "server/users_test.dart";
part "server/auth_test.dart";

main(){
  usersTest();
  authTest();
}