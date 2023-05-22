import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Product'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(editProductScreen.routeName),
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, AsyncSnapshot snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                                itemCount: productsData.items.length,
                                itemBuilder: (_, int index) => Column(
                                      children: [
                                        UserProductItem(
                                            productsData.items[index].id,
                                            productsData.items[index].title,
                                            productsData.items[index].imageUrl),
                                        Divider(),
                                      ],
                                    )),
                          )),
                )),
      drawer: AppDrawer(),
    );
  }
}
