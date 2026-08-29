import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> execute({String? category, String? searchQuery, String? sortBy}) async {
    List<ProductEntity> products = await repository.getProducts();

    if (category != null && category != 'All') {
      products = products
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.description.toLowerCase().contains(query))
          .toList();
    }

    if (sortBy != null) {
      if (sortBy == 'Price: Low to High') {
        products.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortBy == 'Price: High to Low') {
        products.sort((a, b) => b.price.compareTo(a.price));
      } else if (sortBy == 'Rating') {
        products.sort((a, b) => b.rating.compareTo(a.rating));
      }
    }

    return products;
  }
}
