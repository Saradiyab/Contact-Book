import 'dart:io';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/auth/data/datasources/auth_service.dart';
import 'package:contact_app1/features/contact/data/datasources/contact_remote_data_source.dart';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:contact_app1/features/contact/data/models/contact_model.dart';
import 'package:contact_app1/features/contact/data/models/send_email.dart';
import 'package:contact_app1/features/contact/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource contactRemoteDataSource;
  final AuthService authService;

  ContactRepositoryImpl({
    required this.contactRemoteDataSource,
    required this.authService,
  });

  @override
  Future<Either<Failure, List<Contact>>> fetchContact() async {
    try {
      final token = await authService.getToken();
      final models = await contactRemoteDataSource.fetchContacts("Bearer $token");
      final contacts = models.map((e) => e.toContact()).toList();
      return Right(contacts);
    } catch (e) {
      return Left(ServerFailure("Failed to fetch contacts."));
    }
  }

  @override
  Future<Either<Failure, Contact>> updateContact(int id, Contact c, {File? image}) async {
    try {
      final token = await authService.getToken();
      final model = ContactModel.fromContact(c);
      final updated = await contactRemoteDataSource.updateContact(id, model, "Bearer $token", image: image);
      return Right(updated.toContact());
    } catch (e) {
      return Left(ServerFailure("Failed to update contact."));
    }
  }

  @override
  Future<Either<Failure, Contact>> createContact(Contact c, {File? image}) async {
    try {
      final token = await authService.getToken();
      final model = ContactModel.fromContact(c);
      final created = await contactRemoteDataSource.createContact(model, "Bearer $token", image: image);
      return Right(created.toContact());
    } catch (e) {
      return Left(ServerFailure("Failed to create contact."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteContact() async {
    try {
      final token = await authService.getToken();
      await contactRemoteDataSource.deleteAllContacts("Bearer $token");
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to delete contacts."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOneContact(int id) async {
    try {
      final token = await authService.getToken();
      await contactRemoteDataSource.deleteOneContact("Bearer $token", id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to delete contact."));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmail(EmailModel emailModel) async {
    try {
      final token = await authService.getToken();
      await contactRemoteDataSource.sendEmail("Bearer $token", emailModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to send email."));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(int id) async {
    try {
      final token = await authService.getToken();
      await contactRemoteDataSource.toggleFavorite("Bearer $token", id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to toggle favorite."));
    }
  }
}
