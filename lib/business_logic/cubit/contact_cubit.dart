import 'dart:io';
import 'package:contact_app1/core/constants/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/data/models/send_email.dart';
import 'package:contact_app1/data/models/contact.dart';
import 'package:contact_app1/data/repository/contact_repository.dart';
import 'package:contact_app1/business_logic/cubit/contact_state.dart';

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
      emit(ContactError(message: MessageStrings.fetchContactsError));
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
      emit(const ContactError(message: MessageStrings.updateContactError));
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
      emit(ContactError(message: MessageStrings.createContactError));
    }
  }

  Future<void> deleteContact() async {
    emit(ContactLoading());
    try {
      await contactRepository.deleteContact();
      await fetchContact();
    } catch (e) {
      emit( ContactError(message: MessageStrings.deleteContactError));
    }
  }

  Future<void> deleteOneContact(int id) async {
    emit(ContactLoading());
    try {
      await contactRepository.deleteOneContact(id);
      emit(ContactDeleted(deletedId: id));
      await fetchContact();
    } catch (e) {
      emit( ContactError(message: MessageStrings.deleteContactError));
    }
  }

  Future<void> sendEmail(EmailModel emailModel) async {
    emit(ContactLoading());
    try {
      await contactRepository.sendEmail(emailModel);
      emit(ContactsEmailSent(message: MessageStrings.sendEmailSuccess));
    } catch (e) {
      emit(ContactError(message: MessageStrings.sendEmailError));
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
      emit(ContactError(message: MessageStrings.toggleFavoriteError));
    }
  }
}
