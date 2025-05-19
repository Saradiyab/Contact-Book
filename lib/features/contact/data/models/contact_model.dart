// features/contact/data/models/contact_model.dart

import 'dart:io';

import 'package:contact_app1/features/contact/data/models/contact_status_extension.dart';
import 'package:contact_app1/features/contact/domain/entities/contact.dart';

class ContactModel extends Contact {
  final File? imageFile; 

  ContactModel({
    super.id,
    required super.firstName,
    required super.lastName,
    super.image,
    super.imageUrl,
    required super.email,
    super.emailTwo,
    required super.phoneNumber,
    super.mobileNumber,
    super.status,
    required super.isFavorite,
    required super.address,
    super.addressTwo,
    super.companyId,
    this.imageFile,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      image: json['image'],
      imageUrl: json['imageUrl'],
      email: json['email'],
      emailTwo: json['emailTwo'],
      phoneNumber: json['phoneNumber'],
      mobileNumber: json['mobileNumber'],
      status: (json['status'] as String?)?.toContactStatus(),
      isFavorite: json['isFavorite'] ?? false,
      address: json['address'],
      addressTwo: json['addressTwo'],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'imageUrl': imageUrl,
      'email': email,
      'emailTwo': emailTwo,
      'phoneNumber': phoneNumber,
      'mobileNumber': mobileNumber,
      'status': status?.toJson(),
      'isFavorite': isFavorite,
      'address': address,
      'addressTwo': addressTwo,
      'companyId': companyId,
    };
  }

  ContactModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? image,
    String? imageUrl,
    String? email,
    String? emailTwo,
    String? phoneNumber,
    String? mobileNumber,
    ContactStatus? status,
    bool? isFavorite,
    String? address,
    String? addressTwo,
    int? companyId,
    File? imageFile,
  }) {
    return ContactModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      emailTwo: emailTwo ?? this.emailTwo,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      address: address ?? this.address,
      addressTwo: addressTwo ?? this.addressTwo,
      companyId: companyId ?? this.companyId,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  // ContactModel'den Contact'a dönüşüm
  Contact toContact() {
    return Contact(
      id: id,
      firstName: firstName,
      lastName: lastName,
      image: image,
      imageUrl: imageUrl,
      email: email,
      emailTwo: emailTwo,
      phoneNumber: phoneNumber,
      mobileNumber: mobileNumber,
      status: status,
      isFavorite: isFavorite,
      address: address,
      addressTwo: addressTwo,
      companyId: companyId,
    );
  }

  // Contact'tan ContactModel'e dönüşüm
  factory ContactModel.fromContact(Contact contact) {
    return ContactModel(
      id: contact.id,
      firstName: contact.firstName,
      lastName: contact.lastName,
      image: contact.image,
      imageUrl: contact.imageUrl,
      email: contact.email,
      emailTwo: contact.emailTwo,
      phoneNumber: contact.phoneNumber,
      mobileNumber: contact.mobileNumber,
      status: contact.status,
      isFavorite: contact.isFavorite,
      address: contact.address,
      addressTwo: contact.addressTwo,
      companyId: contact.companyId,
    );
  }
}
