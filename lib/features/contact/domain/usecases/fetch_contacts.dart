import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/contact/domain/repositories/contact_repository.dart';

class FetchContacts {
  final ContactRepository repository;

  FetchContacts(this.repository);

  Future<Either<Failure, List<Contact>>> call() async {
    return await repository.fetchContact();
  }
}
