import "package:unittest/unittest.dart";

import "../bin/server.dart";

main(){
  test('get42', (){
    expect(get42(),42);
  });
}