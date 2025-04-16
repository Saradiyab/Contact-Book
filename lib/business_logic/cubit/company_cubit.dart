import 'package:bloc/bloc.dart';
import 'package:contact_app1/data/repository/company_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:contact_app1/data/models/company.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository companyRepository;

  CompanyCubit({required this.companyRepository}) : super(CompanyInitial());

  Future<void> fetchCompanyDetails(String token) async {
    try {
      emit(CompanyLoading());

      final company = await companyRepository.getCompanyDetails(token);
      emit(CompanyLoaded(company));
    } catch (e) {
      emit(CompanyError(
          "An error occurred while retrieving company information.: $e"));
    }
  }

  Future<void> updateCompany(String token, Company updatedCompany) async {
    try {
      emit(CompanyUpdating());

      await companyRepository.updateCompany(token, updatedCompany);

      await fetchCompanyDetails(token);
    } catch (e) {
      emit(CompanyError("Company information could not be updated: $e"));
    }
  }
}
