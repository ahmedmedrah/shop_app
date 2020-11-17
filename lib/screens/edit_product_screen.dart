import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const String ROUTENAME = '/edit_screen_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onSaved: (val) =>_productModel.title = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onSaved: (val) =>_productModel.price = double.parse(val),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (val) =>_productModel.description = val,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
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
                      onSaved: (val) =>_productModel.imageUrl = val,
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

  void _saveForm() {
    _formKey.currentState.save();
    print(_productModel.title);
  }
}
