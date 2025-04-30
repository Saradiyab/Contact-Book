
class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String companyName;
  final String vatNumber;
  final String streetOne;
  final String streetTwo;
  final String city;
  final String state;
  final String zip;
  final String country;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.companyName,
    required this.vatNumber,
    required this.streetOne,
    required this.streetTwo,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

 Map<String, dynamic> toJson() {
  return {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNumber": phoneNumber,
    "password": password,
    "companyName": companyName,
    "vatNumber": vatNumber,
    "streetOne": streetOne,
    "streetTwo": streetTwo,
    "city": city,
    "state": state,
    "zip": zip,
    "country": country,
  };
}



  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      password: json["password"],
      companyName: json["companyName"],
      vatNumber: json["vatNumber"],
      streetOne: json["streetOne"],
      streetTwo: json["streetTwo"],
      city: json["city"],
      state: json["state"],
      zip: json["zip"],
      country: json["country"],
    );
  }

}
