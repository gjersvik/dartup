part of dartup_server;

final Set<String> noAuth = new Set.from(["/config","/signin"]);

@app.Route("/config")
configRouter(@app.Inject() GitHub gitHub){
  return {
    "GitHubClientId": gitHub.clientId
  };
}

@app.Route("/signin",methods: const [app.POST])
getTokenRouter(@app.Inject() Auth auth, @app.Body(app.JSON) Map code)
  => auth.signin(code["code"]);

@app.Route("/user")
userRouter(@app.Inject() Users users){
  return users.fromAccessToken(app.request.headers["Authentication"]);
}
