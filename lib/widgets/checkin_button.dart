import 'package:flutter/material.dart';

class CheckInButton extends StatelessWidget {
  final bool isCheckedIn;
  final VoidCallback onTap;

  const CheckInButton({
    super.key,
    required this.isCheckedIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: isCheckedIn
                  ? [
                      const Color(0xFF00C851),
                      const Color(0xFF007E33)
                    ] // Gradient xanh lá
                  : [
                      const Color(0xFFFF8A00),
                      const Color(0xFFFFC107)
                    ], // Gradient cam
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isCheckedIn ? 'Đã check in' : 'Check in',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
