import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/contact/presentation/bloc/conatct_cubit.dart';
import 'package:contact_app1/features/contact/presentation/bloc/contact_state.dart';
import 'package:contact_app1/features/contact/presentation/page/create_contact_screen.dart';
import 'package:contact_app1/features/contact/presentation/page/pdf_export_screen.dart';
import 'package:contact_app1/features/contact/presentation/page/send_email_screen.dart';
import 'package:contact_app1/features/contact/presentation/widget/button_widget.dart';
import 'package:contact_app1/features/contact/presentation/widget/contact_card.dart';
import 'package:contact_app1/core/widgets/custom_appbar.dart';
import 'package:contact_app1/core/widgets/custom_drawer.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:contact_app1/core/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactsScreen extends StatefulWidget {
  final String userToken;

  const ContactsScreen({super.key, required this.userToken});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final Set<int> _selectedContacts = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<ContactCubit>().fetchContact();
    });
  }

  void _deleteSelectedContacts() {
    if (_selectedContacts.isEmpty) return;
    for (var id in _selectedContacts) {
      context.read<ContactCubit>().deleteOneContact(id);
    }
    setState(() {
      _selectedContacts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: widget.userToken),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildBreadcrumb(),
              const Divider(color: AppColors.lightgrey),
              const SizedBox(height: 10),
              _buildActionButtons(),
              const SizedBox(height: 20),
              _buildSearchWidget(),
              const SizedBox(height: 20),
              _buildContactList(),
              const SizedBox(height: 20),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildBreadcrumb() {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Directionality(
      textDirection: Directionality.of(context),
      child: Text(
        AppStrings.homeContacts.tr(),
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.start, 
      ),
    ),
  );
}


  Widget _buildActionButtons() {
    return Column(
      children: [
        ButtonWidget(
          text: AppStrings.createNew.tr(),
          borderColor: AppColors.green,
          backgroundColor: AppColors.green,
          onPressed: () async {
            if (!mounted) return;
            final navigator = Navigator.of(context);
            final cubit = context.read<ContactCubit>();

            await navigator.push(
              MaterialPageRoute(
                builder: (_) => CreateContactScreen(userToken: widget.userToken),
              ),
            );

            if (!mounted) return;
            cubit.fetchContact();
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ButtonWidget(
                text: AppStrings.delete.tr(),
                borderColor: AppColors.red,
                backgroundColor: AppColors.red,
                onPressed: _deleteSelectedContacts,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildPopupButton(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchWidget() {
    return SearchWidget(
      onChanged: (value) =>
          context.read<ContactCubit>().filterContacts(value),
    );
  }

  Widget _buildContactList() {
    return Container(
      width: 356,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<ContactCubit, ContactState>(
        builder: (context, state) {
          if (state is ContactLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactsLoaded) {
            if (state.contacts.isEmpty) {
              return Center(child: Text(AppStrings.noContacts.tr()));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return ContactCard(
                  key: ValueKey(contact.id),
                  id: contact.id,
                  firstName: contact.firstName,
                  lastName: contact.lastName,
                  email: contact.email,
                  phone: contact.phoneNumber,
                  imageUrl: contact.imageUrl ?? '',
                  status: contact.status,
                  token: widget.userToken,
                  email2: contact.emailTwo,
                  mobile: contact.mobileNumber,
                  address: contact.address,
                  address2: contact.addressTwo,
                  isSelected: _selectedContacts.contains(contact.id),
                  isStarred: contact.isFavorite,
                  onSelect: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        _selectedContacts.add(contact.id!);
                      } else {
                        _selectedContacts.remove(contact.id);
                      }
                    });
                  },
                );
              },
            );
          } else if (state is ContactError) {
            return Center(
              child: Column(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 8),
                  Text("Error: ${state.message}"),
                ],
              ),
            );
          }
          return Center(child: Text(AppStrings.noContacts.tr()));
        },
      ),
    );
  }

  Widget _buildPopupButton(BuildContext context) {
    return SizedBox(
      height: 48,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double btnWidth = constraints.maxWidth;
          return PopupMenuButton<String>(
            constraints: BoxConstraints.tightFor(width: btnWidth),
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: AppStrings.pdf,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(AppStrings.pdfFile.tr()),
              ),
              PopupMenuItem<String>(
                value: AppStrings.email,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(AppStrings.sendEmail.tr()),
              ),
            ],
            onSelected: (value) {
              final state = context.read<ContactCubit>().state;
              if (value == AppStrings.pdf) {
                if (state is ContactsLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfExportScreen(contacts: state.contacts),
                    ),
                  );
                }
              } else if (value == AppStrings.email) {
                if (state is ContactsLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SendEmailScreen(contacts: state.contacts),
                    ),
                  );
                }
              }
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.blue, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                AppStrings.exportTo.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
