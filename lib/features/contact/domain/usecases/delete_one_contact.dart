import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/contact/domain/repositories/contact_repository.dart';

class DeleteOneContact {
  final ContactRepository repository;

  DeleteOneContact(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteOneContact(id);
  }
}
