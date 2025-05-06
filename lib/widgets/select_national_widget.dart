import 'package:flutter/material.dart';
import 'package:hue_passport_app/screen/quoctich/quoctich_model.dart';

class SelectNationalityField extends StatelessWidget {
  final List<Nationality> nationalities;
  final Nationality? selectedNationality;
  final ValueChanged<Nationality> onSelected;

  const SelectNationalityField({
    super.key,
    required this.nationalities,
    required this.selectedNationality,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showNationalityDialog(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: selectedNationality?.tenQuocTich ?? 'Chọn quốc tịch',
            prefixIcon: const Icon(Icons.public),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  void _showNationalityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        Nationality? tempSelected = selectedNationality;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Chọn quốc tịch'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView(
              children: nationalities.map((n) {
                return RadioListTile<Nationality>(
                  value: n,
                  groupValue: tempSelected,
                  title: Text(n.tenQuocTich),
                  onChanged: (value) {
                    if (value != null) {
                      Navigator.pop(context); // đóng dialog
                      onSelected(value); // gọi callback
                    }
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
