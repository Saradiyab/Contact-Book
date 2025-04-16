import 'package:equatable/equatable.dart';
import 'package:contact_app1/data/models/contact.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}
class ContactImageLoading extends ContactState {}

class ContactImageError extends ContactState {
  final String message;

  const ContactImageError({required this.message});

  @override
  List<Object?> get props => [message];
}


class ContactsEmailSent extends ContactState {
  final String message;

  const ContactsEmailSent({required this.message});  

  @override
  List<Object?> get props => [message];
}



class ContactsLoaded extends ContactState {
  final List<Contact> contacts;

  const ContactsLoaded({required this.contacts});

  @override
  List<Object?> get props => [contacts];
}

class ContactCreated extends ContactState {
  final Contact contact;

  const ContactCreated({required this.contact});

  @override
  List<Object?> get props => [contact];
}

class ContactUpdated extends ContactState {
  final Contact contact;

  const ContactUpdated({required this.contact});

  @override
  List<Object?> get props => [contact];
}

class ContactDeleted extends ContactState {
  final int deletedId;

  const ContactDeleted({required this.deletedId});

  @override
  List<Object?> get props => [deletedId];
}

class ContactError extends ContactState {
  final String message;

  const ContactError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ContactImageLoaded extends ContactState {
  final String imageUrl;

  const ContactImageLoaded({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}


class ContactFavoriteToggled extends ContactState {
  final int contactId;

  const ContactFavoriteToggled({required this.contactId});

  @override
  List<Object?> get props => [contactId];
}



