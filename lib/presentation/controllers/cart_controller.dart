import 'package:flutter/material.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/promo_code_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/apply_promo_usecase.dart';

class CartController extends ChangeNotifier {
  final CartRepository cartRepository;
  final ApplyPromoUseCase applyPromoUseCase;

  PromoCodeEntity? _appliedPromo;
  String? _promoErrorMessage;

  CartController({
    required this.cartRepository,
    required this.applyPromoUseCase,
  });

  List<CartItemEntity> get items => cartRepository.getCartItems();
  PromoCodeEntity? get appliedPromo => _appliedPromo;
  String? get promoErrorMessage => _promoErrorMessage;

  int get totalItemCount => items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => items.fold(0, (sum, i) => sum + i.totalPrice);
  double get discount => subtotal * (_appliedPromo?.discountRate ?? 0.0);
  double get shipping => subtotal > 100 || items.isEmpty ? 0.0 : 9.99;
  double get tax => (subtotal - discount) * 0.08;
  double get grandTotal => items.isEmpty ? 0.0 : (subtotal - discount) + shipping + tax;

  void addToCart(ProductEntity product, {Color? color, String? colorName, String? size}) {
    cartRepository.addToCart(product, color: color, colorName: colorName, size: size);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    cartRepository.removeFromCart(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int delta) {
    cartRepository.updateQuantity(productId, delta);
    notifyListeners();
  }

  bool applyPromo(String code) {
    final promo = applyPromoUseCase.execute(code);
    if (promo != null) {
      _appliedPromo = promo;
      _promoErrorMessage = null;
      notifyListeners();
      return true;
    } else {
      _promoErrorMessage = 'Invalid promo code. Try TEST10, WELCOME20, or CYBER30';
      notifyListeners();
      return false;
    }
  }

  void removePromo() {
    _appliedPromo = null;
    _promoErrorMessage = null;
    notifyListeners();
  }

  void clearCart() {
    cartRepository.clearCart();
    _appliedPromo = null;
    _promoErrorMessage = null;
    notifyListeners();
  }
}
