import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';
import 'package:contact_app1/features/contact/data/models/send_email.dart';
import 'package:contact_app1/features/contact/domain/usecases/create_contact.dart';
import 'package:contact_app1/features/contact/domain/usecases/delete_contact.dart';
import 'package:contact_app1/features/contact/domain/usecases/delete_one_contact.dart';
import 'package:contact_app1/features/contact/domain/usecases/fetch_contacts.dart';
import 'package:contact_app1/features/contact/domain/usecases/send_email.dart';
import 'package:contact_app1/features/contact/domain/usecases/update_contact.dart';
import 'package:contact_app1/features/contact/domain/usecases/toggle_favorite.dart';
import 'package:contact_app1/features/contact/presentation/bloc/contact_state.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactCubit extends Cubit<ContactState> {
  final CreateContact createContactUseCase;
  final DeleteContact deleteContactUseCase;
  final DeleteOneContact deleteOneContactUseCase; 
  final FetchContacts fetchContactsUseCase;
  final SendEmail sendEmailUseCase;
  final ToggleFavorite toggleFavoriteUseCase;
  final UpdateContact updateContactUseCase;

  List<Contact> _allContacts = [];

  ContactCubit({
    required this.createContactUseCase,
    required this.deleteContactUseCase,
    required this.deleteOneContactUseCase,
    required this.fetchContactsUseCase,
    required this.sendEmailUseCase,
    required this.toggleFavoriteUseCase,
    required this.updateContactUseCase, 
  }) : super(ContactInitial());

  Future<void> fetchContact() async {
    emit(ContactLoading());
    final result = await fetchContactsUseCase();
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.fetchContactsError.tr())),
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
    final result = await updateContactUseCase(id: id, contact: contact, image: image);
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.updateContactError.tr())),
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
    final result = await createContactUseCase(contact, image: image);
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.createContactError.tr())),
      (newContact) async {
        emit(ContactCreated(contact: newContact));
        await fetchContact();
      },
    );
  }

  Future<void> deleteContact() async {
    emit(ContactLoading());
    final result = await deleteContactUseCase();
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.deleteContactError.tr())),
      (_) async => await fetchContact(),
    );
  }

  Future<void> deleteOneContact(int id) async {
    emit(ContactLoading());
    final result = await deleteOneContactUseCase(id);
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.deleteContactError.tr())),
      (_) async {
        emit(ContactDeleted(deletedId: id));
        await fetchContact();
      },
    );
  }

  Future<void> sendEmail(EmailModel emailModel) async {
    emit(ContactLoading());
    final result = await sendEmailUseCase(emailModel);
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.sendEmailError.tr())),
      (_) => emit(ContactsEmailSent(message: AppStrings.sendEmailSuccess.tr())),
    );
  }

  Future<void> toggleFavorite(int contactId) async {
    emit(ContactLoading());
    final result = await toggleFavoriteUseCase(contactId);
    result.fold(
      (failure) => emit(ContactError(message: AppStrings.toggleFavoriteError.tr())),
      (_) async {
        await fetchContact();
      },
    );
  }
}