import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _formData = <String, Object>{};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
    _imageUrlController.dispose();
  }

  void updateImage() {
    setState(() {});
  }
// Imagen de teste
// https://pngimg.com/uploads/football/football_PNG52725.png

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.isAbsolute ?? false;

    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    bool pop = false;

    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);
      pop = true;
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          icon: const Icon(
            Icons.error,
            color: Colors.red,
            size: 40,
          ),
          content: const Text("Ocorreu um erro ao salvar o produto."),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        if (pop) Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                      ],
                      decoration: const InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (name) {
                        final validatorName = name?.trim() ?? '';

                        if (validatorName.trim().isEmpty) {
                          return 'Nome é obrigatório!';
                        }
                        if (validatorName.trim().length < 3) {
                          return 'Nome precisa de no mínimo 3 letras!';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                      ],
                      decoration: const InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocus,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                      validator: (price) {
                        final priceString = price?.trim() ?? '';
                        final validatorPrice =
                            double.tryParse(priceString) ?? 0.0;

                        if (validatorPrice <= 0) {
                          return 'Informe um preço válido!';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                      ],
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      //textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocus);
                      },
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      validator: (description) {
                        final validatorDescription = description?.trim() ?? '';

                        if (validatorDescription.trim().isEmpty) {
                          return 'Nome é obrigatório!';
                        }
                        if (validatorDescription.trim().length < 10) {
                          return 'Nome precisa de no mínimo 10 letras!';
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                            ],
                            decoration: const InputDecoration(
                                labelText: 'Url da Imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocus,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (imageurl) =>
                                _formData['imageUrl'] = imageurl ?? '',
                            validator: (imageUrl) {
                              final String validatorImageUrl =
                                  imageUrl?.trim() ?? '';
                              if (!isValidImageUrl(validatorImageUrl)) {
                                return 'Informe uma Url válida!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: !isValidImageUrl(_imageUrlController.text)
                              ? const Text('Informe a Url')
                              : Image.network(
                                  _imageUrlController.text,
                                  width: 100,
                                  height: 100,
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
