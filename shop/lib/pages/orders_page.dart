import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

// class OrderPage extends StatefulWidget {
//   const OrderPage({super.key});

//   @override
//   State<OrderPage> createState() => _OrderPageState();
// }

// class _OrderPageState extends State<OrderPage> {
//  bool _isLoading = true;

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<OrderList>(context, listen: false).loadOrders().then((_) {
  //     setState(() => _isLoading = false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    //final OrderList orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      // body: _isLoading
      //     ? const Center(child: CircularProgressIndicator())
      //     : RefreshIndicator(
      //         onRefresh: () => _refreshOrders(context),
      //         child: ListView.builder(
      //           itemCount: orders.itemsCount,
      //           itemBuilder: (ctx, i) => OrderWidget(
      //             order: orders.items[i],
      //           ),
      //         ),
      //       ),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Ocorreu um erro...'));
          } else {
            return Consumer<OrderList>(
              builder: (ctx, orders, child) => RefreshIndicator(
                onRefresh: () => _refreshOrders(context),
                child: ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(
                    order: orders.items[i],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
