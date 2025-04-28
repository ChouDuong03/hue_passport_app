import 'package:flutter/material.dart';
import 'package:hue_passport_app/ChuongTrinhAmThuc/ChuongTrinhAmThucModel.dart';

class FoodProgramCard extends StatelessWidget {
  final ChuongTrinhAmThuc program;

  const FoodProgramCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: program.anhDaiDien.isNotEmpty
                ? Image.network(
                    'https://localhost:50788/${program.anhDaiDien}',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/anhdaidien1.png',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              program.tenChuongTrinh,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.fastfood, size: 16, color: Colors.red),
                Text(' ${program.soLuongMonAn} Món ăn'),
                const SizedBox(width: 12),
                const Icon(Icons.people, size: 16, color: Colors.green),
                Text(' ${program.soNguoiThamGia} người'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Tham gia trò chơi"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
