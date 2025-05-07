import "package:contact_app1/features/user/data/models/user_model.dart";
import "package:dio/dio.dart";
import "package:retrofit/error_logger.dart";
import "package:retrofit/http.dart";

part 'users_service.g.dart';

@RestApi(baseUrl: "https://ms.itmd-b1.com:5123/")
abstract class UsersService {
  factory UsersService(Dio dio, {String baseUrl}) = _UsersService;

  @GET('api/Users')
  Future<List<UserModel>> getUserDetails(@Header('Authorization') String token);

  @POST('api/Users')
  Future<UserModel> createUser(
    @Header('Authorization') String token,
    @Body() UserModel newUser,
  );

  @DELETE('api/Users')
  Future<void> deleteAllUsers(
    @Header('Authorization') String token,
    @Header('Content-Type') String contentType, 
  );

 @DELETE('api/Users/{id}')
Future<void> deleteOneUser(
  @Path("id") String id, 
  @Header('Authorization') String token,
);

@GET('api/Users/{id}')
Future<UserModel> getOneUser(
  @Path("id") String id,
  @Header('Authorization') String token,
);

@PUT('api/Users/{id}')
Future<UserModel> userUpdate(
  @Path("id") String id, 
  @Header('Authorization') String token,
  @Body() UserModel updatedUser,
);
}
 