import 'package:flutter/material.dart';

class ProgramFloatingCard extends StatelessWidget {
  const ProgramFloatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Button
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/banner_banhbeo.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 12,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Tham gia trò chơi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Số món ăn + số tham gia
          const Row(
            children: [
              Icon(Icons.restaurant_menu, color: Colors.red, size: 18),
              SizedBox(width: 4),
              Text("8 Món ăn", style: TextStyle(color: Colors.red)),
              SizedBox(width: 12),
              Icon(Icons.group, color: Colors.green, size: 18),
              SizedBox(width: 4),
              Text("13,9k Tham gia", style: TextStyle(color: Colors.green)),
            ],
          ),

          const SizedBox(height: 12),

          // Tiêu đề
          const Text(
            "Huế Food Tour: Trải nghiệm Ẩm thực Huế 1 ngày",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 8),

          // Mô tả + Xem thêm
          const Text(
            "Không ai biết bánh bèo bắt đầu từ đâu. Gọi là bánh bèo, một phần đơn giản vì hình dạng của nó mỏng manh...",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {}, // TODO: expand mô tả
            child: const Text(
              "Xem thêm",
              style: TextStyle(color: Colors.blue),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            "Món ăn trong chương trình",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Danh sách món ăn ngang
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/monan${index + 1}.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
