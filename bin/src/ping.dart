part of dartup_controll;

@app.Route("/ping")
ping()=>'pong';

@app.Route("/ping/auth")
authPing()=>'pong';