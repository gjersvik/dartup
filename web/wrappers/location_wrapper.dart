library dartup_clinet_wrapper_location;

import "dart:html" hide Location;

import "../client_lib.dart";

class LocationWrapper extends Location{
  
  // TODO: implement currentUri
  @override
  Uri get currentUri => Uri.base;

  @override
  void redirect(Uri location) {
    window.location.href = location.toString();
  }
}