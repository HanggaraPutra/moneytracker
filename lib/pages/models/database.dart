import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:moneytracker/pages/models/category.dart';
import 'package:moneytracker/pages/models/transaction.dart';
import 'package:moneytracker/pages/models/transaction_with_category.dart';
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
    return await (select(categories)..where((tbl) => tbl.type.equals(type)))
        .get();
  } // Getter harus memiliki tubuh

  Future updatecategoryRepo(int id, String name) async {
    return (update(categories)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriesCompanion(name: Value(name)));
  }

  Future deletecategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  //Transaksi\

  Stream<List<TransactionWithCategory>> getTransactionByDateRepo(
      DateTime date) {
    final query = (select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id))
    ])
      ..where(transactions.transaction_date.equals(date)));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
            row.readTable(transactions), row.readTable(categories));
      }).toList();
    });
  }

  Future updateTransactionRepo(int id, int amount, int categoryId,
      DateTime transactionDate, String nameDetail) async {
    return (update(transactions)..where((tbl) => tbl.id.equals(id))).write(
      TransactionsCompanion(
        name: Value(nameDetail),
        amount: Value(amount),
        category_id: Value(categoryId),
        transaction_date: Value(transactionDate),
      ),
    );
  }

  Future deleteTransactionRepo(int id) async {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

    Future<Map<String, int>> getTotalAmountByMonthRepo(int tahun, int bulan) async {
    // Join transactions dengan categories untuk mendapatkan tipe kategori
    final queryIncome = (select(transactions)
      ..where((tbl) => tbl.transaction_date.year.equals(tahun) &
            tbl.transaction_date.month.equals(bulan) &
            tbl.category_id.equalsExp(categories.id))
    ).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id))
    ])
    ..where(categories.type.equals(1));

    final queryExpense = (select(transactions)
      ..where((tbl) => tbl.transaction_date.year.equals(tahun) &
            tbl.transaction_date.month.equals(bulan) &
            tbl.category_id.equalsExp(categories.id))
    ).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id))
    ])
    ..where(categories.type.equals(2));

    // Execute the queries and extract the results
    final resultsIncome = await queryIncome.get();
    final resultsExpense = await queryExpense.get();

    // Sum the amounts for income and expense
    int totalIncome = resultsIncome.isNotEmpty
        ? resultsIncome.map((row) => row.readTable(transactions).amount).reduce((a, b) => a + b)
        : 0;

    int totalExpense = resultsExpense.isNotEmpty
        ? resultsExpense.map((row) => row.readTable(transactions).amount).reduce((a, b) => a + b)
        : 0;

    return {
      'income': totalIncome,
      'expense': totalExpense,
    };
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
