part of dartup_server_test;

dataStoreTest() => group("Datastore",(){
  DataStore dataStore;
  MockDynamoDb mock;
  
  setUp((){
    mock = new MockDynamoDb();
    dataStore = new DataStore(mock);
  });
  
  tearDown((){
    mock = null;
    dataStore = null;
  });
  
  test("get",(){
    mock.when(callsTo("getItem",anything,anything)).alwaysCall((table,key){
      return new Future.sync((){
        expect(table, "testTable");
        expect(key, {"name":{"S":"testName"}});
        return {"Item":{"name":{"S": "testName"}}};
      });
    });
    
    return dataStore.get("testTable", "name", "testName").then((json){
      expect(json,{"name":"testName"});
    });
  });
  
  test("set",(){
    mock.when(callsTo("putItem",anything,anything)).alwaysCall((table,item){
      return new Future.sync((){
        expect(table, "testTable");
        expect(item, {"name":{"S":"testName"}});
      });
    });
    
    return dataStore.set("testTable",{"name": "testName"});
  });
  
  
  test("dynamoToJson String",(){
    expect(dataStore.dynamoToJson({"S": "testString"}), "testString");
  });
  
  test("dynamoToJson Number",(){
    expect(dataStore.dynamoToJson({"N": "1"}), 1);
    expect(dataStore.dynamoToJson({"N": "-1"}), -1);
    expect(dataStore.dynamoToJson({"N": "-1.2"}), -1.2);
  });
  
  test("dynamoToJson Booleans",(){
    expect(dataStore.dynamoToJson({"BOOL": "true"}), true);
    expect(dataStore.dynamoToJson({"BOOL": "false"}), false);
  });
  
  test("dynamoToJson Null",(){
    expect(dataStore.dynamoToJson({"NULL": "true"}), null);
  });
  
  test("dynamoToJson Map",(){
    expect(dataStore.dynamoToJson({"M": {"testKey":{"S": "testValue"}}}), {"testKey":"testValue"});
  });
  
  test("dynamoToJson List",(){
    expect(dataStore.dynamoToJson({"L": [{"S": "testString"}]}), ['testString']);
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
    
    expect(dataStore.dynamoToJson(dynamo), out);
  });
  
  test("dynamoToJson error",(){
    expect(() => dataStore.dynamoToJson({"SS":["1","2"]}), throwsException);
  });
  
  test("jsonToDynamo String",(){
    expect(dataStore.jsonToDynamo("testString"), {"S": "testString"});
  });
  
  test("jsonToDynamo Numbers",(){
    expect(dataStore.jsonToDynamo(1), {"N": "1"});
    expect(dataStore.jsonToDynamo(-1), {"N": "-1"});
    expect(dataStore.jsonToDynamo(-1.2), {"N": "-1.2"});
  });
  
  test("jsonToDynamo Booleans",(){
    expect(dataStore.jsonToDynamo(true), {"BOOL": "true"});
    expect(dataStore.jsonToDynamo(false), {"BOOL": "false"});
  });
  
  test("jsonToDynamo null",(){
    expect(dataStore.jsonToDynamo(null), {"NULL": "true"});
  });
  
  test("jsonToDynamo Map",(){
    expect(dataStore.jsonToDynamo({"testKey":"testValue"}), {"M": {"testKey":{"S": "testValue"}}});
  });
  
  test("jsonToDynamo List",(){
    expect(dataStore.jsonToDynamo(["testString"]), {"L": [{"S": "testString"}]});
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
    
    expect(dataStore.jsonToDynamo(json), out);
  });
  
  test("jsonToDynamo error",(){
    expect(() => dataStore.jsonToDynamo(dataStore), throwsException);
  });
});