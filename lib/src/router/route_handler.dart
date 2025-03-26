import 'dart:async';

import 'package:dartserver/dartserver.dart';
import 'package:dartserver/src/response/http_response.dart';

typedef RequestHandler = FutureOr<HttpResult> Function(
  RequestContext context,
);
