import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'A Shoes',
      description: 'A black shoes.',
      price: 25.0,
      imageUrl:
          'https://th.bing.com/th/id/OIP.DSuQSEHKFF0a4ST0lqajRQHaHa?pid=ImgDet&rs=1',
    ),
    Product(
      id: 'p6',
      title: 'A Ball',
      description: 'Football.',
      price: 12.5,
      imageUrl:
          'https://th.bing.com/th/id/R.e2449261daea0e5f4b8069ddf5531cd6?rik=S7JP1NQsKOqEFg&riu=http%3a%2f%2fwww.northboroughschool.co.uk%2f_files%2fimages%2fimage_football006.jpg&ehk=ltOIKcwvwnGnYp3rgiDjoOj5UIsCLiLrFvG4ciOrMtI%3d&risl=&pid=ImgRaw&r=0',
    ),
    Product(
      id: 'p7',
      title: 'A Bike',
      description: 'Sport bike for summer vibe.',
      price: 1000.0,
      imageUrl:
          'https://th.bing.com/th/id/R.3ff4292f19668a02d87caed52aedcb54?rik=h1mGzw0k%2fRm0Sw&riu=http%3a%2f%2f3.bp.blogspot.com%2f-gZ5gQeRG6NY%2fTZavzu4Q4uI%2fAAAAAAAABi8%2fLiL7j-ZFbsE%2fs1600%2fbike%2bwallpaper%2bpicture_1.jpeg&ehk=8F4Tl5DPS21jlhZ2TthnOYTn16BMjOeobKu6ti8FMwA%3d&risl=&pid=ImgRaw&r=0',
    ),
    Product(
      id: 'p8',
      title: 'A Bag',
      description: 'A red bag new fashon.',
      price: 21.0,
      imageUrl:
          'https://th.bing.com/th/id/OIP.CF6XGsg1MXUrVgggJYQ33AHaHa?pid=ImgDet&rs=1',
    ),
    Product(
      id: 'p9',
      title: 'A Skirt',
      description: 'Pink skirt for you girl.',
      price: 30.0,
      imageUrl:
          'https://cdn.slidesharecdn.com/ss_thumbnails/skirts2-140108064944-phpapp02-thumbnail-4.jpg?cb=1389163822',
    ),
    Product(
      id: 'p10',
      title: 'A Sunglass',
      description: 'its good for protect from the sun.',
      price: 10.0,
      imageUrl:
          'https://clipartix.com/wp-content/uploads/2016/04/Sunglasses-clipart-free-clip-art-2-clipartbold.png',
    ),
    Product(
      id: 'p11',
      title: 'A Football shoes',
      description: 'A football shoes from NIKE.',
      price: 50.0,
      imageUrl:
          'https://www.suzukinozomu.com/images/large/nike%20soccer%20shoes-696wlt.jpg',
    ),
    Product(
      id: 'p12',
      title: 'A Phone',
      description: 'A smrt phone used for 3 years.',
      price: 150.0,
      imageUrl:
          'https://pngimg.com/uploads/smartphone/smartphone_PNG8499.png',
    ),
    
  ];
  String authToken='';
  String userId='';
  getData(String authTok, String uId, List<Product> products) {
    authToken = authTok;
    userId = uId;
    _items = products;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItem {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filteredString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shop-f6bf1-default-rtdb.firebaseio.com/products.json?auth=$authToken$filteredString';

    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-f6bf1-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favRes = await http.get(Uri.parse(url));
      final favData = json.decode(favRes.body);
      final List<Product> loadedProducts = [];
      
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: favData == null ? false : favData[prodId] ?? false),
        );
      });
      
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-f6bf1-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId
          }));
      final newProduct = Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-f6bf1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-f6bf1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingproductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingproduct = _items[existingproductIndex];
    _items.removeAt(existingproductIndex);
    notifyListeners();
    final res = await http.delete(Uri.parse(url));
    if (res.statusCode >= 400) {
      _items.insert(existingproductIndex, existingproduct);
      notifyListeners();
      throw HttpExcepction('Could not delete Product.');
    }
    existingproduct = null;
  }
}
