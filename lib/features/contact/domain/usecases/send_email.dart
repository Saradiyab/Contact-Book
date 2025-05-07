import 'package:contact_app1/features/contact/data/models/send_email.dart';
import 'package:dartz/dartz.dart';
import 'package:contact_app1/core/error/failure.dart';
import 'package:contact_app1/features/contact/domain/repositories/contact_repository.dart';

class SendEmail {
  final ContactRepository repository;

  SendEmail(this.repository);

  Future<Either<Failure, void>> call(EmailModel model) async {
    return await repository.sendEmail(model);
  }
}
