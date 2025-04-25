import 'package:contact_app1/core/constants/colors.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const SearchWidget({super.key, this.onChanged});

  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  bool isFocused = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              isFocused = hasFocus;
            });
          },
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 358,
                height: 40,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: "Search",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: isFocused ? AppColors.blue : AppColors.lightgrey,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto, 
                    filled: true,
                    fillColor: isFocused
                        ?  Colors.grey[200]
                        : AppColors.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 2,
                width: 358,
                color: isFocused ? AppColors.blue : AppColors.lightgrey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
