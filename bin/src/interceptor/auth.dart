part of dartup_controll;

@app.Interceptor(r"/.*")
authInterceptor(@app.Inject() AuthFunction tester){
  // test for path that can be accessed anonimusly 
  if(app.request.url.path == "/ping" || app.request.url.path == "/getAuth"){
    app.chain.next();
    return;
  }
  
  var auth = app.request.headers["Authentication"];
  tester(auth).then((accepted){
    if(accepted){
      app.chain.next();
    }else{
      app.chain.interrupt(statusCode: HttpStatus.FORBIDDEN);
    }
  }).catchError((e){
    app.chain.interrupt(statusCode: HttpStatus.INTERNAL_SERVER_ERROR, responseValue: e);
  });
}