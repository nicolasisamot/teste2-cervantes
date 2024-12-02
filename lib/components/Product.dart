import 'package:flutter/material.dart';

import '../data/ProductDao.dart';

class Product extends StatefulWidget {
  int code;
  String title;
  final VoidCallback? refresh;

  Product({super.key, required this.code, required this.title, this.refresh});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final _controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _showUpdateForm() {
    _controller.text = widget.title;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Renomear Produto'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: 'Título do Produto'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título';
                    }
                    if (value.length < 3) {
                      return 'Título deve ter pelo menos 3 caracteres';
                    }
                    if (value.length > 50) {
                      return 'Título deve ter no máximo 50 caracteres';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  try {
                    await ProductDao.update(
                        Product(code: widget.code, title: _controller.text));
                    setState(() {
                      widget.title = _controller.text;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text('Título atualizado!')),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: const Text(
                          'Erro inesperado',
                          style:
                              TextStyle(color: Colors.white),
                        ),
                        backgroundColor:
                            Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Container(
          height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              textAlign: TextAlign.left,
                              'Título: ${widget.title}',
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              width: double.infinity,
                              child: Text(
                                textAlign: TextAlign.left,
                                'Código: ${widget.code}',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight:
                                      FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showUpdateForm();
                          },
                          child: Icon(Icons.edit),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            try {
                              if (widget.code != null) {
                                ProductDao.delete(widget.code!);
                                widget.refresh!();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: Text('Produto removido!')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content: const Text(
                                    'Erro inesperado',
                                    style: TextStyle(
                                        color: Colors.white),
                                  ),
                                  backgroundColor: Colors
                                      .red,
                                ),
                              );
                            }
                          },
                          child: Icon(
                            Icons.delete_forever,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
