part of dartup_client;

abstract class Location{
  Uri get currentUri;
  void redirect(Uri location);
}