import 'dart:async';
import 'package:dartserver/src/request/request.dart';
import 'package:dartserver/src/response/responses.dart';
import 'package:dartserver/src/server/server_plugin.dart';

abstract class IHttpRequestMiddleware implements IServerPlugIn {
  ///
  /// if handle return [HttpResult] object then the  entire request pipeline will be short circuited
  /// to move control to next middleware in request pipile you must return null
  FutureOr<HttpResult?> onRequest(RequestContext ctx);
}
