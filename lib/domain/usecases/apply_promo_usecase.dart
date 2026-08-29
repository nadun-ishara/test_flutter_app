import '../entities/promo_code_entity.dart';

class ApplyPromoUseCase {
  static const List<PromoCodeEntity> _validPromos = [
    PromoCodeEntity(code: 'TEST10', discountRate: 0.10, description: '10% OFF Special Discount'),
    PromoCodeEntity(code: 'SAVE10', discountRate: 0.10, description: '10% OFF Savings Coupon'),
    PromoCodeEntity(code: 'WELCOME20', discountRate: 0.20, description: '20% OFF Welcome Bonus'),
    PromoCodeEntity(code: 'CYBER30', discountRate: 0.30, description: '30% OFF Cyber Special'),
  ];

  PromoCodeEntity? execute(String code) {
    final cleanCode = code.trim().toUpperCase();
    try {
      return _validPromos.firstWhere((p) => p.code == cleanCode);
    } catch (_) {
      return null;
    }
  }
}
