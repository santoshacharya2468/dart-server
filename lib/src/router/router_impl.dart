import 'package:dartserver/src/server/server_plugin.dart';

import '../../dartserver.dart';
import 'http_method.dart';
import 'i_router.dart';

class Router implements IRouter {
  String? prefix;
  final List<Route> _routes = [];
  final List<IServerPlugIn> _plugins = [];
  Router({this.prefix});
  List<Route> get routes => _routes;
  Route _addRoute(Route route) {
    final path = route.path;
    final fullPath = prefix != null ? '$prefix$path' : path;
    route.path = fullPath;
    route.plugIns = [..._plugins];
    final alreadyExist = _routes.any((element) =>
        element.path == route.path && element.method == route.method);
    if (alreadyExist) {
      throw Exception("Duplicate route: ${route.method.name} ${route.path}");
    }
    _routes.add(route);
    return route;
  }

  @override
  Route get(String path, RequestHandler handler) {
    return _addRoute(
        Route(path: path, handler: handler, method: HttpMethod.get));
  }

  @override
  Route all(String path, RequestHandler handler) {
    return _addRoute(
        Route(path: path, handler: handler, method: HttpMethod.all));
  }

  @override
  Route delete(String path, RequestHandler handler) {
    return _addRoute(
        Route(path: path, handler: handler, method: HttpMethod.delete));
  }

  @override
  void group(String groupPrefix, Router childRouter) {
    childRouter.prefix =
        "${prefix ?? ''}$groupPrefix${childRouter.prefix ?? ''}";
    for (var route in childRouter.routes) {
      final newRoute = Route(
        method: route.method,
        path: '${childRouter.prefix ?? ''}${route.path}',
        handler: route.handler,
      );
      final routeMiddlewares = route.plugIns ?? [];
      newRoute.plugIns = [];
      //top router -> child router -> individual router level middleware
      newRoute.plugIns
          ?.addAll([..._plugins, ...childRouter._plugins, ...routeMiddlewares]);
      _routes.add(newRoute);
    }
  }

  @override
  Router use(IServerPlugIn plugIn) {
    _plugins.add(plugIn);
    return this;
  }

  @override
  Route patch(String path, RequestHandler handler) {
    return _addRoute(
        Route(path: path, handler: handler, method: HttpMethod.patch));
  }

  @override
  Route post(String path, RequestHandler handler) {
    return _addRoute(
        Route(path: path, handler: handler, method: HttpMethod.post));
  }

  @override
  Route put(String path, RequestHandler handler) {
    return _addRoute(
        Route(path: path, handler: handler, method: HttpMethod.put));
  }
}
