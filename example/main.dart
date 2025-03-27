import 'package:dartserver/dartserver.dart';
import 'exceptions/app_error_filter.dart';
import 'router/auth_router.dart';
import 'router/user_router.dart';
import 'package:dartserver/src/response/http_response.dart';

void main() async {
  final app = Router(prefix: "/api").use(AppExceptionFilter());
  app.get("/health",
      (context) => HttpResult.json({"time": DateTime.now().toString()}));
  app.group("/users", userRouter());
  app.group("/auth", authRouter());
  await DartleServer().start(router: app, port: 3000);
}
