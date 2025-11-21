import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_cubit.dart';
import '../models/menu_model.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Pesanan')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<OrderCubit, Map<MenuModel, int>>(
                builder: (context, state) {
                  if (state.isEmpty) {
                    return const Center(child: Text("Belum ada pesanan"));
                  }
                  final entries = state.entries.toList();
                  return ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final menu = entries[index].key;
                      final qty = entries[index].value;
                      final sub = menu.getDiscountedPrice() * qty;
                      return ListTile(
                        title: Text(menu.name),
                        subtitle: Text("Harga per item: Rp ${menu.getDiscountedPrice()} (qty: $qty)"),
                        trailing: Text("Rp $sub"),
                        leading: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            context.read<OrderCubit>().updateQuantity(menu, qty - 1);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            BlocBuilder<OrderCubit, Map<MenuModel, int>>(
              builder: (context, state) {
                final subtotal = context.read<OrderCubit>().getTotalPrice();
                final finalTotal = context.read<OrderCubit>().getFinalTotal();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Subtotal: Rp $subtotal"),
                    if (finalTotal != subtotal)
                      Text("Diskon total otomatis diterapkan. Total akhir: Rp $finalTotal", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: state.isEmpty
                          ? null
                          : () {
                              // contoh tindakan simpan transaksi
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Selesai"),
                                  content: Text("Total yang dibayar: Rp $finalTotal"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        context.read<OrderCubit>().clearOrder();
                                        Navigator.of(context)
                                          ..pop()
                                          ..pop();
                                      },
                                      child: const Text("OK"),
                                    )
                                  ],
                                ),
                              );
                            },
                      child: const Text("Bayar"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
