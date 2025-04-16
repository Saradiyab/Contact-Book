import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/data/models/contact.dart';
import 'package:contact_app1/business_logic/cubit/contact_cubit.dart';
import 'package:contact_app1/presentation/screens/contact/contact_details_screen.dart';

class ContactCard extends StatelessWidget {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String imageUrl;
  final ContactStatus? status;
  final String token;
  final bool isSelected;
  final Function(bool) onSelect;
  final bool isStarred;
  final String? email2;
  final String? mobile;
  final String? address;
  final String? address2;

  const ContactCard({
    Key? key,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.status,
    required this.token,
    required this.isSelected,
    required this.onSelect,
    required this.isStarred,
    this.email2,
    this.mobile,
    this.address,
    this.address2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactDetailsScreen(
              id: id!,
              firstName: firstName,
              lastName: lastName,
              email: email,
              phone: phone,
              imageUrl: imageUrl,
              status: status ?? ContactStatus.Inactive,
              token: token,
              email2: email2,
              mobile: mobile,
              address: address,
              address2: address2,
            ),
          ),
        );

        context.read<ContactCubit>().fetchContact();
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        onSelect(newValue);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isStarred ? Icons.star : Icons.star_border,
                      color: isStarred ? Colors.amber : Colors.black54,
                    ),
                    onPressed: () {
                      if (id != null) {
                        context.read<ContactCubit>().toggleFavorite(id!);
                      }
                    },
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
                        id.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.lightgrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 78,
                    height: 26,
                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        status?.name ?? 'Unknown',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: (imageUrl.isNotEmpty &&
                          imageUrl.toLowerCase() != "null")
                      ? NetworkImage(imageUrl)
                      : const AssetImage('assets/images/nophoto.jpg')
                          as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
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
                  email,
                  style: const TextStyle(
                    color: AppColors.lightgrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  phone,
                  style: const TextStyle(
                    color: AppColors.lightgrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(ContactStatus? status) {
    switch (status) {
      case ContactStatus.Active:
        return AppColors.Activecolor;
      case ContactStatus.Pending:
        return AppColors.penddingcolor;
      case ContactStatus.Inactive:
        return AppColors.inActivecolor;
      default:
        return Colors.grey;
    }
  }
}
