import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ProductDao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'products.db');
  return openDatabase(
    path,
    version: 2,
    onCreate: (Database db, int version) async {

      await db.execute('''
          CREATE TABLE products (
            code INTEGER PRIMARY KEY CHECK (code > 0) UNIQUE NOT NULL,
            title TEXT NOT NULL CHECK (title <> '')
          );
        ''');

      await db.execute('''
          CREATE TABLE log_operations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            operation TEXT NOT NULL,
            table_name TEXT NOT NULL,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
            description TEXT
          );
        ''');

      await db.execute('''
          CREATE TRIGGER trigger_insert_product
          AFTER INSERT ON products
          FOR EACH ROW
          BEGIN
              INSERT INTO log_operations (operation, table_name, description)
              VALUES ('INSERT', 'products', 'Insertion of product with code: ' || NEW.code || ' and title: ' || NEW.title);
          END;
        ''');

      await db.execute('''
          CREATE TRIGGER trigger_update_product
          AFTER UPDATE ON products
          FOR EACH ROW
          BEGIN
              INSERT INTO log_operations (operation, table_name, description)
              VALUES ('UPDATE', 'products', 'Update of product with code: ' || NEW.code || ', title changed from: ' || OLD.title || ' to: ' || NEW.title);
          END;
        ''');

      await db.execute('''
          CREATE TRIGGER trigger_delete_product
          AFTER DELETE ON products
          FOR EACH ROW
          BEGIN
              INSERT INTO log_operations (operation, table_name, description)
              VALUES ('DELETE', 'products', 'Deletion of product with code: ' || OLD.code || ' and title: ' || OLD.title);
          END;
        ''');
    },
  );
}
