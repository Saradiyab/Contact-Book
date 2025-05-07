import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/core/constants/colors.dart';
import 'package:contact_app1/features/user/presentation/bloc/user_cubit.dart';
import 'package:contact_app1/features/user/presentation/bloc/user_state.dart';
import 'package:contact_app1/features/user/presentation/page/create_user_screen.dart';
import 'package:contact_app1/features/user/presentation/widget/user_build_button.dart';
import 'package:contact_app1/features/user/presentation/widget/users_list_widget.dart';
import 'package:contact_app1/core/widgets/custom_appbar.dart';
import 'package:contact_app1/core/widgets/custom_drawer.dart';
import 'package:contact_app1/core/widgets/footer_widget.dart';
import 'package:contact_app1/core/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildHeader(),
              const SizedBox(height: 10),
              buildActionButtons(),
              const SizedBox(height: 20),
              buildSearchField(),
              const SizedBox(height: 20),
              buildUserList(),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.homeUser.tr(), style: const TextStyle(color: Colors.black, fontSize: 18)),
        const Divider(color: AppColors.lightgrey),
      ],
    );
  }

  Widget buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: UserBuildButton(
            text: AppStrings.delete.tr(),
            borderColor: AppColors.red,
            backgroundColor: AppColors.red,
            onPressed: _delete,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: UserBuildButton(
            text: AppStrings.inviteNewUsers.tr(),
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
    );
  }

  Widget buildSearchField() {
    return SearchWidget(
      onChanged: (value) => userCubit.filterUsers(value),
    );
  }

  Widget buildUserList() {
    return Container(
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
    );
  }
}
