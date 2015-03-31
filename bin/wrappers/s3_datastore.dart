library dartup_server_s3_datastore;

import "dart:async";
import "dart:convert";
import "dart:io";

import "../server_lib.dart";

class S3DataStore implements DataStore{
  Future _loaded;
  Map<String, List<Map>> _data;
  
  final String _defaultPrimaryKey;
  final Map<String, String> _primaryKeys;
  
  S3DataStore({defaultPrimaryKey: "id", primaryKeys: const {}})
      : _defaultPrimaryKey = defaultPrimaryKey,
        _primaryKeys = primaryKeys{
        _loaded = _load().then((d) => _data = d);
  }
  
  Future<Map> get(String container, String key, value) async {
    await _loaded;
    if (_data.containsKey(container)) {
      return _data[container].firstWhere(
        (Map json) => json.containsKey(key) && json[key] == value,
        orElse: () => {});
    }
    return {};
  }
  
  Future<Map> set(String container, Map jsonItem) async {
    await _loaded;
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
    await _save();
    return jsonItem;
  }
  
  Future _load() async {
    var p = await Process.run("aws", ["s3", "cp", "s3://dartup/db/db.json", "-"]);
    if(p.stdout.isEmpty){
      return {};
    }
    return JSON.decode(p.stdout);
  }
  
  Future _save() async {
    var p = await Process.start("aws", ["s3", "cp", "-", "s3://dartup/db/db.json"]);
    p.stdin.writeln(JSON.encode(_data));
    p.stdin.close();
    return await p.exitCode;
  }
}