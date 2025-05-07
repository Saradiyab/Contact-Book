import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/contact/domain/repositories/contact_repository.dart';

class DeleteContact {
  final ContactRepository repository;

  DeleteContact(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteContact();
  }
}
