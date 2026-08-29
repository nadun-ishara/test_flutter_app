import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/mock_product_datasource.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/usecases/apply_promo_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'presentation/controllers/cart_controller.dart';
import 'presentation/controllers/catalog_controller.dart';
import 'presentation/controllers/order_controller.dart';
import 'presentation/controllers/wishlist_controller.dart';
import 'presentation/pages/main_navigation_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NovaShopApp());
}

// Alias for hot reload compatibility
typedef NovaShop3DApp = NovaShopApp;

class NovaShopApp extends StatefulWidget {
  const NovaShopApp({super.key});

  @override
  State<NovaShopApp> createState() => _NovaShopAppState();
}

class _NovaShopAppState extends State<NovaShopApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  late final MockProductDataSource _productDataSource;
  late final ProductRepositoryImpl _productRepository;
  late final CartRepositoryImpl _cartRepository;
  late final OrderRepositoryImpl _orderRepository;

  late final GetProductsUseCase _getProductsUseCase;
  late final ApplyPromoUseCase _applyPromoUseCase;

  late final CatalogController _catalogController;
  late final CartController _cartController;
  late final WishlistController _wishlistController;
  late final OrderController _orderController;

  @override
  void initState() {
    super.initState();

    _productDataSource = MockProductDataSource();
    _productRepository = ProductRepositoryImpl(dataSource: _productDataSource);
    _cartRepository = CartRepositoryImpl();
    _orderRepository = OrderRepositoryImpl();

    _getProductsUseCase = GetProductsUseCase(_productRepository);
    _applyPromoUseCase = ApplyPromoUseCase();

    _catalogController = CatalogController(getProductsUseCase: _getProductsUseCase);
    _cartController = CartController(
      cartRepository: _cartRepository,
      applyPromoUseCase: _applyPromoUseCase,
    );
    _wishlistController = WishlistController();
    _orderController = OrderController(orderRepository: _orderRepository);
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaShop - Clean Architecture',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MainNavigationPage(
        catalogController: _catalogController,
        cartController: _cartController,
        wishlistController: _wishlistController,
        orderController: _orderController,
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
