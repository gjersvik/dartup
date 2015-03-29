part of dartup_client;

class Server{
  final String serveUrl = "http://localhost:8081";
  final client = new BrowserClient();
  
  Future<String> ping() {
    return client.get(serveUrl + "/ping").then((res) => res.body);
  }
  
  Future<String> getToken(String code){
    var req = new http.Request("POST",Uri.parse(serveUrl + "/signin"));
    req.body = JSON.encode({"code":code});
    req.headers["Content-Type"] = "application/json";
    return client.send(req)
        .then((res) => UTF8.decodeStream(res.stream))
        .then(JSON.encode)
        .then((json) => json["oauth"]["access_token"]);
  }
  
  Future<String> getCinetId(){
    return client.get(serveUrl + "/config").then((http.Response res) => JSON.decode(res.body)["GitHubClientId"]);
  }
}
