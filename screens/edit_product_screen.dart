import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import '../providers/products.dart';

// ignore: camel_case_types
class editProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<editProductScreen> createState() => _editProductScreenState();
}

// ignore: camel_case_types
class _editProductScreenState extends State<editProductScreen> {
  final _priceFocusedNode = FocusNode();
  final _descriptionFocusedNode = FocusNode();
  final _imageUrlConrtoller = TextEditingController();
  final _imageUrlFocusedNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    _imageUrlFocusedNode.addListener(_updateImageUrl);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments ;
      if (productId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId as String);
        _initialValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlConrtoller.text = _editProduct.imageUrl;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageUrlFocusedNode.removeListener(_updateImageUrl);
    _priceFocusedNode.dispose();
    _imageUrlFocusedNode.dispose();
    _imageUrlConrtoller.dispose();
    _descriptionFocusedNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusedNode.hasFocus) {
      if ((!_imageUrlConrtoller.text.startsWith('http') &&
              !_imageUrlConrtoller.text.startsWith('https')) 
          ) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    // ignore: unnecessary_null_comparison
    if (_editProduct.id != null) {
     
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Okay!'))
                  ],
                ));
      }
      
    }
    setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(16),
                child: Form(key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initialValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusedNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              title: value!,
                              description: _editProduct.description,
                              price: _editProduct.price,
                              imageUrl: _editProduct.imageUrl,
                              isFavorite: _editProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusedNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusedNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter a valid price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'please enter a valid price.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              price: double.parse(value!),
                              imageUrl: _editProduct.imageUrl,
                              isFavorite: _editProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusedNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter a description.';
                          }
                          if (value.length <= 10) {
                            return 'should be at least 10 characters long.';
                          }
                
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              title: _editProduct.title,
                              description: value!,
                              price: _editProduct.price,
                              imageUrl: _editProduct.imageUrl,
                              isFavorite: _editProduct.isFavorite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlConrtoller.text.isEmpty
                                ? Text('enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlConrtoller.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _imageUrlConrtoller,
                              decoration: InputDecoration(labelText: 'Image URl'),
                              keyboardType: TextInputType.url,
                              focusNode: _imageUrlFocusedNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter a image URL.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'please enter a valid URL.';
                                }
                                
                
                                return null;
                              },
                              onSaved: (value) {
                                _editProduct = Product(
                                    id: _editProduct.id,
                                    title: _editProduct.title,
                                    description: _editProduct.description,
                                    price: _editProduct.price,
                                    imageUrl: value!,
                                    isFavorite: _editProduct.isFavorite);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}
