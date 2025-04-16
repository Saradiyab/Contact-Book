import 'package:contact_app1/presentation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:contact_app1/constants/colors.dart';
import 'package:contact_app1/presentation/widgets/custom_appbar.dart';
import 'package:contact_app1/presentation/widgets/footer_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isUnlocked = false;
  bool isEditing = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(token: '',),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Home / Users / Adam Smith",
                style: TextStyle(color: Colors.black, fontSize: 18)),
            Divider(color: AppColors.lightgrey),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 1),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "User Details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: isUnlocked,
                        onChanged: (bool value) {
                          setState(() {
                            isUnlocked = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("First Name"),
                            const SizedBox(height: 5),
                            TextFormField(
                              initialValue: "Adam",
                              enabled: isEditing, 
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Last Name"),
                            const SizedBox(height: 5),
                            TextFormField(
                              initialValue: "Smith",
                              enabled: isEditing, 
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Email"),
                      const SizedBox(height: 5),
                      TextFormField(
                        initialValue: "adam_smith@email.com",
                        enabled: isEditing,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Phone"),
                      const SizedBox(height: 5),
                      TextFormField(
                        initialValue: "+49 5658 564 613",
                        enabled: isEditing,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Administrator"),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: "Administrator",
                        onChanged: isEditing ? (String? newValue) {} : null,
                        items: ["Administrator", "User", "Guest"]
                            .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              isEditing = !isEditing; 
                            });
                          },
                          icon: Icon(
                            isEditing ? Icons.save : Icons.edit,
                            size: 18,
                            color: AppColors.blue,
                          ),
                          label: Text(
                            isEditing ? "Save" : "Edit",
                            style: const TextStyle(
                                color: AppColors.blue, fontSize: 16),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.blue, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isEditing = false; 
                            });
                          },
                          child: const Text("Cancel",
                              style: TextStyle(
                                  color: AppColors.blue, fontSize: 16)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.blue, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}
