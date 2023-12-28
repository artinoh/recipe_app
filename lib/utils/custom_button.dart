import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Future<void> Function() onPressed; // Updated to handle asynchronous functions
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final BorderSide border;
  final double buttonWidth;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.pink,
    this.borderRadius = 0,
    this.border = const BorderSide(color: Colors.pink),
    this.buttonWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth, // Set the width of the button
      child: ElevatedButton(
        onPressed: () => onPressed(), // Call the async function
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 4.0),
          ),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: border,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
