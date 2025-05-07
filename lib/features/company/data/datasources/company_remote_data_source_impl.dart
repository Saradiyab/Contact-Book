
import '../models/company_model.dart';
import 'company_remote_data_source.dart';
import 'company_service.dart';

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final CompanyService companyService;

  CompanyRemoteDataSourceImpl({required this.companyService});

  @override
  Future<CompanyModel> getCompanyDetails(String token) async {
    return await companyService.getCompanyDetails(token);
  }

  @override
  Future<CompanyModel> updateCompany(String token, CompanyModel company) async {
    return await companyService.updateCompany(token, company);
  }
}

