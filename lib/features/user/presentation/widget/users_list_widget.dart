import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:contact_app1/features/user/presentation/bloc/user_cubit.dart';
import 'package:contact_app1/features/user/presentation/bloc/user_state.dart';
import 'package:contact_app1/features/user/presentation/widget/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersListWidget extends StatelessWidget {
  final String token;
  final Set<String> selectedUsers;
  final Function(String userId, bool isSelected) onUserSelect;

  const UsersListWidget({
    super.key,
    required this.token,
    required this.selectedUsers,
    required this.onUserSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
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

              final companyId = "N/A";
              final firstName = user.firstName;
              final lastName = user.lastName;
              final email = user.email ?? "No Email";
              final phone = user.phoneNumber ?? "No Phone";
              final imagePath = 'assets/images/default_avatar.png';
              final status = user.status ?? "Unknown";
              final role = user.role ?? "No Role";
              final userId = user.id ?? "0";

              return UserCard(
                companyId: companyId,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                imagePath: imagePath,
                status: status,
                role: role,
                userId: userId,
                token: token,
                isSelected: selectedUsers.contains(user.id),
                onSelect: (isSelected) {
                  onUserSelect(userId, isSelected);
                },
              );
            },
          );
        } else if (state is UserError) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return const Center(child: Text(AppStrings.noUser));
      },
    );
  }
}
