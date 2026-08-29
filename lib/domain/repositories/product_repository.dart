import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<List<ProductEntity>> getProductsByCategory(String category);
  Future<ProductEntity?> getProductById(String id);
  Future<List<ProductEntity>> searchProducts(String query);
}
