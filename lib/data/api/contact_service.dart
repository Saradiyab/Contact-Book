import 'dart:io';
import 'package:contact_app1/data/models/send_email.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../models/contact.dart';
part 'contact_service.g.dart';

@RestApi(baseUrl: 'https://ms.itmd-b1.com:5123/')
abstract class ContactService {
  factory ContactService(Dio dio, {String baseUrl}) = _ContactService;

  @GET('api/Contacts')
  Future<List<Contact>> fetchContact(@Header('Authorization') String token);

  @POST('api/Contacts')
  @MultiPart()
  Future<Contact> createContact(
    @Header('Authorization') String token,
    @Part(name: 'firstName') String firstName,
    @Part(name: 'lastName') String lastName,
    @Part(name: 'email') String email,
    @Part(name: 'phoneNumber') String phoneNumber,
    @Part(name: 'address') String address,
    @Part(name: 'isFavorite') bool isFavorite,
    @Part(name: 'status') String status,
    @Part(name: 'ImageUploadFile') File? image,
    @Part(name: 'emailTwo') String? emailTwo,
    @Part(name: 'mobileNumber') String? mobileNumber,
    @Part(name: 'addressTwo') String? addressTwo,
    @Part(name: 'companyId') int? companyId,
  );

 @PUT('api/Contacts/{id}')
@MultiPart()
Future<Contact> updateContact(
  @Header('Authorization') String token,
  @Path('id') int id,
  @Part(name: 'firstName') String firstName,
  @Part(name: 'lastName') String lastName,
  @Part(name: 'email') String email,
  @Part(name: 'phoneNumber') String phoneNumber,
  @Part(name: 'address') String address,
  @Part(name: 'isFavorite') bool isFavorite,
  @Part(name: 'status') String status,
  @Part(name: 'ImageUploadFile') File? image, 
  @Part(name: 'emailTwo') String? emailTwo,
  @Part(name: 'mobileNumber') String? mobileNumber,
  @Part(name: 'addressTwo') String? addressTwo,
  @Part(name: 'companyId') int? companyId,
);


  @DELETE('api/Contacts/{id}')
  Future<void> deleteOneContact(
      @Header('Authorization') String token, @Path('id') int id);

  @DELETE('api/Contacts')
  Future<void> deleteContact(@Header('Authorization') String token);

  @POST('api/Contacts/send-email')
  Future<void> sendEmail(
      @Header('Authorization') String token, @Body() EmailModel model);

  @GET('api/Contacts/{id}/image-url')
  Future<String> getImageUrl(
      @Header('Authorization') String token, @Path('id') int id);

  @PATCH('api/Contacts/toggle-favorite/{id}')
  Future<void> toggleFavorite(
    @Header('Authorization') String token,
    @Path('id') int id,
  );
}
