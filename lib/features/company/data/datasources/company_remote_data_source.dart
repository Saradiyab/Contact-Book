import '../models/company_model.dart';

abstract class CompanyRemoteDataSource {
  Future<CompanyModel> getCompanyDetails(String token);
  Future<CompanyModel> updateCompany(String token, CompanyModel company);
}
