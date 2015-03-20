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
  
  test("dynamoToJson String",(){
    expect(datastore.dynamoToJson({"S": "testString"}), "testString");
  });
  
  test("dynamoToJson Number",(){
    expect(datastore.dynamoToJson({"N": "1"}), 1);
    expect(datastore.dynamoToJson({"N": "-1"}), -1);
    expect(datastore.dynamoToJson({"N": "-1.2"}), -1.2);
  });
  
  test("dynamoToJson Booleans",(){
    expect(datastore.dynamoToJson({"BOOL": "true"}), true);
    expect(datastore.dynamoToJson({"BOOL": "false"}), false);
  });
  
  test("dynamoToJson Null",(){
    expect(datastore.dynamoToJson({"NULL": "true"}), null);
  });
  
  test("dynamoToJson Map",(){
    expect(datastore.dynamoToJson({"M": {"testKey":{"S": "testValue"}}}), {"testKey":"testValue"});
  });
  
  test("dynamoToJson List",(){
    expect(datastore.dynamoToJson({"L": [{"S": "testString"}]}), ['testString']);
  });

  test("dynamoToJson recursive",(){
    var dynamo = {"M":{
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
    
    var out = {
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
    
    expect(datastore.dynamoToJson(dynamo), out);
  });
  
  test("dynamoToJson error",(){
    expect(() => datastore.dynamoToJson({"SS":["1","2"]}), throwsException);
  });
  
  test("jsonToDynamo String",(){
    expect(datastore.jsonToDynamo("testString"), {"S": "testString"});
  });
  
  test("jsonToDynamo Numbers",(){
    expect(datastore.jsonToDynamo(1), {"N": "1"});
    expect(datastore.jsonToDynamo(-1), {"N": "-1"});
    expect(datastore.jsonToDynamo(-1.2), {"N": "-1.2"});
  });
  
  test("jsonToDynamo Booleans",(){
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
  
  test("jsonToDynamo error",(){
    expect(() => datastore.jsonToDynamo(datastore), throwsException);
  });
});