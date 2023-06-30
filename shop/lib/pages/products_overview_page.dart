import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
//import 'package:shop/components/badge.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/utils/app_routes.dart';

enum FilterOptions { favorite, all }

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ProductList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Somente favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showFavoriteOnly = true; // provider.showFavoriteOnly();
                } else {
                  _showFavoriteOnly = false; // provider.showAll();
                }
              });
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.cart);
            },
            icon: Consumer<Cart>(
              child: const Icon(
                Icons.shopping_cart,
              ),
              builder: (ctx, cart, child) => Badge(
                label: Text(cart.itemsCount().toString()),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: child!,
              ),
            ),
          ),
// Consumer<Cart>(
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(AppRoutes.cart);
          //     },
          //     icon: const Icon(
          //       Icons.shopping_cart,
          //     ),
          //   ),
          //   builder: (ctx, cart, child) => BadgeWidget(
          //     value: cart.itemsCount().toString(),
          //     child: child!,
          //   ),
          // ),
        ],
      ),
      body: ProductGrid(
        showFavoriteOnly: _showFavoriteOnly,
      ),
      drawer: const AppDrawer(),
    );
  }
}
