library dartup_webpage;

import "dart:async";
import "dart:html";

import "package:dartup/github_client_id.dart";

main(){
  readmore();
  
  var server = new Server();
  server.ping().then(print);
}

readmore(){
  querySelectorAll('.readmore').onClick.listen((MouseEvent e){
    if(e.button == 0){ 
      Element aticle = (e.target as Element).parent;
      aticle.querySelector(".long").classes.toggle('hidden');
      e.preventDefault();
      e.stopPropagation();
    }
  });
}

class Auth{
  StreamController<String> _tokenController = new StreamController.broadcast();
  Stream<bool> _boolStream;
  String _token;
  
  Auth(){
    _boolStream = onToken
        .map((s) => s.isNotEmpty)
        // this line is not a bug i am passing the function created by
        // dedupMaker not dedupMaker itself.
        .where(dedupMaker());
    
    // 1. Check if we have github_token in local storage
    if(window.localStorage.containsKey("github_token")){
      token = window.localStorage["github_token"];
      return;
    }else{
      token = "";
    }
    
  }
  
  String get token => _token;
  set token(String t){
    if(_token == t){
      return;
    }
    _token = t;
    _tokenController.add(t);
  }
  Stream<String> get onToken => _tokenController.stream;
  
  bool get logedIn => token.isNotEmpty;
  Stream<bool> get onLogedInOut => _boolStream;
}

typedef bool Predicate(dynamic);

Predicate dedupMaker(){
  var last;
  return (v){
    if(v != last){
      last = v;
      return true; //dicard data.
    }
    return false; //dicard data.
  };
}

class Server{
  final String serveUrl = "http://localhost:8081";
  
  Future<String> ping() {
    return HttpRequest.getString(serveUrl + "/ping");
  }
}