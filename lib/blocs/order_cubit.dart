import 'package:bloc/bloc.dart';
import '../models/menu_model.dart';

/// State: Map<MenuModel, int> => menu -> quantity
class OrderCubit extends Cubit<Map<MenuModel, int>> {
  OrderCubit() : super({});

  void addToOrder(MenuModel menu) {
    final newState = Map<MenuModel, int>.from(state);
    newState[menu] = (newState[menu] ?? 0) + 1;
    emit(newState);
  }

  void removeFromOrder(MenuModel menu) {
    final newState = Map<MenuModel, int>.from(state);
    newState.remove(menu);
    emit(newState);
  }

  void updateQuantity(MenuModel menu, int qty) {
    final newState = Map<MenuModel, int>.from(state);
    if (qty <= 0) {
      newState.remove(menu);
    } else {
      newState[menu] = qty;
    }
    emit(newState);
  }

  int getTotalPrice() {
    int total = 0;
    state.forEach((menu, qty) {
      total += menu.getDiscountedPrice() * qty;
    });
    return total;
  }

  /// BONUS: diskon 10% jika total > 100_000
  int getFinalTotal() {
    final total = getTotalPrice();
    if (total > 100000) {
      return (total * 0.9).toInt();
    }
    return total;
  }

  void clearOrder() {
    emit({});
  }
}
