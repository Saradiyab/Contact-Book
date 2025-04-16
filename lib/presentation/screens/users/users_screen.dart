import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/presentation/screens/users/create_user_screen.dart';
import 'package:contact_app1/presentation/widgets/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/footer_widget.dart';
import 'package:contact_app1/presentation/widgets/search.dart';
import 'package:contact_app1/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/business_logic/cubit/user_cubit.dart';
import 'package:contact_app1/business_logic/cubit/user_state.dart';

class UsersScreen extends StatefulWidget {
  final String userToken;

  const UsersScreen({Key? key, required this.userToken}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late UserCubit userCubit;
  final Set<String> _selectedUsers = {};

  @override
  void initState() {
    super.initState();
    userCubit = context.read<UserCubit>();
    userCubit.getUserDetails(widget.userToken);
  }

  void _deleteSelectedUsers() async {
    if (_selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No users selected!')),
      );
      return;
    }

    for (var userId in _selectedUsers) {
      await userCubit.deleteOneUser(userId, widget.userToken);
    }

    setState(() {
      _selectedUsers.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected users deleted successfully!')),
    );
  }

  void _toggleUserSelection(String userId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedUsers.add(userId);
      } else {
        _selectedUsers.remove(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: widget.userToken),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Home / Users",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              Divider(color: AppColors.lightgrey),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      'Delete',
                      AppColors.red,
                      _deleteSelectedUsers,
                      backgroundColor: AppColors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      'Invite New User',
                      AppColors.blue,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CreateUserScreen(userToken: widget.userToken),
                          ),
                        ).then((result) {
                          if (result == true) {
                            context
                                .read<UserCubit>()
                                .getUserDetails(widget.userToken);
                          }
                        });
                      },
                      backgroundColor: AppColors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SearchWidget(
                onChanged: (value) {
                  context.read<UserCubit>().filterUsers(value);
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
                child: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is UsersLoaded) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return UserCard(
                            companyId: user.companyId ?? "No ID",
                            firstName: user.firstName,
                            lastName: user.lastName,
                            email: user.email ?? "No Email",
                            phone: user.phoneNumber ?? "No Phone",
                            imagePath: user.company?['logo'] ??
                                'assets/images/default_avatar.png',
                            status: user.status ?? "Unknown",
                            role: user.role ?? "No Role",
                            userId: user.id ?? "0",
                            token: widget.userToken,
                            isSelected: _selectedUsers.contains(user.id),
                            onSelect: (isSelected) {
                              _toggleUserSelection(user.id ?? "0", isSelected);
                            },
                          );
                        },
                      );
                    } else if (state is UserError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }
                    return const Center(child: Text("No users found"));
                  },
                ),
              ),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color borderColor,
    VoidCallback onPressed, {
    Widget? child,
    Color? backgroundColor,
  }) {
    return SizedBox(
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
}
