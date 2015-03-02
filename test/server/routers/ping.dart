part of dartup_controll_test;

ping() => group('ping',(){
  test("ping return pong", () {
    //create a mock request
    var req = new MockRequest("/ping");
    //dispatch the request
    return app.dispatch(req).then((resp) {
      //verify the response
      expect(resp.statusCode, equals(200));
      expect(resp.mockContent, equals("pong"));
    });
  });
  
  test("ping auth return 403", () {
    //create a mock request
    var req = new MockRequest("/ping/auth");
    //dispatch the request
    return app.dispatch(req).then((resp) {
      //verify the response
      expect(resp.statusCode, equals(HttpStatus.FORBIDDEN));
    });
  });
});