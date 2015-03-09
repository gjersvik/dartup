part of dartup_controll_test;

Future<bool> unittesAuth(String token){
  return new Future.sync(() => token == 'unittest');
}

redstone(void body()){
  group("Redstone",(){
    setUp((){
      app.addModule(new Module()
          ..bind(Auth)
          ..bind(http.Client,toValue: new MockClient((_)=> new Future.value(new MockHttpResponse())))
          ..bind(Map,toValue: {}, withAnnotation: const EnvVars()));
      app.setUp([#dartup_controll]);
    });
    tearDown(() => app.tearDown());
    
    body();
  });
  
}