library dartup_server_wrapper_github;

import "dart:async";
import "dart:io";

import "package:github/server.dart";
import "package:http/http.dart";

import "../server_lib.dart";

class GithubWrapper extends Github{
  String clientId = Platform.environment["GITHUB_ID"];
  
  String _clientSecret = Platform.environment["GITHUB_SECRET"];
  
  Future<Map> auth(String code){
    return new Future.sync((){
      var data = {
        "client_id": clientId,
        "client_secret": _clientSecret,
        "code": code
      };
      return post("https://github.com/login/oauth/access_token",body: data);
    }).then((Response res) => Uri.splitQueryString(res.body));
  }
  
  Future<Map> user(String token){
    return new Future.sync((){
      var github = createGitHubClient(auth: new Authentication.withToken(token));
      return github.users.getCurrentUser();
    }).then((CurrentUser user){
      return {
        "id": user.id,
        "email": user.email
      };
    });
  }
}