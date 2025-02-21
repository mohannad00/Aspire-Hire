// ignore_for_file: file_names, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReusableComponents extends StatelessWidget {
  const ReusableComponents({super.key});

  // Button
  static Widget reusableButton({
    required String title,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    double fontSize = 15.0,
    bool isOutlined = false,
  }) {
    return isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor,
              side: BorderSide(color: backgroundColor),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(fontSize: fontSize),
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(fontSize: fontSize),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
  }

  // (Back Button)
  static Widget reusableBackButton({
    required BuildContext context,
    Color color = const Color.fromRGBO(1, 62, 93, 1),
    double iconSize = 24.0,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: color,
        size: iconSize,
      ),
      onPressed: onPressed ?? () {},
    );
  }

  // Smooth Page Indicator
  static Widget reusablePageIndicator({
    required PageController controller,
    required int count,
  }) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: const ExpandingDotsEffect(
        activeDotColor: Color(0xFF013E5D),
        dotColor: Colors.grey,
        dotHeight: 10,
        dotWidth: 10,
      ),
    );
  }

  // TextField
  static Widget reusableTextField({
    required String hintText,
    Color hintColor = Colors.grey,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.normal,
    double borderRadius = 10.0,
    Color borderColor = Colors.grey,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  // Reusable AppBar
  static PreferredSizeWidget reusableAppBar({
    required String title,
    required VoidCallback onBackPressed,
    List<Widget> actions = const [],
  }) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: onBackPressed,
      ),
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}