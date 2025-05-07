// lib/features/user/domain/entities/user.dart

class User {
  final String? id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final String? status;
  final String? imagePath;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    this.role,
    this.status,
    this.imagePath,
  });
}
