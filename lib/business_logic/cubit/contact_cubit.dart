import 'dart:io';
import 'package:contact_app1/data/models/send_email.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/business_logic/cubit/contact_state.dart';
import 'package:contact_app1/data/models/contact.dart';
import 'package:contact_app1/data/repository/contact_repository.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepository contactRepository;
  List<Contact> _allContacts = []; 

  ContactCubit({required this.contactRepository}) : super(ContactInitial());

  Future<void> fetchContact() async {
    emit(ContactLoading());
    try {
      final List<Contact> contacts = await contactRepository.fetchContact();
      _allContacts = contacts;
      emit(ContactsLoaded(contacts: contacts));
    } catch (e) {
      emit(ContactError(message: "Could not retrieve data: ${e.toString()}"));
    }
  }

  void filterContacts(String query) {
    final filtered = _allContacts.where((contact) {
      final name = "${contact.firstName} ${contact.lastName}".toLowerCase();
      final email = contact.email.toLowerCase();
      final phone = contact.phoneNumber.toLowerCase();
      return name.contains(query.toLowerCase()) ||
             email.contains(query.toLowerCase()) ||
             phone.contains(query.toLowerCase());
    }).toList();

    emit(ContactsLoaded(contacts: filtered));
  }

  Future<void> updateContact({
    required int id,
    required Contact contact,
    File? image,
  }) async {
    emit(ContactLoading());
    try {
      final updatedContact = await contactRepository.updateContact(id, contact, image: image);
      emit(ContactUpdated(contact: updatedContact));
      await fetchContact();
    } catch (e) {
      emit(ContactError(message: "Contact could not be updated: ${e.toString()}"));
    }
  }

  Future<void> createContact({
    required Contact contact,
    File? image,
  }) async {
    emit(ContactLoading());
    try {
      final newContact = await contactRepository.createContact(contact, image: image);
      emit(ContactCreated(contact: newContact));
      await fetchContact();
    } catch (e) {
      emit(ContactError(message: "Failed to create contact: ${e.toString()}"));
    }
  }

  Future<void> deleteContact() async {
    emit(ContactLoading());
    try {
      await contactRepository.deleteContact();
      await fetchContact();
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }

  Future<void> deleteOneContact(int id) async {
    emit(ContactLoading());
    try {
      await contactRepository.deleteOneContact(id);
      emit(ContactDeleted(deletedId: id));
      await fetchContact();
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }

  Future<void> sendEmail(EmailModel emailModel) async {
    emit(ContactLoading());  
    try {
      await contactRepository.sendEmail(emailModel);
      emit(ContactsEmailSent(message: "Email sent successfully"));
    } catch (e) {
      print("Email sending error: $e");  
      emit(ContactError(message: "Email sending failed: ${e.toString()}"));
    }
  }

  Future<void> toggleFavorite(int contactId) async {
    emit(ContactLoading());
    try {
      await contactRepository.toggleFavorite(contactId);
      final contacts = await contactRepository.fetchContact();
      _allContacts = contacts;
      emit(ContactsLoaded(contacts: contacts));
    } catch (e) {
      emit(ContactError(message: "Favori güncellenemedi: ${e.toString()}"));
    }
  }
}
