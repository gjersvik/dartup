part of dartup_common_test;

user_test() => group("User", (){
  test("fromJson",(){
    var json = {
      "id": 1234,
      "email": "test@exsample.com",
      "active": false,
      "someGrabase": "wvoqintw"
    };
    var user = new User.fromJson(json);
    expect(1234,user.id);
    expect("test@exsample.com", user.email);
    expect(false,user.active);
  });

  test("toJson",(){
    var user = new User();
    user.id = 1234;
    user.email = "test@exsample.com";
    user.active = false;

    var json = {
        "id": 1234,
        "email": "test@exsample.com",
        "active": false
    };

    expect(json, user.toJson());
  });

  test("toString", (){
    var user = new User();
    user.id = 1234;
    user.email = "test@exsample.com";
    user.active = false;

    expect("User(id:1234, email:test@exsample.com, active:false)",user.toString());
  });
});