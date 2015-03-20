part of dartup_server_test;

class MockDynamoDb extends Mock implements DynamoDb{
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

datastoreTest() => group("Datastore",(){
  Datastore datastore;
  MockDynamoDb mock;
  
  setUp((){
    mock = new MockDynamoDb();
    datastore = new Datastore(mock);
  });
  
  tearDown((){
    mock = null;
    datastore = null;
  });
  
  test("jsonToDynamo String",(){
    expect(datastore.jsonToDynamo("testString"), {"S": "testString"});
  });
  
  test("jsonToDynamo Numbers",(){
    expect(datastore.jsonToDynamo(1), {"N": "1"});
    expect(datastore.jsonToDynamo(-1), {"N": "-1"});
    expect(datastore.jsonToDynamo(-1.2), {"N": "-1.2"});
  });
  
  test("jsonToDynamo booleans",(){
    expect(datastore.jsonToDynamo(true), {"BOOL": "true"});
    expect(datastore.jsonToDynamo(false), {"BOOL": "false"});
  });
  
  test("jsonToDynamo null",(){
    expect(datastore.jsonToDynamo(null), {"NULL": "true"});
  });
  
  test("jsonToDynamo Map",(){
    expect(datastore.jsonToDynamo({"testKey":"testValue"}), {"M": {"testKey":{"S": "testValue"}}});
  });
  
  test("jsonToDynamo List",(){
    expect(datastore.jsonToDynamo(["testString"]), {"L": [{"S": "testString"}]});
  });

  test("jsonToDynamo recursive",(){
    var json = {
      "map": {
        "num": 42,
        "list": [
          true,
          false,
          {},
          []
        ]
      }
    };
    
    var out = {"M":{
      "map": {"M":{
        "num": {"N": "42"},
        "list": {"L": [
          {"BOOL": "true"},
          {"BOOL": "false"},
          {"M": {}},
          {"L": []},
        ]}
      }}
    }};
    
    expect(datastore.jsonToDynamo(json), out);
  });
});