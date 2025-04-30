import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/data/models/contact.dart';
import 'package:contact_app1/features/data/models/send_email.dart';
import 'package:contact_app1/features/data/repository/contact_repository.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepository contactRepository;
  List<Contact> _allContacts = [];

  ContactCubit({required this.contactRepository}) : super(ContactInitial());

  Future<void> fetchContact() async {
    emit(ContactLoading());
    final result = await contactRepository.fetchContact();
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.fetchContactsError)),
      (contacts) {
        _allContacts = contacts;
        emit(ContactsLoaded(contacts: contacts));
      },
    );
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
    final result = await contactRepository.updateContact(id, contact, image: image);
    result.fold(
      (failure) => emit(const ContactError(message: AppStrings.updateContactError)),
      (updatedContact) async {
        emit(ContactUpdated(contact: updatedContact));
        await fetchContact();
      },
    );
  }

  Future<void> createContact({
    required Contact contact,
    File? image,
  }) async {
    emit(ContactLoading());
    final result = await contactRepository.createContact(contact, image: image);
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.createContactError)),
      (newContact) async {
        emit(ContactCreated(contact: newContact));
        await fetchContact();
      },
    );
  }

  Future<void> deleteContact() async {
    emit(ContactLoading());
    final result = await contactRepository.deleteContact();
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.deleteContactError)),
      (_) async => await fetchContact(),
    );
  }

  Future<void> deleteOneContact(int id) async {
    emit(ContactLoading());
    final result = await contactRepository.deleteOneContact(id);
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.deleteContactError)),
      (_) async {
        emit(ContactDeleted(deletedId: id));
        await fetchContact();
      },
    );
  }

  Future<void> sendEmail(EmailModel emailModel) async {
    emit(ContactLoading());
    final result = await contactRepository.sendEmail(emailModel);
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.sendEmailError)),
      (_) => emit(ContactsEmailSent(message: AppStrings.sendEmailSuccess)),
    );
  }

  Future<void> toggleFavorite(int contactId) async {
    emit(ContactLoading());
    final result = await contactRepository.toggleFavorite(contactId);
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.toggleFavoriteError)),
      (_) async {
        await fetchContact();
      },
    );
  }
}
