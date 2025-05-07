// lib/features/company/domain/usecases/update_company.dart

import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/company/domain/entities/company.dart';
import 'package:contact_app1/features/company/domain/repositories/company_repository.dart';
import 'package:dartz/dartz.dart';


class UpdateCompany {
  final CompanyRepository repository;

  UpdateCompany(this.repository);

  Future<Either<Failure, Company>> call(String token, Company updatedCompany) async {
    return repository.updateCompany(token, updatedCompany);
  }
}
