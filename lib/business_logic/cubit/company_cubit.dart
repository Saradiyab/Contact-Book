import 'package:bloc/bloc.dart';
import 'package:contact_app1/business_logic/cubit/company_state.dart';
import 'package:contact_app1/core/constants/strings.dart';
import 'package:contact_app1/data/models/company.dart';
import 'package:contact_app1/data/models/company_update_request.dart';
import 'package:contact_app1/data/repository/company_repository.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository companyRepository;

  CompanyCubit({required this.companyRepository}) : super(CompanyInitial());

  Future<void> fetchCompanyDetails(String token) async {
    emit(CompanyLoading());
    try {
      final company = await companyRepository.getCompanyDetails(token);
      emit(CompanyLoaded(company));
    } catch (e) {
      emit(const CompanyError(MessageStrings.fetchCompanyError));
    }
  }

  Future<void> updateCompany(String token, CompanyUpdateRequest request) async {
    final currentState = state;

    if (currentState is! CompanyLoaded) {
      emit(const CompanyError(MessageStrings.noCompanyToUpdate));
      return;
    }

    emit(CompanyUpdating());

    try {
      final updatedCompany = Company(
        id: currentState.company.id,
        companyName: request.companyName,
        vatNumber: request.vatNumber,
        streetOne: request.streetOne,
        streetTwo: request.streetTwo,
        city: request.city,
        state: request.state,
        zip: request.zip,
        country: currentState.company.country,
      );

      await companyRepository.updateCompany(token, updatedCompany);
      await fetchCompanyDetails(token);
    } catch (e) {
      emit(const CompanyError(MessageStrings.updateCompanyError));
    }
  }
}
