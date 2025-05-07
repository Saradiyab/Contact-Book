import 'dart:io';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/contact/domain/repositories/contact_repository.dart';

class CreateContact {
  final ContactRepository repository;

  CreateContact(this.repository);

  Future<Either<Failure, Contact>> call(Contact contact, {File? image}) async {
  return await repository.createContact(contact, image: image);
  }
}
