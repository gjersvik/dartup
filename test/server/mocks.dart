part of dartup_server_test;

class MockDynamoDb extends Mock implements DynamoDb{
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGitHub extends Mock implements GitHub{
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class LocalDataStore extends DataStore{
  String primaryKey = "id";
  Map<String,List<Map>> _data = {};

  LocalDataStore():super(new MockDynamoDb());

  Future<Map> get(String container, String key, value){
    return new Future.sync((){
      if(!_data.containsKey(container)){
        _data[container] = [];
      }
      return _data[container].firstWhere(
          (Map json) => json.containsKey(key) && json[key] == value,
          orElse: () => {});
    });
  }

  Future set(String container, Map jsonItem){
    return new Future.sync((){
      if(!jsonItem.containsKey(primaryKey)) {
        throw new ArgumentError.value(jsonItem,"jsonItem","Needs to be a Map '$primaryKey' set.");
      }
      if(!_data.containsKey(container)){
        _data[container] = [];
      }
      _data[container].removeWhere((Map item) => item[primaryKey] == jsonItem[primaryKey]);
      _data[container].add(jsonItem);
    });
  }

}