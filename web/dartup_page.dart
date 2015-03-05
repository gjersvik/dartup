library dartup_webpage;

import "dart:async";
import "dart:html";

import "package:dartup/github_client_id.dart";

main(){
  readmore();
  
  var server = new Server();
  server.ping().then(print);
}

readmore(){
  querySelectorAll('.readmore').onClick.listen((MouseEvent e){
    if(e.button == 0){ 
      Element aticle = (e.target as Element).parent;
      aticle.querySelector(".long").classes.toggle('hidden');
      e.preventDefault();
      e.stopPropagation();
    }
  });
}

class Server{
  final String serveUrl = "http://localhost:8081";
  
  Future<String> ping() {
    return HttpRequest.getString(serveUrl + "/ping");
  }
}