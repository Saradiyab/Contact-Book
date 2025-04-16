import 'package:contact_app1/business_logic/cubit/contact_cubit.dart';
import 'package:contact_app1/business_logic/cubit/contact_state.dart';
import 'package:contact_app1/presentation/screens/contact/create_contact_screen.dart';
import 'package:contact_app1/presentation/screens/contact/pdf_export_screen.dart';
import 'package:contact_app1/presentation/screens/contact/send_email_screen.dart';
import 'package:contact_app1/presentation/widgets/contact%20widget/contact_card.dart';
import 'package:contact_app1/presentation/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/footer_widget.dart';

class ContactsScreen extends StatefulWidget {
  final String userToken;

  const ContactsScreen({Key? key, required this.userToken}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final Set<int> _selectedContacts = {};
  late ContactCubit contactCubit;

  @override
  void initState() {
    super.initState();
    contactCubit = context.read<ContactCubit>();
    contactCubit.fetchContact();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      contactCubit.fetchContact();
    });
  }

  void _deleteSelectedContact() {
    if (_selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No contact selected!')),
      );
      return;
    }

    for (var contactId in _selectedContacts) {
      contactCubit.deleteOneContact(contactId);
    }

    setState(() {
      _selectedContacts.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected contacts deleted successfully!')),
    );

    contactCubit.fetchContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: widget.userToken),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Home / Contacts", style: TextStyle(fontSize: 18)),
              ),
              const Divider(color: AppColors.lightgrey),
              const SizedBox(height: 10),
              Column(
                children: [
                  SizedBox(
                    width: 358,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateContactScreen(
                                userToken: widget.userToken),
                          ),
                        ).then((_) {
                          if (mounted) {
                            context.read<ContactCubit>().fetchContact();
                          }
                        });
                      },
                      child: const Text(
                        "Create New",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          "Delete",
                          AppColors.red,
                          _deleteSelectedContact,
                          backgroundColor: AppColors.red,
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
              SearchWidget(
                onChanged: (value) {
                  context.read<ContactCubit>().filterContacts(value);
                },
              ),
              const SizedBox(height: 20),
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
                        physics: NeverScrollableScrollPhysics(), 
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
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color borderColor, VoidCallback onPressed,
      {Widget? child, Color? backgroundColor}) {
    return SizedBox(
      width: 171,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: backgroundColor ?? AppColors.white,
          backgroundColor: backgroundColor ?? AppColors.white,
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
                color: backgroundColor != null ? Colors.white : borderColor,
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
            child: OutlinedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.blue,
                side: const BorderSide(color: AppColors.blue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
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
