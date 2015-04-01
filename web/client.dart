library dartup_client_runner;

import "dart:html";

import "client_lib.dart";
import "wrappers/location_wrapper.dart";

main(){
  readmore();
  
  var server = new Server();
  var auth = new Auth(new LocationWrapper(), server, window);
  querySelector("#signin_button").onClick.listen((_)=> auth.login());
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
