import 'package:flutter/material.dart';
import '../models/visitor_data.dart';

class VisitorCard extends StatelessWidget {
  final Visitor visitor;

  const VisitorCard({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(visitor.avatarUrl),
        ),
        title: Text(visitor.name),
        subtitle: Text('${visitor.program} • ${visitor.location}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(visitor.mhc),
            Text(visitor.country, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
