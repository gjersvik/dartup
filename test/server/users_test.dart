part of dartup_server_test;

usersTest() => group("Users", (){
  MockGitHub gitHub;
  DataStore dataStore;
  Users users;

  setUp((){
    gitHub = new MockGitHub();
    dataStore = new LocalDataStore();
    users = new Users(gitHub,dataStore);
  });

  tearDown((){
    gitHub = null;
    dataStore = null;
    users = null;
  });

  test("Simple user get",(){
    dataStore.set("dartup_users", {"id": 1,"access_token": "testToken", "email": "test@exsampel.com", "active": true});
    return users.fromAccessToken("testToken").then((User user){
      expect(user,isNotEmpty);
      expect(user.id, 1);
      expect(user.email, "test@exsampel.com");
      expect(user.active, isTrue);
    });
  });

  test("Simple returns empty user if not found by defult",(){
    return users.fromAccessToken("testToken").then((User user){
      expect(user,isEmpty);
    });
  });

  test("Create new if createIfMissing is true",(){
    gitHub.when(callsTo("user")).alwaysCall((token){
      return new Future.sync((){
        expect(token,"testToken");
        return {"id": 1, "email": "test@exsampel.com"};
      });
    });

    return users.fromAccessToken("testToken", createIfMissing: true).then((User user){
      // test user;
      expect(user,isNotEmpty);
      expect(user.id, 1);
      expect(user.email, "test@exsampel.com");
      expect(user.active, isFalse);

      // test data
      return dataStore.get("dartup_users","id",1).then((Map json){
        expect(json["created_time"],isNotNull);
        expect(json["access_token"],"testToken");
      });
    });
  });

  test("Update data if createIfMissing is true",(){
    // add some stale data to the data store.
    dataStore.set("dartup_users", {"id": 1,"access_token": "oldTestToken", "email": "old_test@exsampel.com", "active": true});

    // setup GitHub mock to return new data for same id;
    gitHub.when(callsTo("user")).alwaysCall((token){
      return new Future.sync((){
        expect(token,"testToken");
        return {"id": 1, "email": "test@exsampel.com"};
      });
    });

    return users.fromAccessToken("testToken", createIfMissing: true).then((User user){
      // test that user returned has the new email from GitHub.
      expect(user.email, "test@exsampel.com");
    });
  });
});