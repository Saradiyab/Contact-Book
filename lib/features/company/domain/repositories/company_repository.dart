
import 'package:dartz/dartz.dart';
import 'package:contact_app1/features/company/domain/entities/company.dart';
import 'package:contact_app1/core/error/failure.dart';

abstract class CompanyRepository {
  Future<Either<Failure, Company>> getCompanyDetails(String token);
  Future<Either<Failure, Company>> updateCompany(String token, Company updatedCompany);
}
