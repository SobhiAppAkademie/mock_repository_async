import 'package:mock_async_repo/features/login/schema/server_user_response.dart';

// Vorlage/Template User Repository
abstract class UserRepository {
  Future<ServerUserResponse?> loginAndGetUser(String email, String password);
}
