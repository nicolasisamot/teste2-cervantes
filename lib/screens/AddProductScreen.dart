import 'package:flutter/material.dart';
import 'package:produtosapp/components/Product.dart';
import '../data/ProductDao.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _codeErrorMessage;

  void _saveProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String title = _titleController.text;
        String code = _codeController.text;

        bool isProductExists =
            await ProductDao.isProductExists(int.parse(code));

        if (isProductExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration:  Duration(seconds: 2),
              content:  Text(
                'Código de produto já existente',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _codeErrorMessage = 'Produto com este código já existe!';
          });
          return;
        }

        Product product = Product(title: title, code: int.parse(code));
        await ProductDao.create(product);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration:  Duration(seconds: 1),
            content:  Text('Produto adicionado!'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration:  Duration(seconds: 2),
            content:  Text(
              'Erro inesperado',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Produto"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Título do Produto',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o título do produto';
                      }
                      if (value.length < 3) {
                        return 'Por favor, insira um título com pelo menos 3 caracteres';
                      }
                      if (value.length > 50) {
                        return 'Por favor, insira um título com menos de 50 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Código do Produto',
                      errorText: _codeErrorMessage,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o código do produto';
                      }

                      if (int.tryParse(value) == null) {
                        return 'Por favor, insira um código numérico';
                      }
                      if (int.parse(value) <= 0) {
                        return 'Por favor, insira um código maior que zero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: const Text('Adicionar Produto'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
