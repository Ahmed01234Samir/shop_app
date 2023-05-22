import 'package:flutter/material.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/badget.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';

enum FilterOption { Favorites, All }

// ignore: camel_case_types
class productOverviewScreen extends StatefulWidget {
  

  @override
  State<productOverviewScreen> createState() => _productOverviewScreenState();
}

// ignore: camel_case_types
class _productOverviewScreenState extends State<productOverviewScreen> {
  var _isLoading = false;
  var _showOnlyFavorites = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(() => _isLoading = false))
        .catchError((_) => setState(()=>_isLoading=false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedVal) {
                setState(() {
                  if (selectedVal == FilterOption.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOption.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOption.All,
                    )
                  ]),
          Consumer<Cart>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(cartScreen.routeName),
                icon: Icon(Icons.shopping_cart)),
            builder: (_, cart, ch) => Badget(
              child: ch!,
              value: cart.itemCount.toString(),
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}
