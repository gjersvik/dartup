library dartup_webpage;

import "dart:async";
import "dart:convert";
import "dart:html";

import "package:http/browser_client.dart";
import "package:http/http.dart" as http;

main(){
  readmore();
  
  var server = new Server();
  var auth = new Auth(window,server,Uri.base);
  querySelector("#signin_button").onClick.listen((_)=> auth.login());
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
  
  final Window _window;
  final Server _server;
  final Uri _base;
  
  Auth(this._window, this._server, this._base){
    _boolStream = onToken
        .map((s) => s.isNotEmpty)
        // this line is not a bug i am passing the function created by
        // dedupMaker not dedupMaker itself.
        .where(dedupMaker());
    
    // 1. get token from localStorage if its there.
    _window.localStorage.putIfAbsent("github_token", () => "");
    token = _window.localStorage["github_token"];
    
    if(!logedIn){
      //3. See if there is one-time code from github in the url.
      if(_base.queryParameters.containsKey('code')){
        // 4. extange the one-time code with a github acess code.
        // Using the secrets stored on the server.
        _server.getToken(_base.queryParameters['code'])
          .then((t) => token = t);
      }
    }
  }
  
  void login(){
    // 2. ask github to autetnicate this user.
    _server.getCinetId().then((clinetId){
      var query = {
        "client_id": clinetId,
        "redirect_uri": _base.toString(),
        "scope": "user:email"
      };
      var uri = new Uri.https("github.com", "/login/oauth/authorize",query);
      window.location.assign(uri.toString());
    });
  }
  
  void logout(){
    token = "";
  }
  
  String get token => _token;
  set token(String t){
    if(_token == t){
      return;
    }
    _token = t;
    _window.localStorage["github_token"] = t;
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
  final client = new BrowserClient();
  
  Future<String> ping() {
    return client.get(serveUrl + "/ping").then((res) => res.body);
  }
  
  Future<String> getToken(String code){
    var req = new http.Request("POST",Uri.parse(serveUrl + "/getToken"));
    req.body = JSON.encode({"code":code});
    req.headers["Content-Type"] = "application/json";
    return client.send(req)
        .then((res) => UTF8.decodeStream(res.stream));
  }
  
  Future<String> getCinetId(){
    return client.get(serveUrl + "/getClientId").then((res) => res.body);
  }
}