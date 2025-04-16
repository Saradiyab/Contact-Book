import 'package:flutter/material.dart';

class LatestActivities extends StatelessWidget {
  final List<ActivityItem> activities = [
    ActivityItem(
        name: "Adam Smith",
        date: "01 Jan 2022",
        type: "Access",
        color: Colors.blue,
        user: "David"),
    ActivityItem(
        name: "Adam Smith",
        date: "01 Jan 2022",
        type: "Delete",
        color: Colors.red,
        user: "Matt"),
    ActivityItem(
        name: "Adam Smith",
        date: "01 Jan 2022",
        type: "Update",
        color: Colors.orange,
        user: "Noor"),
    ActivityItem(
        name: "Adam Smith",
        date: "01 Jan 2022",
        type: "Email sent",
        color: Colors.teal,
        user: "David"),
    ActivityItem(
        name: "Adam Smith",
        date: "01 Jan 2022",
        type: "Access",
        color: Colors.blue,
        user: "Matt"),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 353,
        height: 420,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              "Latest activities",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return _buildActivityItem(activities[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                activity.date,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: activity.color),
                  SizedBox(width: 4),
                  Text(
                    activity.type,
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Container(
                width: 84,
                height: 20,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  activity.user,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String name;
  final String date;
  final String type;
  final Color color;
  final String user;

  ActivityItem({
    required this.name,
    required this.date,
    required this.type,
    required this.color,
    required this.user,
  });
}
