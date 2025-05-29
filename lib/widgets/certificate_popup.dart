import 'package:flutter/material.dart';
import 'dart:math' as math;

class CertificatePopup extends StatelessWidget {
  final String userName;
  final String date;

  const CertificatePopup({
    super.key,
    required this.userName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomPaint(
          painter: CertificateBackgroundPainter(),
          child: Stack(
            children: [
              // Decorative leaves (simulated with shapes)
              Positioned(
                top: 10,
                left: 10,
                child: CustomPaint(
                  size: const Size(50, 50),
                  painter: LeafPainter(isLeft: true),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CustomPaint(
                  size: const Size(50, 50),
                  painter: LeafPainter(isLeft: false),
                ),
              ),
              // Logo placeholder (simulated with a circle and text)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'HUẾ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Main title
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'CHỨNG NHẬN',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              // Subtitle
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'HOÀN THÀNH HÀNH TRÌNH HỘ CHIẾU DU LỊCH HUẾ',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // User Name (centered vertically and horizontally)
              Positioned(
                top: 0,
                bottom: 60, // Adjusted to leave space for date at the bottom
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    userName,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Date and Location (at the bottom)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Thành phố Huế, ngày $date',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for the certificate background
class CertificateBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow[50]!
      ..style = PaintingStyle.fill;

    // Draw the background
    canvas.drawRect(Offset.zero & size, paint);

    // Draw fireworks (simulated with circles)
    final fireworkPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(50, 50), 20, fireworkPaint);
    canvas.drawCircle(Offset(size.width - 50, 50), 20, fireworkPaint);
    canvas.drawCircle(Offset(50, size.height - 50), 20, fireworkPaint);
    canvas.drawCircle(
        Offset(size.width - 50, size.height - 50), 20, fireworkPaint);

    // Draw the faint building image (simulated with a gray rectangle)
    final buildingPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.3),
      buildingPaint,
    );

    // Draw grass and flowers (simulated with green and colored dots)
    final grassPaint = Paint()
      ..color = Colors.green[300]!
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      grassPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for leaf decoration
class LeafPainter extends CustomPainter {
  final bool isLeft;

  LeafPainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green[400]!
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isLeft) {
      path.moveTo(0, size.height * 0.5);
      path.quadraticBezierTo(
          size.width * 0.3, 0, size.width, size.height * 0.5);
      path.quadraticBezierTo(
          size.width * 0.3, size.height, 0, size.height * 0.5);
    } else {
      path.moveTo(size.width, size.height * 0.5);
      path.quadraticBezierTo(size.width * 0.7, 0, 0, size.height * 0.5);
      path.quadraticBezierTo(
          size.width * 0.7, size.height, size.width, size.height * 0.5);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
