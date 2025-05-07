import 'dart:io';
import 'package:contact_app1/features/contact/data/models/contact_model.dart';
import 'package:contact_app1/features/contact/data/models/send_email.dart';

abstract class ContactRemoteDataSource {
  Future<List<ContactModel>> fetchContacts(String token);
  Future<ContactModel> createContact(ContactModel contact, String token, {File? image});
  Future<ContactModel> updateContact(int id, ContactModel contact, String token, {File? image});
  Future<void> deleteAllContacts(String token);
  Future<void> deleteOneContact(String token, int id);
  Future<void> sendEmail(String token, EmailModel model);
  Future<void> toggleFavorite(String token, int id);
}
