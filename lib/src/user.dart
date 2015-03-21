part of dartup_common;

class User{
  int id = 0;
  String email = "";
  bool active = false;

  User();

  User.fromJson(Map json){
    id = json["id"];
    email = json["email"];
    active = json["active"];
  }

  //TODO Unit Test Me
  bool get isEmpty => id == 0;
  //TODO and Me
  bool get isNotEmpty => id != 0;

  Map toJson(){
    return {
      "id": id,
      "email": email,
      "active": active
    };
  }

  String toString() => "User(id:$id, email:$email, active:$active)";
}