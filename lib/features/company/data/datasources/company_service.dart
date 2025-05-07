import "package:contact_app1/features/company/data/models/company_model.dart";
import "package:dio/dio.dart";
import "package:retrofit/error_logger.dart";
import "package:retrofit/http.dart";

part 'company_service.g.dart';

@RestApi(baseUrl: "https://ms.itmd-b1.com:5123/")
abstract class CompanyService {
  factory CompanyService(Dio dio, {String baseUrl}) = _CompanyService;

  @GET('api/Companies')
  Future<CompanyModel> getCompanyDetails(@Header('Authorization') String token);

  @PUT('api/Companies')
  Future<CompanyModel> updateCompany(
    @Header('Authorization') String token,
    @Body() CompanyModel editcompany,
  );
}