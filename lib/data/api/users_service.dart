import "package:contact_app1/data/models/users.dart";
import "package:dio/dio.dart";
import "package:retrofit/http.dart";

part 'users_service.g.dart';

@RestApi(baseUrl: "https://ms.itmd-b1.com:5123/")
abstract class UsersService {
  factory UsersService(Dio dio, {String baseUrl}) = _UsersService;

  @GET('api/Users')
  Future<List<User>> getUserDetails(@Header('Authorization') String token);

  @POST('api/Users')
  Future<User> createUser(
    @Header('Authorization') String token,
    @Body() User newUser,
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
Future<User> getOneUser(
  @Path("id") String id,
  @Header('Authorization') String token,
);

@PUT('api/Users/{id}')
Future<User> userUpdate(
  @Path("id") String id, 
  @Header('Authorization') String token,
  @Body() User updatedUser,
);
}
 