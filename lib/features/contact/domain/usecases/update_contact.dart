import 'dart:io';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/contact/domain/repositories/contact_repository.dart';

class UpdateContact {
  final ContactRepository repository;

  UpdateContact(this.repository);

  Future<Either<Failure, Contact>> call({
    required int id,
    required Contact contact,
    File? image,
  }) async {
    return await repository.updateContact(id, contact, image: image);
  }
}

  
