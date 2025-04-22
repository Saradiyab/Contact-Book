class CompanyUpdateRequest {
  final String companyName;
  final String vatNumber;
  final String streetOne;
  final String? streetTwo;
  final String city;
  final String state;
  final String zip;

  const CompanyUpdateRequest({
    required this.companyName,
    required this.vatNumber,
    required this.streetOne,
    this.streetTwo,
    required this.city,
    required this.state,
    required this.zip,
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'vatNumber': vatNumber,
        'streetOne': streetOne,
        'streetTwo': streetTwo,
        'city': city,
        'state': state,
        'zip': zip,
      };
}
