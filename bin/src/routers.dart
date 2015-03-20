part of dartup_server;

final Set<String> noAuth = new Set.from(["/ping","/getToken","/getClientId"]);

@app.Route("/ping")
pingRouter()=>'pong';

@app.Route("/ping/auth")
authPingRouter()=>'pong';

@app.Route("/getToken",methods: const [app.POST])
getTokenRouter(@app.Inject() Auth auth, @app.Body(app.JSON) Map code)
  => auth.getToken(code["code"]);

@app.Route("/getClientId")
getClientIdRouter(@app.Inject() Auth auth) => auth.clientId;

@app.Route("/user")
userRouter() => null;
