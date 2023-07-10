import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: BackButton(
              color: Theme.of(context).colorScheme.primary,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
            ),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 255, 255, 0.6),
                      Color.fromRGBO(255, 255, 255, 0.0)
                    ],
                    begin: Alignment(0, 0.9),
                    end: Alignment(0, 0),
                  )))
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  'R\$ ${product.price}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
        // child: Column(children: []),
      ),
    );
  }
}
