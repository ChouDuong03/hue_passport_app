import 'package:flutter/material.dart';
import 'package:hue_passport_app/screen/tinhthanh/province_model.dart';

class ProvinceDialog extends StatefulWidget {
  final List<Province> provinces;
  final Function(Province selectedProvince) onConfirm;

  const ProvinceDialog({
    Key? key,
    required this.provinces,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _ProvinceDialogState createState() => _ProvinceDialogState();
}

class _ProvinceDialogState extends State<ProvinceDialog> {
  Province? selectedProvince;

  @override
  void initState() {
    super.initState();
    if (widget.provinces.isNotEmpty) {
      selectedProvince = widget.provinces.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chọn tỉnh thành'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          DropdownButtonFormField<Province>(
            isExpanded: true,
            value: selectedProvince,
            decoration: const InputDecoration(
              labelText: 'Tỉnh thành',
              border: OutlineInputBorder(),
            ),
            items: widget.provinces.map((province) {
              return DropdownMenuItem<Province>(
                value: province,
                child: Text(province.tenDiaPhuong),
              );
            }).toList(),
            onChanged: (Province? newValue) {
              setState(() {
                selectedProvince = newValue;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Đóng dialog
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: selectedProvince != null
              ? () {
                  Navigator.of(context).pop(); // Đóng dialog
                  widget.onConfirm(selectedProvince!); // Gửi kết quả
                }
              : null,
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
