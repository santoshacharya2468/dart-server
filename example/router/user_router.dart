import 'package:dartserver/dartserver.dart';
import 'package:dartserver/src/response/http_response.dart';
import 'package:postgres/postgres.dart';
import '../main.dart';
import '../middlewares/auth_middleware.dart';

class User {
  final int id;
  final String username;
  final String password;
  final String? avatar;
  User(this.id, this.username, this.password, this.avatar);
  factory User.fromResultRow(ResultRow row) {
    return User(
        row[0] as int, row[1] as String, row[2] as String, row[3] as String?);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "avatar": avatar
    };
  }
}

Router userRouter() {
  final userRouter = Router().use(AuthMiddleware());
  userRouter.get('/', (context) async {
    final db = getIt<Pool<dynamic>>();
    final result = await db.execute("SELECT * FROM users");
    final users = result.map(User.fromResultRow).toList();
    return HttpResult.json({"users": users.map((e) => e.toJson()).toList()});
  });
  // userRouter.get(
  //     '/:id',
  //     (context) => HttpResult.json(users
  //             .firstWhereOrNull(
  //                 (element) => element.id == context.pathParamInt("id"))
  //             ?.toJson() ??
  //         {"message": "User not found"}));

  // userRouter.post('/', (RequestContext context) async {
  //   final user = await context.bodyJson(User.fromJson);
  //   users.add(user);
  //   return HttpResult.json(user.toJson()).status(201);
  // });
  // userRouter.put('/:id', (RequestContext context) async {
  //   final user = await context.bodyJson(User.fromJson);
  //   final index = users.indexWhere((element) => element.id == user.id);
  //   if (index == -1) {
  //     return HttpResult.notFound();
  //   }
  //   users[index] = user;
  //   return HttpResult.json(user.toJson());
  // });
  // userRouter.delete('/:id', (RequestContext context) {
  //   final id = context.pathParamInt("id");
  //   final index = users.indexWhere((element) => element.id == id);
  //   if (index == -1) {
  //     throw AppError(message: "user record not found");
  //   }
  //   users.removeAt(index);
  //   return HttpResult.json({"message": "User deleted"}).status(204);
  // }).use(IsAuthAdminMiddleware());
  return userRouter;
}
