import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/food_detail_controller.dart';
import 'package:hue_passport_app/models/detail_model.dart';

class FoodDetailScreen extends StatelessWidget {
  final DetailModel detailModel;

  const FoodDetailScreen({Key? key, required this.detailModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodDetailController());
    controller.loadDetail(detailModel);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(detailModel.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Giới thiệu'),
              Tab(text: 'Danh sách quán ăn'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(detailModel.image),
                    const SizedBox(height: 16),
                    Text(
                      detailModel.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              itemCount: detailModel.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = detailModel.restaurants[index];
                return ListTile(
                  title: Text(restaurant.name),
                  subtitle: Text(restaurant.address),
                  leading: const Icon(Icons.restaurant),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
