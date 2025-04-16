import 'package:contact_app1/data/api/company_service.dart';
import 'package:contact_app1/data/models/company.dart';

class CompanyRepository {
  final CompanyService companyService;

  CompanyRepository({required this.companyService});

  Future<Company> getCompanyDetails(String token) async {
    return await companyService.getCompanyDetails("Bearer $token");
  }

  Future<Company> updateCompany(String token, Company updatedCompany) async {
    return await companyService.updateCompany("Bearer $token", updatedCompany);
  }
}
