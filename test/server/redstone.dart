part of dartup_controll_test;

Future<bool> unittesAuth(String token){
  return new Future.sync(() => token == 'unittest');
}

redstone(void body()){
  group("Redstone",(){
    setUp((){
      app.addModule(new Module()
          ..bind(AuthFunction, toValue: unittesAuth));
      app.setUp([#dartup_controll]);
    });
    tearDown(() => app.tearDown());
    
    body();
  });
  
}