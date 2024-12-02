import 'package:flutter/material.dart';
import 'package:produtosapp/components/Product.dart';
import 'package:produtosapp/data/ProductDao.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
      ),
      body: Container(
        color: Colors.blue[40],
        child: FutureBuilder<List<Product>>(
            future: ProductDao.getAll(),
            builder: (context, snapshot) {
              List<Product>? products = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Carregando produtos...'),
                      ],
                    ),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: const Text(
                          'Erro inesperado',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return Center(
                        child: Text(
                      'Erro ao carregar produtos',
                    ));
                  }
                  if (snapshot.hasData &&
                      products != null &&
                      snapshot.data?.isNotEmpty == true) {
                    return ListView.builder(
                        itemCount: products.length + 1,
                        itemBuilder: (context, index) {
                          if (index == products.length) {
                            return const SizedBox(height: 90);
                          }
                          return Product(
                            code: products[index].code,
                            title: products[index].title,
                            refresh: refresh,
                          );
                        });
                  } else {
                    return Center(child: Text('Nenhum produto cadastrado'));
                  }
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addproduct')
              .then((value) => refresh());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
