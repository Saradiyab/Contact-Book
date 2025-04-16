class User {
  final String? id;
  final String? userName;
  final String? normalizedUserName;
  final String? email;
  final String? normalizedEmail;
  final bool? emailConfirmed;
  final String? passwordHash;
  final String? securityStamp;
  final String? concurrencyStamp;
  final String? phoneNumber;
  final bool? phoneNumberConfirmed;
  final bool? twoFactorEnabled;
  final String? lockoutEnd;
  final bool? lockoutEnabled;
  final int? accessFailedCount;
  final String firstName;
  final String lastName;
  final String? status;
  late final String? role;
  final String? companyId;
  final Map<String, dynamic>? company;
  final String? imagePath;

  User({
    this.id,
    this.userName,
    this.normalizedUserName,
    this.email,
    this.normalizedEmail,
    this.emailConfirmed,
    this.passwordHash,
    this.securityStamp,
    this.concurrencyStamp,
    this.phoneNumber,
    this.phoneNumberConfirmed,
    this.twoFactorEnabled,
    this.lockoutEnd,
    this.lockoutEnabled,
    this.accessFailedCount,
    required this.firstName,
    required this.lastName,
    this.status,
    this.role,
    this.companyId,
    this.company,
    this.imagePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      userName: json['userName'],
      normalizedUserName: json['normalizedUserName'],
      email: json['email'],
      normalizedEmail: json['normalizedEmail'],
      emailConfirmed: json['emailConfirmed'],
      passwordHash: json['passwordHash'],
      securityStamp: json['securityStamp'],
      concurrencyStamp: json['concurrencyStamp'],
      phoneNumber: json['phoneNumber'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
      twoFactorEnabled: json['twoFactorEnabled'],
      lockoutEnd: json['lockoutEnd'],
      lockoutEnabled: json['lockoutEnabled'],
      accessFailedCount: json['accessFailedCount'],
      firstName: json['firstName'] ?? "Unknown",
      lastName: json['lastName'] ?? "Unknown",
      status: json['status'],
      role: json['role'],
      companyId: json['companyId'],
      company: json['company'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneNumber': phoneNumber?.toString() ?? "",
    'status': status?.isEmpty ?? true ? "Pending" : status, 
    'role': role ?? "User",
    if (userName != null) 'userName': userName,
    if (normalizedUserName != null) 'normalizedUserName': normalizedUserName,
    if (normalizedEmail != null) 'normalizedEmail': normalizedEmail,
    if (emailConfirmed != null) 'emailConfirmed': emailConfirmed,
    if (passwordHash != null) 'passwordHash': passwordHash,
    if (securityStamp != null) 'securityStamp': securityStamp,
    if (concurrencyStamp != null) 'concurrencyStamp': concurrencyStamp,
    if (phoneNumberConfirmed != null) 'phoneNumberConfirmed': phoneNumberConfirmed,
    if (twoFactorEnabled != null) 'twoFactorEnabled': twoFactorEnabled,
    if (lockoutEnd != null) 'lockoutEnd': lockoutEnd,
    if (lockoutEnabled != null) 'lockoutEnabled': lockoutEnabled,
    if (accessFailedCount != null) 'accessFailedCount': accessFailedCount,
    if (companyId != null) 'companyId': companyId,
    if (company != null) 'company': company,
    if (imagePath != null) 'imagePath': imagePath,
  };
}
}
