
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
}
