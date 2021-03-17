import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/progress_indicator.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusController = FocusNode();
  final _form = GlobalKey<FormState>();
  String appBar = "";
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        setState(() {
          appBar = "Edit Product";
        });
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
      } else {
        setState(() {
          appBar = "Add Product";
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusController.removeListener(_updateImageUrl);

    _imageUrlController.dispose();
    _imageUrlFocusController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusController.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('Something went wrong!'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBar),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CustomProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: _editedProduct.title,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a title.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          title: value,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: _editedProduct.price.toString() == '0.0'
                          ? ''
                          : _editedProduct.price.toString(),
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please provide a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please provide a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value),
                          title: _editedProduct.title,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: _editedProduct.description,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          title: _editedProduct.title,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Product Image URL',
                        prefixIcon: _imageUrlController.text.isEmpty ||
                                _imageUrlController.text == ""
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.fill,
                                  width: 50,
                                  height: 50,
                                  // scale: 15,
                                ),
                              ),
                      ),
                      keyboardType: TextInputType.url,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(fontSize: 18),
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusController,
                      // initialValue: _editedProduct.imageUrl != null
                      //     ? _editedProduct.imageUrl
                      //     : ' ',
                      onFieldSubmitted: (_) => _saveForm(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide an Image URL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please provide a valid Image URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please provide a valid Image URL';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          imageUrl: value,
                          price: _editedProduct.price,
                          title: _editedProduct.title,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
