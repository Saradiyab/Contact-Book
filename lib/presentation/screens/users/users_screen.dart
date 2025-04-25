import 'package:contact_app1/business_logic/cubit/user_state.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/presentation/screens/users/create_user_screen.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/custom/custom_drawer.dart';
import 'package:contact_app1/presentation/widgets/custom/footer_widget.dart';
import 'package:contact_app1/presentation/widgets/search.dart';
import 'package:contact_app1/presentation/widgets/users/users_list_widget.dart';
import 'package:contact_app1/presentation/widgets/users/user_build_button.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/business_logic/cubit/user_cubit.dart';

class UsersScreen extends StatefulWidget {
  final String userToken;

  const UsersScreen({super.key, required this.userToken});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  late UserCubit userCubit;
  final Set<String> _selectedUsers = {};

  @override
  void initState() {
    super.initState();
    userCubit = context.read<UserCubit>();
    userCubit.getUserDetails(widget.userToken);
  }

  void _toggleUserSelection(String userId, bool isSelected) {
    setState(() {
      isSelected ? _selectedUsers.add(userId) : _selectedUsers.remove(userId);
    });
  }

  void _delete() async {
    if (_selectedUsers.isNotEmpty) {
      await userCubit.deleteSelectedUsers(_selectedUsers, widget.userToken);
      setState(() {
        _selectedUsers.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: widget.userToken),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserDeleted || state is AllUsersDeleted || state is UserSuccess) {
            userCubit.getUserDetails(widget.userToken);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Home / Users", style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
                Divider(color: AppColors.lightgrey),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: UserBuildButton(
                        text: 'Delete',
                        borderColor: AppColors.red,
                        backgroundColor: AppColors.red,
                        onPressed: _delete,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: UserBuildButton(
                        text: 'Invite New User',
                        borderColor: AppColors.blue,
                        backgroundColor: AppColors.blue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateUserScreen(userToken: widget.userToken),
                            ),
                          ).then((result) {
                            if (result == true) {
                              userCubit.getUserDetails(widget.userToken);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                SearchWidget(
                  onChanged: (value) => userCubit.filterUsers(value),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 356,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: UsersListWidget(
                    token: widget.userToken,
                    selectedUsers: _selectedUsers,
                    onUserSelect: _toggleUserSelection,
                  ),
                ),
                const FooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
