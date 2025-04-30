class Company {
  final int id;
  final String companyName;
  final String vatNumber;
  final String streetOne;
  final String? streetTwo;
  final String city;
  final String state;
  final String zip;
  final String country;

  const Company({
    required this.id,
    required this.companyName,
    required this.vatNumber,
    required this.streetOne,
    this.streetTwo,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
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
}
