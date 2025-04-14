import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final Color? buttonColor;
  final Color? fontColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.buttonColor,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultButtonColor = isOutlined ? Colors.transparent : Colors.blueAccent;
    final Color defaultFontColor = isOutlined ? Colors.blue : Colors.black;

    return isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              side: BorderSide(color: buttonColor ?? Colors.blue),
              foregroundColor: fontColor ?? defaultFontColor,
            ),
            child: Text(text),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: buttonColor ?? defaultButtonColor,
              foregroundColor: fontColor ?? defaultFontColor,
            ),
            child: Text(text),
          );
  }
}
