import 'dart:async';
import 'package:dartserver/src/request/request.dart';
import 'package:dartserver/src/server/server_plugin.dart';

abstract class IHttpRequestMiddleware implements IServerPlugIn {
  /// return true if the request is handled, false if the next middleware should be called
  FutureOr<bool> handle(RequestContext ctx);
}
