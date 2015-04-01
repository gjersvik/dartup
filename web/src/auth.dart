part of dartup_client;

class Auth{
  StreamController<String> _tokenController = new StreamController.broadcast();
  Stream<bool> _boolStream;
  String _token;
  
  final Location _location;
  final Server _server;
  final Window _window;
  
  Auth(this._location, this._server, this._window){
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
      if(_location.currentUri.queryParameters.containsKey('code')){
        // 4. extange the one-time code with a github acess code.
        // Using the secrets stored on the server.
        _server.getToken(_location.currentUri.queryParameters['code'])
          .then((t) => token = t);
      }
    }
  }
  
  void login(){
    // 2. ask github to autetnicate this user.
    _server.getCinetId().then((clinetId){
      var query = {
        "client_id": clinetId,
        "redirect_uri": _location.currentUri.toString(),
        "scope": "user:email"
      };
      var uri = new Uri.https("github.com", "/login/oauth/authorize",query);
      _location.redirect(uri);
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
