part of dartup_common;

class User{
  int id;
  String email;
  bool active;

  User.fromJson(Map json){
    id = json["id"];
    email = json["email"];
    active = json["active"];
  }

  Map toJson(){
    return {
      "id": id,
      "email": email,
      "active": active
    };
  }

  String toString() => "User(id:$githubId, email:$email, active:$active)";
}