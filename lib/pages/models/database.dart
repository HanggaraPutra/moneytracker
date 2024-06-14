import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:moneytracker/pages/models/category.dart';
import 'package:moneytracker/pages/models/transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart'; // Memastikan jalur file ini benar

@DriftDatabase(tables: [
  Categories,
  Transactions
]) // Memastikan anotasi ditulis dengan benar
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //CRUD KATEGORI

  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories..where((tbl) => tbl.type.equals(type))))
        .get();
  } // Getter harus memiliki tubuh

  Future updatecategoryRepo(int id, String name) async {
    return (update(categories)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriesCompanion(name: Value(name)));
  }
  
  Future deletecategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id)))
       .go();
  }

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cacheBase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cacheBase;

    return NativeDatabase.createInBackground(file);
  });
}
