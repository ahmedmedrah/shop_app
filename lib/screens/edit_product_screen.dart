import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String ROUTENAME = '/edit_screen_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _isInit = true;
  var _isLoading = false;
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ProductModel _productModel = ProductModel(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _productModel = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _imageUrlController.text = _productModel.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _productModel.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onSaved: (val) => _productModel.title = val,
                      validator: (value) {
                        if (value.isEmpty || value.trim() == '')
                          return 'Please enter a title';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _productModel.price.toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onSaved: (val) => _productModel.price = double.parse(val),
                      validator: (value) {
                        if (value.isEmpty || value.trim() == '')
                          return 'Please enter a price';
                        if (double.tryParse(value) == null)
                          return 'please enter a valid number';
                        if (double.tryParse(value) <= 0)
                          return 'Please enter a number greater than zero';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _productModel.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (val) => _productModel.description = val,
                      validator: (value) {
                        if (value.isEmpty || value.trim() == '')
                          return 'Please enter a description';
                        if (value.length <= 20)
                          return 'Please enter more description';
                        return null;
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
                              border: Border.all(color: Colors.grey)),
                          child: _imageUrlController.text.isNotEmpty
                              ? FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text('Enter URL'),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onSaved: (val) => _productModel.imageUrl = val,
                            validator: (value) {
                              if (value.isEmpty || value.trim() == '')
                                return 'Please enter an image';
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https'))
                                return 'Please enter a valid image url';
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg'))
                                return 'Please enter a valid image url';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: RaisedButton.icon(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: _saveForm,
                        icon: Icon(
                          Icons.save,
                          size: 35,
                        ),
                        label: Text(
                          'Save',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_productModel.id == null) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_productModel);
      } catch (e) {
        print(e.toString());
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('error occur'),
                content: Text('Something went wrong!'),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Okay'))
                ],
              );
            });
      }
    } else {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_productModel.id, _productModel);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }
}
