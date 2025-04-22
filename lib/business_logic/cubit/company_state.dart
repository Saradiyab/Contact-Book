
import 'package:contact_app1/data/models/company.dart';
import 'package:equatable/equatable.dart';



abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object?> get props => [];
}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyUpdating extends CompanyState {}

class CompanyLoaded extends CompanyState {
  final Company company;

  const CompanyLoaded(this.company);

  @override
  List<Object?> get props => [company];
}

class CompanyError extends CompanyState {
  final String message;

  const CompanyError(this.message);

  @override
  List<Object?> get props => [message];
}
