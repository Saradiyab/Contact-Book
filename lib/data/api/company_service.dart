import "package:contact_app1/data/models/company.dart";
import "package:dio/dio.dart";
import "package:retrofit/http.dart";

part 'company_service.g.dart';

@RestApi(baseUrl: "https://ms.itmd-b1.com:5123/")
abstract class CompanyService {
  factory CompanyService(Dio dio, {String baseUrl}) = _CompanyService;

  @GET('api/Companies')
  Future<Company> getCompanyDetails(@Header('Authorization') String token);

  @PUT('api/Companies')
  Future<Company> updateCompany(
    @Header('Authorization') String token,
    @Body() Company editcompany,
  );
}
