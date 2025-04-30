import 'package:bloc/bloc.dart';
import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/data/models/company.dart';
import 'package:contact_app1/features/data/models/company_update_request.dart';
import 'package:contact_app1/features/data/repository/company_repository.dart';
import 'package:contact_app1/features/presentation/business_logic/cubit/company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository companyRepository;

  CompanyCubit({required this.companyRepository}) : super(CompanyInitial());

  Future<void> fetchCompanyDetails(String token) async {
    emit(CompanyLoading());
    final result = await companyRepository.getCompanyDetails(token);

    result.fold(
      (failure) => emit(CompanyError(failure.message)),
      (company) => emit(CompanyLoaded(company)),
    );
  }

  Future<void> updateCompany(String token, CompanyUpdateRequest request) async {
    final currentState = state;

    if (currentState is! CompanyLoaded) {
      emit(const CompanyError(AppStrings.noCompanyToUpdate));
      return;
    }

    emit(CompanyUpdating());

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

    final result = await companyRepository.updateCompany(token, updatedCompany);

    result.fold(
      (failure) => emit(CompanyError(failure.message)),
      (_) => fetchCompanyDetails(token), // Güncellendiyse tekrar fetch yapıyoruz.
    );
  }
}
