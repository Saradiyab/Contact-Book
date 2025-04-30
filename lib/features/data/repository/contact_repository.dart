import 'dart:io';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/data/api/auth_servic.dart';
import 'package:contact_app1/features/data/api/contact_service.dart';
import 'package:contact_app1/features/data/models/contact.dart';
import 'package:contact_app1/features/data/models/send_email.dart';
import 'package:dartz/dartz.dart';

class ContactRepository {
  final ContactService contactService;
  final AuthService authService;

  ContactRepository({
    required this.contactService,
    required this.authService,
  });

  Future<Either<Failure, List<Contact>>> fetchContact() async {
    try {
      final token = await authService.getToken();
      final contacts = await contactService.fetchContact("Bearer $token");
      return Right(contacts);
    } catch (e) {
      return Left(ServerFailure("Failed to fetch contacts."));
    }
  }

  Future<Either<Failure, Contact>> updateContact(int id, Contact c, {File? image}) async {
    try {
      final token = await authService.getToken();
      final updatedContact = await contactService.updateContact(
        'Bearer $token',
        id,
        c.firstName,
        c.lastName,
        c.email,
        c.phoneNumber,
        c.address,
        c.isFavorite,
        c.status?.name ?? 'Inactive',
        image,
        c.emailTwo,
        c.mobileNumber,
        c.addressTwo,
        c.companyId,
      );
      return Right(updatedContact);
    } catch (e) {
      return Left(ServerFailure("Failed to update contact."));
    }
  }

  Future<Either<Failure, Contact>> createContact(Contact c, {File? image}) async {
    try {
      final token = await authService.getToken();
      final newContact = await contactService.createContact(
        'Bearer $token',
        c.firstName,
        c.lastName,
        c.email,
        c.phoneNumber,
        c.address,
        c.isFavorite,
        c.status?.name ?? 'Inactive',
        image,
        c.emailTwo,
        c.mobileNumber,
        c.addressTwo,
        c.companyId,
      );
      return Right(newContact);
    } catch (e) {
      return Left(ServerFailure("Failed to create contact."));
    }
  }

  Future<Either<Failure, void>> deleteContact() async {
    try {
      final token = await authService.getToken();
      await contactService.deleteContact("Bearer $token");
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to delete contacts."));
    }
  }

  Future<Either<Failure, void>> deleteOneContact(int id) async {
    try {
      final token = await authService.getToken();
      await contactService.deleteOneContact("Bearer $token", id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to delete contact."));
    }
  }

  Future<Either<Failure, void>> sendEmail(EmailModel emailModel) async {
    try {
      final token = await authService.getToken();
      await contactService.sendEmail("Bearer $token", emailModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to send email."));
    }
  }

  Future<Either<Failure, void>> toggleFavorite(int id) async {
    try {
      final token = await authService.getToken();
      await contactService.toggleFavorite("Bearer $token", id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to toggle favorite."));
    }
  }
}
