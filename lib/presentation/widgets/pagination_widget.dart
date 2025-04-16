/*import 'package:contact_app1/constants/colors.dart';
import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final Function(int) onPageChanged;

  const PaginationWidget({
    Key? key,
    required this.currentPage,
    required this.onPageChanged, required int totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// **Geri Git Butonu (Kutu İçinde)**
        _buildPageButton(
          icon: Icons.chevron_left,
          isDisabled: currentPage == 1,
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),

        /// **Sayfa Numaraları (1'den 4'e kadar)
        for (int i = 1; i <= 4; i++)
          _buildPageButton(
            text: i.toString(),
            isSelected: i == currentPage,
            onPressed: () => onPageChanged(i),
          ),

        /// **İleri Git Butonu (Kutu İçinde)**
        _buildPageButton(
          icon: Icons.chevron_right,
          isDisabled: currentPage == 4, // Maksimum sayfa 4
          onPressed: currentPage < 4 ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }

  /// **Küçük kutular için yardımcı widget**
  Widget _buildPageButton({
    String? text,
    IconData? icon,
    bool isSelected = false,
    bool isDisabled = false,
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 40, // Küçük kutu boyutu
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? AppColors.blue : AppColors.white,
            foregroundColor: isSelected ? AppColors.white : AppColors.black,
            padding: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: isSelected ? AppColors.blue : Colors.black12),
            ),
          ),
          onPressed: isDisabled ? null : onPressed,
          child: text != null
              ? Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
              : Icon(icon, size: 18, color: isDisabled ? Colors.grey : Colors.black),
        ),
      ),
    );
  }
}
*/