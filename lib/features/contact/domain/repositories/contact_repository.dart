import 'dart:io';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:contact_app1/features/contact/data/models/send_email.dart';
import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';

abstract class ContactRepository {
  Future<Either<Failure, List<Contact>>> fetchContact();
  Future<Either<Failure, Contact>> updateContact(int id, Contact contact, {File? image});
  Future<Either<Failure, Contact>> createContact(Contact contact, {File? image});
  Future<Either<Failure, void>> deleteContact();
  Future<Either<Failure, void>> deleteOneContact(int id);
  Future<Either<Failure, void>> sendEmail(EmailModel emailModel);
  Future<Either<Failure, void>> toggleFavorite(int id);
}
