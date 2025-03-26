import 'package:dartserver/dartserver.dart';
import 'package:dartserver/src/server/server_plugin.dart';

abstract class IRouter {
  Route get(String path, RequestHandler handler);
  Route post(String path, RequestHandler handler);
  Route put(String path, RequestHandler handler);
  Route delete(String path, RequestHandler handler);
  Route patch(String path, RequestHandler handler);
  Route all(String path, RequestHandler handler);
  void group(String prefix, Router childRouter);
  Router use(IServerPlugIn middleware);
}
