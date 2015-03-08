part of dartup_controll;

typedef Future<bool> AuthFunction(String token);
typedef Set<String> AnonymousAccess();

class AuthManager{
  final Set<String> anonymousAccess
    = new Set.from(["/ping","/getToken","/getClientId"]);
  
  final String clientId = Platform.environment['GITHUB_ID'];
  final String clientSecret = Platform.environment['GITHUB_SECRET'];
  
  AuthManager();
  
  Future<bool> auth(String token){
    return new Future.value(false);
  }
  
  interceptor(){
    // test for path that can be accessed anonimusly 
    if(anonymousAccess.contains(app.request.url.path)){
      app.chain.next();
      return;
    }
    
    auth(app.request.headers["Authentication"]).then((accepted){
      if(accepted){
        app.chain.next();
      }else{
        app.chain.interrupt(statusCode: HttpStatus.FORBIDDEN);
      }
    }).catchError((e){
      app.chain.interrupt(statusCode: HttpStatus.INTERNAL_SERVER_ERROR, responseValue: e);
    });
  }
  
  String getClientId() => clientId;
  
  Future<String> getToken(){
    var data = {
      "client_id": clientId,
      "client_secret": clientSecret,
      "code": app.request.queryParams["code"]
    };
    
    return http.post("https://github.com/login/oauth/access_token",body: data)
      .then((http.Response res){
        var map = Uri.splitQueryString(res.body);
        return map["access_token"];
      });
  }
}

@app.Interceptor(r"/.*")
authInterceptor(AuthManager auth) => auth.interceptor();

@app.Route("/getToken")
authGetToken(@app.Inject() AuthManager auth) => auth.getToken();

@app.Route("/getClientId")
authGetClientId(@app.Inject() AuthManager auth) => auth.getClientId();