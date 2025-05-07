import '../../domain/entities/register_info.dart';

class RegisterRequestModel extends RegisterInfo {
  RegisterRequestModel({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.password,
    required super.companyName,
    required super.vatNumber,
    required super.streetOne,
    required super.streetTwo,
    required super.city,
    required super.state,
    required super.zip,
    required super.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'companyName': companyName,
      'vatNumber': vatNumber,
      'streetOne': streetOne,
      'streetTwo': streetTwo,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      companyName: json['companyName'],
      vatNumber: json['vatNumber'],
      streetOne: json['streetOne'],
      streetTwo: json['streetTwo'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
    );
  }
}
