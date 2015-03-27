library dartup_clinet_wrapper_request;

import "dart:async";
import "dart:convert";
import "dart:html";

Future<Map> requestWrapper(String method, String uri,
    {Map<String, String> headers: const{}, Map json: null}) async {
  var positional = [uri];
  var named = {
    method: method
  };
  if(json != null){
    named["responseType"] = "json";
    named["mimeType"] = "application/json";
    named["sendData"] = JSON.encode(json);
  }
  if(headers.isNotEmpty){
    named["requestHeaders"] = headers;
  }
  var reg = await Function.apply(HttpRequest.request, positional, named);
  var body = reg.responseText;
  if (body.isNotEmpty) {
    return JSON.decode(body);
  } else {
    return {};
  }
}
