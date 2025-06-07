import 'package:flutter/material.dart';
import 'package:signflow/utils/config.dart';

class Button extends StatelessWidget {
  final double width;
  final String title;
  final bool disable;
  final Future<void> Function()? onPressed;

  const Button({
    super.key,
    required this.width,
    required this.title,
    required this.onPressed,
    required this.disable,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Config.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: disable ? null : onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
