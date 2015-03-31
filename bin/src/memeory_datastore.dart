part of dartup_server;

/// Base class for data storage
///
/// This baseclass implmenets an inmemeory store witout persistentce.
class MemeoryDataStore implements DataStore {
  Map<String, List<Map>> _data = {};

  final String _defaultPrimaryKey;
  final Map<String, String> _primaryKeys;
  
  
  MemeoryDataStore({defaultPrimaryKey: "id", primaryKeys: const {}})
      : _defaultPrimaryKey = defaultPrimaryKey,
        _primaryKeys = primaryKeys;

  /// get the first item that have a [key] with the value [value]
  ///
  /// Returns empty map if no object is found, or throws a DataStoreException.
  Future<Map> get(String container, String key, value) async {
    if (!_data.containsKey(container)) {
      _data[container] = [];
    }
    return _data[container].firstWhere(
        (Map json) => json.containsKey(key) && json[key] == value,
        orElse: () => {});
  }

  /// sets an item to the [container]. If ther exist an old object with the
  /// same primaryKey it will be overwritten.
  ///
  /// Returns a future that complest when the item is safely stored. What
  /// safely mean is up to the implmenation of DataStore
  ///
  /// Throws an DataStoreException on underlying failure.
  /// Throws ArgumentError on malformed data.
  Future<Map> set(String container, Map jsonItem) async {
    var primaryKey = _defaultPrimaryKey;
    if(_primaryKeys.containsKey(container)){
      primaryKey = _primaryKeys[container];
    }
    
    //HACK Validate json by trying to convert it onto a Json String.
    JSON.encode(jsonItem);
    
    if (!jsonItem.containsKey(primaryKey)) {
      throw new ArgumentError.value(
          jsonItem, "jsonItem", "Needs to be a Map with the key '$primaryKey' set.");
    }
    if (!_data.containsKey(container)) {
      _data[container] = [];
    }
    _data[container]
        .removeWhere((Map item) => item[primaryKey] == jsonItem[primaryKey]);
    _data[container].add(jsonItem);
    return jsonItem;
  }
}
