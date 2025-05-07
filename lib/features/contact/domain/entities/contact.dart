enum ContactStatus {
  active,
  inactive,
  pending,
}

class Contact {
  final int? id;
  final String firstName;
  final String lastName;
  final String? image;
  final String? imageUrl;
  final String email;
  final String? emailTwo;
  final String phoneNumber;
  final String? mobileNumber;
  final ContactStatus? status;
  final bool isFavorite;
  final String address;
  final String? addressTwo;
  final int? companyId;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    this.image,
    this.imageUrl,
    required this.email,
    this.emailTwo,
    required this.phoneNumber,
    this.mobileNumber,
    this.status,
    required this.isFavorite,
    required this.address,
    this.addressTwo,
    this.companyId,
  });
}
