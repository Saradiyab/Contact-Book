import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/presentation/screens/users/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/business_logic/cubit/user_cubit.dart';

class UserCard extends StatefulWidget {
  final String companyId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? imagePath;
  final String status;
  final String role;
  final String userId;
  final String token;
  final bool isSelected;
  final Function(bool) onSelect;

  const UserCard({
    Key? key,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.imagePath,
    required this.status,
    required this.role,
    required this.userId,
    required this.token,
    this.isSelected = false,
    required this.onSelect,
  }) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late bool isChecked;
  bool isStarred = false; 

  @override
  void initState() {
    super.initState();
    isChecked = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(
              firstName: widget.firstName,
              lastName: widget.lastName,
              email: widget.email,
              phone: widget.phone,
              role: widget.role,
              userId: widget.userId,
              token: widget.token,
            ),
          ),
        ).then((_) {
          context.read<UserCubit>().getUserDetails(widget.token);
        });
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isChecked = newValue!;
                            widget.onSelect(isChecked);
                          });
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isStarred = !isStarred; 
                      });
                      print("User ${widget.firstName} is ${isStarred ? 'starred' : 'unstarred'}");
                    },
                    child: Icon(
                      isStarred ? Icons.star : Icons.star_border,
                      color: isStarred ? Colors.amber : Colors.black54,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 42,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.idcon,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        widget.userId,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.lightgrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 78,
                    height: 26,
                    decoration: BoxDecoration(
                      color: getStatusColor(widget.status),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        widget.status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 192,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: const AssetImage('assets/images/nophoto.jpg'),
                  ),
                  Text(
                    '${widget.firstName} ${widget.lastName}',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: 275,
                    child: const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      color: AppColors.lightgrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.phone,
                    style: const TextStyle(
                      color: AppColors.lightgrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'active':
      return AppColors.Activecolor;
    case 'pending':
      return AppColors.penddingcolor;
    case 'inactive':
      return AppColors.inActivecolor;
    default:
      return Colors.grey;
  }
}
