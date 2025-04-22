enum ContactStatus {
  active,
  inactive,
  pending;

  static ContactStatus? fromString(String? value) {
    switch (value) {
      case 'Active':
        return ContactStatus.active;
      case 'Inactive':
        return ContactStatus.inactive;
      case 'Pending':
        return ContactStatus.pending;
      default:
        return null;
    }
  }

  String toJson() {
    return name;
  }
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

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      image: json['image'],
      imageUrl: json['imageUrl'],
      email: json['email'],
      emailTwo: json['emailTwo'],
      phoneNumber: json['phoneNumber'],
      mobileNumber: json['mobileNumber'],
      status: ContactStatus.fromString(json['status']),
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

  Contact copyWith({
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
  }) {
    return Contact(
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
    );
  }
}
