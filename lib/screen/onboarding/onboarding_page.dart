import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final Widget? extraContent; // Thêm biến này để chèn nút nếu có

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset(
          imagePath,
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.45,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Mulish',
            fontWeight: FontWeight.bold,
            color: Color(0xFF234874),
          ),
        ),
        if (extraContent != null) ...[
          const SizedBox(height: 30),
          extraContent!,
        ],
      ],
    );
  }
}
