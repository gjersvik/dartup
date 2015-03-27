part of dartup_server;

class Auth{
  GitHub _github;
  Users _users;
  
  Auth(this._github, this._users);
  
  Future<bool> validToken(String token){
    return _users.fromAccessToken(token).then((User user)=> user.isNotEmpty);
  }
  
  Future<Map> signin(String code){
    return _github.auth(code).then((Map json){
      return _users.fromAccessToken(json["access_token"],createIfMissing: true)
      .then((User u){
        return {
          "oauth": json,
          "user": u.toJson()
        };
      });
    });
  }
}
