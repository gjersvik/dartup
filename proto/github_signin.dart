library dartup_prototype_github_signin;

import "dart:html";

import "package:dartup/secret.dart" as secret;

main(){
  print(window.location.search);
  
  querySelector("#signin").onClick.listen((_){
    
    var req = {
               "client_id": secret.githubClinetId,
               "redirect_uri": "http://localhost:8080/github_signin.html",
               "scope": "user:email"
               
    };
    var uri = new Uri.https("github.com", "/login/oauth/authorize",req);
    
    window.location.assign(uri.toString());
  });
}