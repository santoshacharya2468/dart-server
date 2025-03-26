import 'package:dartserver/dartserver.dart';
import 'package:get_it/get_it.dart';
import 'package:postgres/postgres.dart';
import 'exceptions/app_error_filter.dart';
import 'router/auth_router.dart';
import 'router/user_router.dart';
import 'package:dartserver/src/response/http_response.dart';

GetIt getIt = GetIt.instance;
Future<void> _setupDI() async {
  final dbCon = Pool.withEndpoints([
    Endpoint(
        host: "localhost",
        database: "dartdb",
        port: 5432,
        username: "postgres",
        password: "manakamana")
  ],
      settings: PoolSettings(
        sslMode: SslMode.disable,
      ));

  getIt.registerSingleton<Pool<dynamic>>(dbCon);
}

void main() async {
  await _setupDI();
  final app = Router(prefix: "/api").use(AppExceptionFilter());
  app.get("/health",
      (context) => HttpResult.json({"time": DateTime.now().toString()}));
  app.group("/users", userRouter());
  app.group("/auth", authRouter());
  await DartleServer().start(router: app, port: 3000);
}
