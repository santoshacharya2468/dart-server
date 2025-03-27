import 'package:dartserver/dartserver.dart';
import 'package:dartserver/src/response/http_response.dart';
import '../exceptions/app_error.dart';
import '../middlewares/auth_middleware.dart';

class User {
  final int id;
  final String username;
  final String password;
  final String? avatar;
  User(this.id, this.username, this.password, this.avatar);
  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["id"] as int, json["username"] as String,
        json["password"] as String, json["avatar"] as String?);
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

final users = [
  User(1, "santosh99", "manakamana", null),
  User(2, "rama99", "rama", null),
  User(3, "shishir", "shishir", null),
];

Router userRouter() {
  final userRouter = Router().use(AuthMiddleware());
  userRouter.get('/', (context) async {
    return HttpResult.json({"users": users.map((e) => e.toJson()).toList()});
  });
  userRouter.get(
      '/:id',
      (context) => HttpResult.json(users
              .firstWhereOrNull(
                  (element) => element.id == context.pathParamInt("id"))
              ?.toJson() ??
          {"message": "User not found"}));

  userRouter.post('/', (RequestContext context) async {
    final user = await context.bodyJson(User.fromJson);
    users.add(user);
    return HttpResult.json(user.toJson()).status(201);
  });
  userRouter.put('/:id', (RequestContext context) async {
    final user = await context.bodyJson(User.fromJson);
    final index = users.indexWhere((element) => element.id == user.id);
    if (index == -1) {
      return HttpResult.notFound();
    }
    users[index] = user;
    return HttpResult.json(user.toJson());
  });
  userRouter.delete('/:id', (RequestContext context) {
    final id = context.pathParamInt("id");
    final index = users.indexWhere((element) => element.id == id);
    if (index == -1) {
      throw AppError(message: "user record not found");
    }
    users.removeAt(index);
    return HttpResult.json({"message": "User deleted"}).status(204);
  }).use(IsAuthAdminMiddleware());
  return userRouter;
}
