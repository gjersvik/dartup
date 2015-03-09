part of dartup_controll;

@app.Route("/ping")
pingRouter()=>'pong';

@app.Route("/ping/auth")
authPingRouter()=>'pong';

@app.Route("/getToken")
authGetToken(@app.Inject() Auth auth) => auth.getToken();

@app.Route("/getClientId")
authGetClientId(@app.Inject() Auth auth) => auth.getClientId();

@app.Route("/user")
userRouter() => null;
