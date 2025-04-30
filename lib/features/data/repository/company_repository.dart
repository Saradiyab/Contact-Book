import 'package:contact_app1/features/data/api/company_service.dart';
import 'package:contact_app1/features/data/models/company.dart';
import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class CompanyRepository {
  final CompanyService companyService;

  const CompanyRepository({required this.companyService});

  Future<Either<Failure, Company>> getCompanyDetails(String token) async {
    try {
      final company = await companyService.getCompanyDetails("Bearer $token");
      return Right(company);
    } catch (e) {
      logger.e("CompanyRepository → Fetch Company Error", error: e);
      return Left(ServerFailure(AppStrings.fetchCompanyError));
    }
  }

  Future<Either<Failure, Company>> updateCompany(String token, Company updatedCompany) async {
    try {
      final company = await companyService.updateCompany("Bearer $token", updatedCompany);
      return Right(company);
    } catch (e) {
      logger.e("CompanyRepository → Update Company Error", error: e);
      return Left(ServerFailure(AppStrings.updateCompanyError));
    }
  }
}
