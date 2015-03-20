part of dartup_controll;

class Users{

  Future<User> fromAccessToken(String token, {bool createIfMissing: false}){
    // 1. Check if user is in DynamoDB and return if found.

    // 2. If create is true make a call to github to get user info.

    // 3. Make a new query to DynamoDB to se if user already exist with an old
    // access token

    // 4. Update or create new record as needed.

    // 5. If everything went well return new/updated user.
    return new Future.error('NOT Implmented');
  }

}