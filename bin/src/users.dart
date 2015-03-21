part of dartup_server;

class Users{
  final Github _gitHub;
  final DataStore _db;
  
  Users(this._gitHub, this._db);

  /// get [User] based on GitHub access token.
  ///
  /// For the basic call will only do a quick test of the database. Should be
  /// used in most cases.
  /// 
  /// If the [createIfMissing] is set to true and the user
  /// is not found this function will call GitHub to get user info to
  /// create/update local info as needed. This is a much slower process.
  ///
  /// Will return an empty user if user is not found.
  Future<User> fromAccessToken(String token, {bool createIfMissing: false}) async {
    // TODO Unit test me!!!
    // 1. Check if user is in DynamoDB and return if found.
    var user = new User.fromJson(await _db.get("dartup_users", "access_token", token));
    if(user.isNotEmpty || !createIfMissing){
      return user;
    }

    // 2. If create is true make a call to GitHub to get user info.
    var gitHubUser = await _gitHub.user(token);

    // 3. Make a new query to DynamoDB to se if user already exist with an old
    // access token
    Map dbUser = await _db.get("dartup_users", "id", gitHubUser["id"]);

    if(dbUser.isEmpty){
      // 4a. Create new user record.
      dbUser["id"] = gitHubUser["id"];
      dbUser["email"] = gitHubUser["email"];
      dbUser["access_token"] = token;
      dbUser["active"] = false;
      dbUser["created_time"] = new DateTime.now().toUtc().toIso8601String();

    }else{
      // 4b. Update user record.
      dbUser["email"] = gitHubUser["email"];
      dbUser["access_token"] = token;
    }
    await _db.set("dartup_users",dbUser);
    user = new User.fromJson(dbUser);

    // 5. If everything went well return new/updated user.
    return user;
  }

}