part of dartup_server_test;

authTest() => group("Auth",(){
  MockGitHub gitHub;
  MockUsers users;
  Auth auth;

  setUp((){
    gitHub = new MockGitHub();
    users = new MockUsers();
    auth = new Auth(gitHub, users);
  });

  tearDown((){
    gitHub = null;
    users = null;
    auth = null;
  });

  test("validToken true of user exist",(){
    users.when(callsTo("fromAccessToken")).alwaysCall((token){
      return new Future((){
        expect(token, "testToken");
        return new User()..id = 1;
      });
    });

    return auth.validToken("testToken").then((bool accept){
      expect(accept, isTrue);
    });
  });

  test("validToken false if user do not exist",(){
    users.when(callsTo("fromAccessToken")).alwaysReturn(new Future.value(new User()));

    return auth.validToken("testToken").then((bool accept){
      expect(accept, isFalse);
    });
  });

  test("signin return user and outh when github code is given", (){
    gitHub.when(callsTo("auth")).alwaysCall((String code){
      return new Future((){
        expect(code, "testCode");
        return {"access_token": "testToken"};
      });
    });

    users.when(callsTo("fromAccessToken")).alwaysCall((token, {createIfMissing: false}){
      return new Future((){
        expect(createIfMissing, isTrue);
        expect(token,"testToken");
        return new User()..id = 1;
      });
    });

    return auth.signin("testCode").then((json){
      expect(json["oauth"]["access_token"], "testToken");
      expect(json["user"]["id"], 1);
    });
  });
});