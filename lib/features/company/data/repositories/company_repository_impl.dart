
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/company/data/datasources/company_remote_data_source.dart';
import 'package:contact_app1/features/company/data/models/company_model.dart';
import 'package:contact_app1/features/company/domain/entities/company.dart';
import 'package:contact_app1/features/company/domain/repositories/company_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource companyRemoteDataSource;

  const CompanyRepositoryImpl({required this.companyRemoteDataSource});

  @override
  Future<Either<Failure, Company>> getCompanyDetails(String token) async {
    try {
      final result = await companyRemoteDataSource.getCompanyDetails("Bearer $token");
      return Right(result.toEntity()); // artık entity dönüyoruz
    } catch (e) {
      logger.e("CompanyRepository → Fetch Company Error", error: e);
      return Left(ServerFailure(AppStrings.fetchCompanyError));
    }
  }

  @override
  Future<Either<Failure, Company>> updateCompany(String token, Company updatedCompany) async {
    try {
      final result = await companyRemoteDataSource.updateCompany(
        "Bearer $token",
        CompanyModel.fromEntity(updatedCompany),
      );
      return Right(result.toEntity()); 
    } catch (e) {
      logger.e("CompanyRepository → Update Company Error", error: e);
      return Left(ServerFailure(AppStrings.updateCompanyError));
    }
  }
}

