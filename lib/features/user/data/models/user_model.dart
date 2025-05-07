// lib/features/user/data/models/user_model.dart

import 'package:contact_app1/features/user/domain/entities/user.dart';

class UserModel extends User {
  final String? normalizedUserName;
  final String? normalizedEmail;
  final bool? emailConfirmed;
  final String? passwordHash;
  final String? securityStamp;
  final String? concurrencyStamp;
  final bool? phoneNumberConfirmed;
  final bool? twoFactorEnabled;
  final String? lockoutEnd;
  final bool? lockoutEnabled;
  final int? accessFailedCount;
  final String? companyId;
  final Map<String, dynamic>? company;

  UserModel({
    super.id,
    required super.firstName,
    required super.lastName,
    super.email,
    super.phoneNumber,
    super.role,
    super.status,
    super.imagePath,
    this.normalizedUserName,
    this.normalizedEmail,
    this.emailConfirmed,
    this.passwordHash,
    this.securityStamp,
    this.concurrencyStamp,
    this.phoneNumberConfirmed,
    this.twoFactorEnabled,
    this.lockoutEnd,
    this.lockoutEnabled,
    this.accessFailedCount,
    this.companyId,
    this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      firstName: json['firstName'] ?? 'Unknown',
      lastName: json['lastName'] ?? 'Unknown',
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      status: json['status'],
      imagePath: json['imagePath'],
      normalizedUserName: json['normalizedUserName'],
      normalizedEmail: json['normalizedEmail'],
      emailConfirmed: json['emailConfirmed'],
      passwordHash: json['passwordHash'],
      securityStamp: json['securityStamp'],
      concurrencyStamp: json['concurrencyStamp'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
      twoFactorEnabled: json['twoFactorEnabled'],
      lockoutEnd: json['lockoutEnd'],
      lockoutEnabled: json['lockoutEnabled'],
      accessFailedCount: json['accessFailedCount'],
      companyId: json['companyId'],
      company: json['company'] is Map<String, dynamic> ? json['company'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role ?? "User",
        'status': status ?? "Pending",
        'imagePath': imagePath,
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
      };

  User toUser() => User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        role: role,
        status: status,
        imagePath: imagePath,
      );

  factory UserModel.fromUser(User user) => UserModel(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        role: user.role,
        status: user.status,
        imagePath: user.imagePath,
      );
}
