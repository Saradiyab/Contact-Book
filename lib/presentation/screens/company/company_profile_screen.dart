import 'package:contact_app1/business_logic/cubit/company_cubit.dart';
import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:contact_app1/data/api/company_service.dart';
import 'package:contact_app1/data/repository/company_repository.dart';
import 'package:contact_app1/data/models/company.dart';

class CompanyProfileScreen extends StatefulWidget {
  final String userToken;

  const CompanyProfileScreen({Key? key, required this.userToken})
      : super(key: key);

  @override
  _CompanyProfileScreenState createState() => _CompanyProfileScreenState();
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

  void updateCompany(BuildContext context) {
    final companyCubit = context.read<CompanyCubit>();

    final currentState = companyCubit.state;
    if (currentState is! CompanyLoaded) return;

    final currentCompany = currentState.company;

    Company updatedCompany = Company(
      id: currentCompany.id,
      companyName: companyNameController.text,
      vatNumber: vatNumberController.text,
      streetOne: streetOneController.text,
      streetTwo: streetTwoController.text,
      city: cityController.text,
      state: stateController.text,
      zip: zipController.text,
      country: currentCompany.country,
    );

    companyCubit.updateCompany(widget.userToken, updatedCompany);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompanyCubit(
        companyRepository: CompanyRepository(
          companyService: CompanyService(Dio()),
        ),
      )..fetchCompanyDetails(widget.userToken),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(),
        drawer: CustomDrawer(token:''),
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
                  TextEditingController(text: company.companyName);
              streetOneController =
                  TextEditingController(text: company.streetOne);
              streetTwoController =
                  TextEditingController(text: company.streetTwo ?? "");
              vatNumberController =
                  TextEditingController(text: company.vatNumber);
              zipController = TextEditingController(text: company.zip);
              cityController = TextEditingController(text: company.city);
              stateController = TextEditingController(text: company.state);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Home / Company Profile",
                        style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
                            const Text(
                              "My Profile",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Container(
                                width: 308,
                                height: 218,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/map.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoField("Company Name",
                                companyNameController, isEditing),
                            _buildGrid([
                              _buildInfoField(
                                  "Street", streetOneController, isEditing),
                              _buildInfoField(
                                  "Street 2", streetTwoController, isEditing),
                            ]),
                            _buildGrid([
                              _buildInfoField(
                                  "VAT Number", vatNumberController, isEditing),
                              _buildInfoField("Zip", zipController, isEditing),
                            ]),
                            _buildGrid([
                              _buildInfoField(
                                  "City", cityController, isEditing),
                              _buildInfoField(
                                  "State", stateController, isEditing),
                            ]),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildButton(
                                  isEditing ? "Save" : "Edit",
                                  AppColors.blue,
                                  () {
                                    if (isEditing) {
                                      updateCompany(context);
                                    }
                                    setState(() {
                                      isEditing = !isEditing;
                                    });
                                  },
                                  backgroundColor: isEditing
                                      ? AppColors.blue
                                      : null, 
                                  child: isEditing
                                      ? Text(
                                          "Save",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.edit,
                                                size: 20,
                                                color: AppColors.blue),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Edit",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.blue),
                                            ),
                                          ],
                                        ),
                                ),
                                const SizedBox(height: 10),
                                _buildButton(
                                  "Back",
                                  AppColors.blue,
                                  () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      FooterWidget(),
                    ],
                  ),
                ),
              );
            } else if (state is CompanyError) {
              return Center(
                child: Text("Hata: ${state.message}",
                    style: TextStyle(color: Colors.red)),
              );
            }
            return const Center(
                child: Text("Click the button to see the information."));
          },
        ),
      ),
    );
  }
}

Widget _buildInfoField(
    String label, TextEditingController controller, bool isEditing) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        controller: controller,
        readOnly: !isEditing,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.backgroundColor, 
          labelText: label, 
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.blue, width: 3),
          ),
          floatingLabelStyle: const TextStyle(color: AppColors.blue),
        ),
        cursorColor: AppColors.blue,
      ),
      const SizedBox(height: 12),
    ],
  );
}

Widget _buildGrid(List<Widget> children) {
  return Row(
    children: children
        .map((widget) => Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8), child: widget)))
        .toList(),
  );
}

Widget _buildButton(String text, Color borderColor, VoidCallback onPressed,
    {Widget? child, Color? backgroundColor}) {
  return SizedBox(
    width: 225,
    height: 48,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: backgroundColor ?? Colors.white, 
        backgroundColor: backgroundColor ??
            Colors.white, 
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: child ??
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: backgroundColor != null
                  ? Colors.white
                  : borderColor, 
            ),
          ),
    ),
  );
}
