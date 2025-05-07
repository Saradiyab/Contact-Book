import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/company/data/datasources/company_remote_data_source_impl.dart';
import 'package:contact_app1/features/company/data/datasources/company_service.dart';
import 'package:contact_app1/features/company/data/models/company_update_request.dart';
import 'package:contact_app1/features/company/data/repositories/company_repository_impl.dart';
import 'package:contact_app1/features/company/presentation/bloc/company_cubit.dart';
import 'package:contact_app1/features/company/presentation/bloc/company_state.dart';
import 'package:contact_app1/features/company/presentation/widget/company_action_buttons.dart';
import 'package:contact_app1/features/company/presentation/widget/company_info_field.dart';
import 'package:contact_app1/core/widgets/custom_appbar.dart';
import 'package:contact_app1/core/widgets/custom_drawer.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:contact_app1/core/constants/colors.dart';


class CompanyProfileScreen extends StatefulWidget {
  final String userToken;

  const CompanyProfileScreen({super.key, required this.userToken});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  bool isEditing = false;

  late TextEditingController companyNameController;
  late TextEditingController streetOneController;
  late TextEditingController streetTwoController;
  late TextEditingController vatNumberController;
  late TextEditingController zipController;
  late TextEditingController cityController;
  late TextEditingController stateController;

  @override
  void dispose() {
    companyNameController.dispose();
    streetOneController.dispose();
    streetTwoController.dispose();
    vatNumberController.dispose();
    zipController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
     create: (context) => CompanyCubit(
  companyRepository: CompanyRepositoryImpl(
   companyRemoteDataSource:CompanyRemoteDataSourceImpl(
  companyService: CompanyService(Dio()), 

),
)
      )..fetchCompanyDetails(widget.userToken.tr()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(),
        drawer: CustomDrawer(token: ''),
        body: BlocConsumer<CompanyCubit, CompanyState>(
          listener: (context, state) {
            if (state is CompanyLoaded) {
              setState(() {
                isEditing = false;
              });
            }
          },
          builder: (context, state) {
            if (state is CompanyLoading || state is CompanyUpdating) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CompanyLoaded) {
              final company = state.company;

              companyNameController =
                  TextEditingController(text: company.companyName.tr());
              streetOneController =
                  TextEditingController(text: company.streetOne.tr());
              streetTwoController =
                  TextEditingController(text: company.streetTwo ?? "".tr());
              vatNumberController =
                  TextEditingController(text: company.vatNumber.tr());
              zipController = TextEditingController(text: company.zip.tr());
              cityController = TextEditingController(text: company.city.tr());
              stateController = TextEditingController(text: company.state.tr());

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      AppStrings.homeCompanyProfile.tr(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            AppStrings.myProfile.tr(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              width: 308,
                              height: 218,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/map.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CompanyInfoField(
                            companyNameController: companyNameController,
                            streetOneController: streetOneController,
                            streetTwoController: streetTwoController,
                            vatNumberController: vatNumberController,
                            zipController: zipController,
                            cityController: cityController,
                            stateController: stateController,
                            isEditing: isEditing,
                          ),
                          const SizedBox(height: 10),
                          CompanyActionButtons(
                            isEditing: isEditing,
                            onSaveOrEdit: () {
                              if (isEditing) {
                                final request = CompanyUpdateRequest(
                                  companyName:
                                      companyNameController.text.trim(),
                                  vatNumber: vatNumberController.text.trim(),
                                  streetOne: streetOneController.text.trim(),
                                  streetTwo: streetTwoController.text.trim(),
                                  city: cityController.text.trim(),
                                  state: stateController.text.trim(),
                                  zip: zipController.text.trim(),
                                );

                                context
                                    .read<CompanyCubit>()
                                    .updateCompany(widget.userToken, request);
                              }

                              setState(() {
                                isEditing = !isEditing;
                              });
                            },
                            onBack: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const FooterWidget(),
                  ],
                ),
              );
            } else if (state is CompanyError) {
              return Center(
                child: Text("Hata: ${state.message.tr()}",
                    style: const TextStyle(color: Colors.red)),
              );
            }

            return Center(
              child: Text(AppStrings.seeTheInformation.tr()),
            );
          },
        ),
      ),
    );
  }
}