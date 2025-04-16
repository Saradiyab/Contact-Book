import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String count;
  final String label;
  final Color color;
  final bool isUp;

  const StatCard({
    Key? key,
    required this.count,
    required this.label,
    required this.color,
    required this.isUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 324,
      height: 159,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 19, 24, 19),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "3% from last month",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
  top: 0,
  right: 0,
  child: Container(
    width: 54,
    height: 54,
    decoration: BoxDecoration(
      color: const Color(0x80FAFAFA), 
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Icon(
        isUp ? Icons.arrow_upward : Icons.arrow_downward,
        color: color, 
        size: 30,
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
