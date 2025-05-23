import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterSuccessDialog extends StatelessWidget {
  final VoidCallback onClose;
  final String email; // thêm dòng này

  const RegisterSuccessDialog({
    super.key,
    required this.onClose,
    required this.email, // thêm dòng này
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE6FAF1),
                  ),
                  child: Image.asset(
                    'assets/images/success.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        'Bạn đã đăng ký tài khoản thành công.\nKiểm tra email ',
                    style: const TextStyle(
                      color: Color(0xFF234874),
                      fontSize: 16,
                      fontFamily: 'Mulish',
                    ),
                    children: [
                      TextSpan(
                        text: email, // dùng email truyền vào
                        style: const TextStyle(
                          color: Color(0xFF0094FF),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // có thể mở app email tại đây nếu muốn
                          },
                      ),
                      const TextSpan(
                        text: ' để lấy mật khẩu đăng nhập.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: onClose,
              child: const Icon(Icons.close, color: Color(0xFFBFC9DA)),
            ),
          ),
        ],
      ),
    );
  }
}
