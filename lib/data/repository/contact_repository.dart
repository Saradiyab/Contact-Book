import 'dart:io';
import 'package:contact_app1/data/api/auth_servic.dart';
import 'package:contact_app1/data/api/contact_service.dart';
import 'package:contact_app1/data/models/contact.dart';
import 'package:contact_app1/data/models/send_email.dart';

class ContactRepository {
  final ContactService contactService;
  final AuthService authService;

  ContactRepository({
    required this.contactService,
    required this.authService,
  });

  Future<List<Contact>> fetchContact() async {
    final token = await authService.getToken();
    return await contactService.fetchContact("Bearer $token");
  }

  Future<Contact> updateContact(int id, Contact c, {File? image}) async {
    final token = await authService.getToken();
    return await contactService.updateContact(
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
  }
  Future<Contact> createContact(Contact c, {File? image}) async {
    final token = await authService.getToken();
    return await contactService.createContact(
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
  }

  Future<void> deleteContact() async {
    final token = await authService.getToken();
    await contactService.deleteContact("Bearer $token");
  }

  Future<void> deleteOneContact(int id) async {
    final token = await authService.getToken();
    await contactService.deleteOneContact("Bearer $token", id);
  }

  Future<void> sendEmail(EmailModel emailModel) async {
    final token = await authService.getToken();
    await contactService.sendEmail("Bearer $token", emailModel);
  }

  Future<void> getImageUrl(int id) async {
    final token = await authService.getToken();
    await contactService.getImageUrl("Bearer $token", id);
  }

  Future<void> toggleFavorite(int id) async {
    final token = await authService.getToken();
    await contactService.toggleFavorite("Bearer $token", id);
  }
}
