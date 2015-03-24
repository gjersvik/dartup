part of dartup_server;

final Set<String> noAuth = new Set.from(["/ping","/getToken","/getClientId"]);

@app.Route("/ping")
pingRouter()=>'pong';

@app.Route("/ping/auth")
authPingRouter()=>'pong';

@app.Route("/getToken",methods: const [app.POST])
getTokenRouter(@app.Inject() Auth auth, @app.Body(app.JSON) Map code)
  => auth.signin(code["code"]);

@app.Route("/getClientId")
getClientIdRouter(@app.Inject() GitHub gitHub) => gitHub.clientId;

@app.Route("/user")
userRouter() => null;
