import 'package:contact_app1/features/contact/domain/entities/contact.dart';

extension ContactStatusExtension on String {
  ContactStatus toContactStatus() {
    switch (toLowerCase()) {
      case 'active':
        return ContactStatus.active;
      case 'inactive':
        return ContactStatus.inactive;
      case 'pending':
        return ContactStatus.pending;
      default:
        throw Exception('Invalid ContactStatus: $this');
    }
  }
}

extension ContactStatusToJson on ContactStatus {
  String toJson() {
    return toString().split('.').last;
  }

  String get name {
    return toString().split('.').last;
  }
}
