import 'package:sqflite/sqflite.dart';
import './db.dart';
import '../components/Product.dart';

class ProductDao {

  static Future<void> create(Product product) async {
    final Database db = await getDatabase();

    await db.insert('products', {
      'code': product.code,
      'title': product.title,
    });
  }

  static Future<List<Product>> getAll() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> map = await db.query('products');
    return toList(map);
  }

  static Future<bool> isProductExists(int code) async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> map =
        await db.query('products', where: 'code = ?', whereArgs: [code]);
    return map.isNotEmpty;
  }

  static Future<void> delete(int code) async {
    final Database db = await getDatabase();
    await db.delete('products', where: 'code = ?', whereArgs: [code]);
  }

  static Future<void> update(Product product) async {
    final Database db = await getDatabase();
    await db.update('products', {'title': product.title},
        where: 'code = ?', whereArgs: [product.code]);
  }
}

List<Product> toList(List<Map<String, dynamic>> map) {
  final List<Product> products = [];
  for (Map<String, dynamic> line in map) {
    final Product product = Product(
      title: line['title'],
      code: line['code'],
    );
    products.add(product);
  }
  return products;
}
