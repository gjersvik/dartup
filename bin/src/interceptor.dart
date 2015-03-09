part of dartup_controll;

@app.Interceptor(r'/.*')
corsInterceptor() {
  if (app.request.method == "OPTIONS") {
    //overwrite the current response and interrupt the chain.
    app.response = new shelf.Response.ok(null, headers: _createCorsHeader());
    app.chain.interrupt();
  } else {
    //process the chain and wrap the response
    app.chain.next(() => app.response.change(headers: _createCorsHeader()));
  }
}

_createCorsHeader() => {
  "Access-Control-Allow-Origin": "http://localhost:8080",
  "Access-Control-Allow-Headers": "origin, content-type, accept"
};

@app.Interceptor(r"/.*")
authInterceptor(Auth auth){
  // test for path that can be accessed anonimusly 
  if(noAuth.contains(app.request.url.path)){
    app.chain.next();
    return;
  }
   
  auth.auth(app.request.headers["Authentication"]).then((accepted){
    if(accepted){
      app.chain.next();
    }else{
      app.chain.interrupt(statusCode: HttpStatus.FORBIDDEN);
    }
  }).catchError((e){
    app.chain.interrupt(statusCode: HttpStatus.INTERNAL_SERVER_ERROR, responseValue: e);
  });
}