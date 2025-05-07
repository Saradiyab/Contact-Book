import 'dart:io';
import 'package:contact_app1/features/contact/data/datasources/contact_remote_data_source.dart';
import 'package:contact_app1/features/contact/data/datasources/contact_service.dart';
import 'package:contact_app1/features/contact/data/models/contact_model.dart';
import 'package:contact_app1/features/contact/data/models/send_email.dart';


class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final ContactService contactService;

  ContactRemoteDataSourceImpl({required this.contactService});

  @override
  Future<List<ContactModel>> fetchContacts(String token) {
    return contactService.fetchContact(token);
  }

  @override
  Future<ContactModel> createContact(ContactModel contact, String token, {File? image}) {
    return contactService.createContact(
      token,
      contact.firstName,
      contact.lastName,
      contact.email,
      contact.phoneNumber,
      contact.address,
      contact.isFavorite,
      contact.status?.name ?? 'Inactive',
      image,
      contact.emailTwo,
      contact.mobileNumber,
      contact.addressTwo,
      contact.companyId,
    );
  }

  @override
  Future<ContactModel> updateContact(int id, ContactModel contact, String token, {File? image}) {
    return contactService.updateContact(
      token,
      id,
      contact.firstName,
      contact.lastName,
      contact.email,
      contact.phoneNumber,
      contact.address,
      contact.isFavorite,
      contact.status?.name ?? 'Inactive',
      image,
      contact.emailTwo,
      contact.mobileNumber,
      contact.addressTwo,
      contact.companyId,
    );
  }

  @override
  Future<void> deleteAllContacts(String token) {
    return contactService.deleteContact(token);
  }

  @override
  Future<void> deleteOneContact(String token, int id) {
    return contactService.deleteOneContact(token, id);
  }

  @override
  Future<void> sendEmail(String token, EmailModel model) {
    return contactService.sendEmail(token, model);
  }

  @override
  Future<void> toggleFavorite(String token, int id) {
    return contactService.toggleFavorite(token, id);
  }
}
