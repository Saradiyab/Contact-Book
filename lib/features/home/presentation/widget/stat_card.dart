import 'package:contact_app1/core/constants/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String count;
  final String label;
  final Color color;
  final bool isUp;

  const StatCard({
    super.key,
    required this.count,
    required this.label,
    required this.color,
    required this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 324,
      height: 159,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10), 
      ),
      padding: const EdgeInsets.fromLTRB(24, 19, 24, 19), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Container(
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
            ],
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
                size: 20,
              ),
              const SizedBox(width: 4),
               Text(
                AppStrings.fromlastmonth.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
