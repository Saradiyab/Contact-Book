import 'package:contact_app1/features/company/domain/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({
    required super.id,
    required super.companyName,
    required super.vatNumber,
    required super.streetOne,
    super.streetTwo,
    required super.city,
    required super.state,
    required super.zip,
    required super.country,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json['id'] ?? 0,
        companyName: json['companyName'] ?? '',
        vatNumber: json['vatNumber'] ?? '',
        streetOne: json['streetOne'] ?? '',
        streetTwo: json['streetTwo'],
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        zip: json['zip'] ?? '',
        country: json['country'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'companyName': companyName,
        'vatNumber': vatNumber,
        'streetOne': streetOne,
        'streetTwo': streetTwo,
        'city': city,
        'state': state,
        'zip': zip,
        'country': country,
      };

  factory CompanyModel.fromEntity(Company company) => CompanyModel(
        id: company.id,
        companyName: company.companyName,
        vatNumber: company.vatNumber,
        streetOne: company.streetOne,
        streetTwo: company.streetTwo,
        city: company.city,
        state: company.state,
        zip: company.zip,
        country: company.country,
      );

  Company toEntity() => Company(
        id: id,
        companyName: companyName,
        vatNumber: vatNumber,
        streetOne: streetOne,
        streetTwo: streetTwo,
        city: city,
        state: state,
        zip: zip,
        country: country,
      );
}
