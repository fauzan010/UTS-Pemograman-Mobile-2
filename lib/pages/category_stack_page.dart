import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/menu_model.dart';
import '../widgets/menu_card.dart';

class CategoryCubit extends Cubit<String> {
  CategoryCubit() : super('makanan');
  void select(String category) => emit(category);
}

class CategoryStackPage extends StatelessWidget {
  final List<MenuModel> menus;
  const CategoryStackPage({super.key, required this.menus});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Background
              Positioned.fill(child: Container(color: const Color(0xFFFDF7F2))),

              // Header / Banner
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 160,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade300, Colors.orange.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 16),
                      Text(
                        "Kategori",
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Pilih kategori untuk melihat menu",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              // Category Buttons
              Positioned(
                top: 130,
                left: 16,
                right: 16,
                child: BlocBuilder<CategoryCubit, String>(
                  builder: (context, selected) {
                    final categories =
                        menus.map((m) => m.category).toSet().toList();
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((cat) {
                          final active = selected == cat;
                          return GestureDetector(
                            onTap: () =>
                                context.read<CategoryCubit>().select(cat),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: active
                                    ? Colors.deepOrangeAccent
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: active
                                    ? [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 6,
                                            offset: const Offset(0, 3))
                                      ]
                                    : [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: const Offset(0, 2))
                                      ],
                              ),
                              child: Text(
                                cat.toUpperCase(),
                                style: TextStyle(
                                    color:
                                        active ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),

              // Menu List
              Positioned(
                top: 180,
                left: 0,
                right: 0,
                bottom: 0,
                child: BlocBuilder<CategoryCubit, String>(
                  builder: (context, selected) {
                    final filtered =
                        menus.where((m) => m.category == selected).toList();
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return MenuCard(menu: filtered[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
