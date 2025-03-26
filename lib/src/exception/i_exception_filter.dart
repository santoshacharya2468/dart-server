import 'dart:async';

import 'package:dartserver/dartserver.dart';
import 'package:dartserver/src/response/responses.dart';
import 'package:dartserver/src/server/server_plugin.dart';

abstract class IExceptionFilter implements IServerPlugIn {
  //method must return HttpResult if its handled within the filter else return null to forward exeception to next handler
  FutureOr<HttpResult?> onException(RequestContext context, Exception e);
}
