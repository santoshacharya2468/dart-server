import 'package:dartserver/dartserver.dart';

import 'package:dartserver/src/response/http_response.dart';

Router authRouter() {
  final authRouter = Router();
  authRouter.post('/login', (context) async {
    final body = await context.jsonBody;
    final username = body["username"];
    final password = body["password"];
    if (username == "admin" && password == "admin") {
      return HttpResult.json({"message": "Login successful"});
    }
    return HttpResult.unauthorized({"message": "Invalid credentials"});
  });
  authRouter.post('/register', (context) async {
    final body = await context.jsonBody;
    final username = body["username"];
    final password = body["password"];
    if (username == "admin" && password == "admin") {
      return HttpResult.json({"message": "Registration successful"});
    }
    return HttpResult.unauthorized({"message": "Invalid credentials"});
  });

  return authRouter;
}
