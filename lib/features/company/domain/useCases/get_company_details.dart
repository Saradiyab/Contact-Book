
import '../../../../core/error/failure.dart';
import '../entities/company.dart';
import '../repositories/company_repository.dart';
import 'package:dartz/dartz.dart';


class GetCompanyDetails {
  final CompanyRepository repository;

  GetCompanyDetails(this.repository);

  Future<Either<Failure, Company>> call(String token) async {
    return repository.getCompanyDetails(token);
  }
}
