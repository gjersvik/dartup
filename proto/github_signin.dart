library dartup_prototype_github_signin;

import "dart:html";

import "package:dartup/secret.dart" as secret;

main(){
  var button = querySelector("#signin");
  
  // 1. redirect browser to get code.
  button.onClick.listen((_){
    
    var req = {
               "client_id": secret.githubClinetId,
               "redirect_uri": "http://localhost:8080/github_signin.html",
               "scope": "user:email"
               
    };
    var uri = new Uri.https("github.com", "/login/oauth/authorize",req);
    
    window.location.assign(uri.toString());
  });
  
  // 2. Use code to get acesskey
  if(Uri.base.queryParameters.containsKey('code')){
    button.hidden = true;
    var data = {
               "client_id": secret.githubClinetId,
               "client_secret": secret.githubClinetSecret,
               "code": Uri.base.queryParameters['code']
    };
    var formencode = new Uri(queryParameters: data).query;
    HttpRequest.requestCrossOrigin("https://github.com/login/oauth/access_token", method: "POST", sendData: formencode)
    .then(print);
  }
}