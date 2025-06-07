import 'package:signflow/utils/config.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String social;

  const SocialButton({super.key, required this.social});

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return SizedBox(
      width: double.infinity, 
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(width: 1, color: Colors.grey),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: <Widget>[
            Image.asset('assets/authimg/$social.png', width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              social.toUpperCase(),
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
