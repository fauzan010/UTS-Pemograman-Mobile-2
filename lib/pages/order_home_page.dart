import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/menu_model.dart';
import '../widgets/menu_card.dart';
import '../blocs/order_cubit.dart';
import 'order_summary_page.dart';
import 'category_stack_page.dart';

class OrderHomePage extends StatefulWidget {
  OrderHomePage({super.key});

  @override
  State<OrderHomePage> createState() => _OrderHomePageState();
}

class _OrderHomePageState extends State<OrderHomePage> {
  // contoh data menu; bisa diganti/diambil dari API
  final List<MenuModel> allMenus = [
    MenuModel(id: 'm1', name: 'Nasi Goreng Spesial', price: 25000, category: 'makanan', discount: 0.1),
    MenuModel(id: 'm2', name: 'Mie Goreng Spesial', price: 20000, category: 'makanan', discount: 0.0),
    MenuModel(id: 'm3', name: 'Ayam Geprek Sambal Merah', price: 30000, category: 'makanan', discount: 0.15),
    MenuModel(id: 'm4', name: 'Chicken Katsu Rice', price: 35000, category: 'makanan', discount: 0.1),
    MenuModel(id: 'm5', name: 'Pop Mie', price: 10000, category: 'makanan', discount: 0.1),
    MenuModel(id: 'm6', name: 'Soto Ayam Lamongan', price: 20000, category: 'makanan', discount: 0.1),
    MenuModel(id: 'm7', name: 'Tahu Crispy', price: 15000, category: 'makanan', discount: 0.1),
    MenuModel(id: 'd1', name: 'Es Teh', price: 8000, category: 'minuman', discount: 0.0),
    MenuModel(id: 'd2', name: 'Es Jeruk', price: 10000, category: 'minuman', discount: 0.05),
    MenuModel(id: 'd3', name: 'Josu', price: 5000, category: 'minuman', discount: 0.0),
    MenuModel(id: 'd4', name: 'Water White', price: 4000, category: 'minuman', discount: 0.0),
    MenuModel(id: 'd5', name: 'Jus Stobery', price: 10000, category: 'minuman', discount: 0.0),
    MenuModel(id: 'd6', name: 'Strawberry MilkShake', price: 20000, category: 'minuman', discount: 0.15),
    MenuModel(id: 'd7', name: 'Thai Tea', price: 15000, category: 'minuman', discount: 0.0),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<MenuModel> get _filteredMenus {
    if (_searchQuery.isEmpty) return allMenus;
    final q = _searchQuery.toLowerCase();
    return allMenus.where((m) => m.name.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eat Guys'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.receipt_long),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => OrderSummaryPage()));
              },
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Menu"),
              Tab(text: "Kategori"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Daftar menu biasa + search
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari menu (mis. nasi goreng)...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredMenus.length,
                    itemBuilder: (context, index) {
                      return MenuCard(menu: _filteredMenus[index]);
                    },
                  ),
                ),

                BlocBuilder<OrderCubit, Map<MenuModel, int>>(
                  builder: (context, state) {
                    final total = context.read<OrderCubit>().getTotalPrice();
                    final finalTotal = context.read<OrderCubit>().getFinalTotal();
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Subtotal: Rp $total", style: const TextStyle(fontSize: 14, color: Colors.black87)),
                              if (finalTotal != total)
                                Text("Total setelah diskon 10%: Rp $finalTotal", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: state.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderSummaryPage())),
                            child: const Text("Lihat Ringkasan"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

            // Tab 2: Kategori menggunakan Stack (halaman terpisah)
            CategoryStackPage(menus: allMenus),
          ],
        ),
      ),
    );
  }
}
