
import 'package:contact_app1/features/company/domain/entities/company.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/models/company_update_request.dart';
import '../../domain/repositories/company_repository.dart';
import 'company_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository companyRepository;

  CompanyCubit({required this.companyRepository}) : super(CompanyInitial());

  Future<void> fetchCompanyDetails(String token) async {
    emit(CompanyLoading());
    final result = await companyRepository.getCompanyDetails(token);

    result.fold(
      (failure) => emit(CompanyError(failure.message.tr())),
      (company) => emit(CompanyLoaded(company)),
    );
  }

  Future<void> updateCompany(String token, CompanyUpdateRequest request) async {
    final currentState = state;

    if (currentState is! CompanyLoaded) {
      emit( CompanyError(AppStrings.noCompanyToUpdate.tr()));
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
      (failure) => emit(CompanyError(failure.message.tr())),
      (_) => fetchCompanyDetails(token), 
    );
  }
}