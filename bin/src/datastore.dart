part of dartup_server;

/// Base class for data storage
///
/// This baseclass implmenets an inmemeory store witout persistentce.
abstract class DataStore {
  /// get the first item that have a [key] with the value [value]
  ///
  /// Returns empty map if no object is found, or throws a DataStoreException.
  Future<Map> get(String container, String key, value);

  /// sets an item to the [container]. If ther exist an old object with the
  /// same primaryKey it will be overwritten.
  ///
  /// Returns a future that complest when the item is safely stored. What
  /// safely mean is up to the implmenation of DataStore
  ///
  /// Throws an DataStoreException on underlying failure.
  /// Throws ArgumentError on malformed data.
  Future<Map> set(String container, Map jsonItem);
}

class DataStoreException implements Exception {}