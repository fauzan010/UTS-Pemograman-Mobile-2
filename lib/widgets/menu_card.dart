import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/menu_model.dart';
import '../blocs/order_cubit.dart';

class MenuCard extends StatelessWidget {
  final MenuModel menu;

  const MenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final discountedPrice = menu.getDiscountedPrice();
    final hasDiscount = (menu.discount > 0);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.orange.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.orange.shade50,
              child: const Icon(Icons.fastfood, size: 28, color: Colors.deepOrangeAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(menu.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (hasDiscount)
                        Text(
                          "Rp ${menu.price}",
                          style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.black54),
                        ),
                      if (hasDiscount) const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: hasDiscount ? Colors.red.shade50 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          hasDiscount ? "Rp $discountedPrice" : "Rp ${menu.price}",
                          style: TextStyle(
                            color: hasDiscount ? Colors.redAccent : Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                context.read<OrderCubit>().addToOrder(menu);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${menu.name} ditambahkan"),
                    backgroundColor: Colors.deepOrangeAccent,
                    duration: const Duration(milliseconds: 800),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Icon(Icons.add, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
