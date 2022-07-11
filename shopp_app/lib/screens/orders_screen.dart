import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                //obsługta błędu
                return const Center(
                  child: Text('Wystąpił błąd'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => orderData.orders.length < 1 ? const Center(child: Text('Nie złożono żadnych zamówień'),) : ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, i) => OrderItem(orderData.orders[i]),
                  ),
                );
              }
            }
          },
        ));
  }
}
