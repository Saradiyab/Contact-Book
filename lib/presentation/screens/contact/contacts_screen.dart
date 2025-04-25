import 'package:contact_app1/presentation/screens/contact/pdf_export_screen.dart';
import 'package:contact_app1/presentation/screens/contact/send_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/business_logic/cubit/contact_cubit.dart';
import 'package:contact_app1/business_logic/cubit/contact_state.dart';
import 'package:contact_app1/presentation/screens/contact/create_contact_screen.dart';
import 'package:contact_app1/presentation/widgets/contact widget/button_widget.dart';
import 'package:contact_app1/presentation/widgets/contact widget/contact_card.dart';
import 'package:contact_app1/presentation/widgets/search.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/custom/footer_widget.dart';

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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Home / Contacts", style: TextStyle(fontSize: 18)),
              ),
              const Divider(color: AppColors.lightgrey),
              const SizedBox(height: 10),

              /// Action Buttons
              Column(
                children: [
                  ButtonWidget(
                    text: "Create New",
                    borderColor: AppColors.green,
                    backgroundColor: AppColors.green,
                    onPressed: () async {
                      if (!mounted) return; // önce kontrol
                      final navigator = Navigator.of(context);
                      final cubit = context.read<ContactCubit>();

                      await navigator.push(
                        MaterialPageRoute(
                          builder: (_) =>
                              CreateContactScreen(userToken: widget.userToken),
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
                          text: "Delete",
                          borderColor: AppColors.red,
                          backgroundColor: AppColors.red,
                          onPressed: _deleteSelectedContacts,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPopupButton(context),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Search
              SearchWidget(
                onChanged: (value) =>
                    context.read<ContactCubit>().filterContacts(value),
              ),

              const SizedBox(height: 20),

              /// Contact List
              Container(
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
                        return const Center(
                            child: Text("No contacts available."));
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
                    return const Center(child: Text("No contacts available."));
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// Footer
              const FooterWidget(),
            ],
          ),
        ),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white,
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'pdf',
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('PDF File'),
              ),
              PopupMenuItem<String>(
                value: 'email',
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Send via Email'),
              ),
            ],
            onSelected: (value) {
              final state = context.read<ContactCubit>().state;
              if (value == 'pdf') {
                if (state is ContactsLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfExportScreen(contacts: state.contacts),
                    ),
                  );
                }
              } else if (value == 'email') {
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
              child: const Text(
                "Export to",
                style: TextStyle(
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
