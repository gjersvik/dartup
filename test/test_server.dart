library dartup_controll_test;

import "dart:async";
import "dart:io";

import "package:unittest/unittest.dart";

import 'package:redstone/server.dart' as app;
import 'package:redstone/mocks.dart';
import 'package:di/di.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../bin/server_lib.dart';

part "server/routers/ping.dart";
part "server/redstone.dart";

main(){
  redstone((){
    ping();
  });
}