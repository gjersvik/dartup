part of dartup_controll;

class Auth{
  String _clientId;
  String _secret;
  
  http.Client _http;
  
  Auth(@EnvVars() Map env, http.Client this._http){
    _clientId = env["GITHUB_ID"];
    _secret = env["GITHUB_SECRET"];
  }
  
  String get clientId => _clientId;
  
  Future<bool> auth(String token){
    return new Future.value(false);
  }
  
  Future<String> getToken(String code){
    var data = {
      "client_id": _clientId,
      "client_secret": _secret,
      "code": code
    };
    
    return _http.post("https://github.com/login/oauth/access_token",body: data)
      .then((http.Response res){
        var map = Uri.splitQueryString(res.body);
        return map["access_token"];
      });
  }
}
