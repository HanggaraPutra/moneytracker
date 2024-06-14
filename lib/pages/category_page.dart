import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker/pages/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  int type = 2;
  final AppDatabase database = AppDatabase();
  TextEditingController categorynameController = TextEditingController();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updateAt: now));
    print('Masuk :' + row.toString());
  }

  Future<List<Category>> getAllCategory(int type) async {
    // Memastikan query Anda di sini benar-benar mengambil data berdasarkan 'type'
    return await (database.select(database.categories)
          ..where((tbl) => tbl.type.equals(type)))
        .get();
  }

  Future update(int categoryId, String newName) async {
    return await database.updatecategoryRepo(categoryId, newName);
  }

  void openDialog(Category? category) {
    if (category != null) {
      categorynameController.text = category.name;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: [
                  Text(
                    (isExpense) ? "Tambah Pengeluaran" : "Tambah Pemasukan",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: (isExpense) ? Colors.red : Colors.green),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: categorynameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Nama"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (category == null) {
                          insert(
                              categorynameController.text, isExpense ? 2 : 1);
                        } else {
                          update(category.id, categorynameController.text);
                        }

                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        setState(() {});
                        categorynameController.clear();
                      },
                      child: Text("Save"))
                ],
              )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                value: isExpense,
                onChanged: (bool value) {
                  setState(() {
                    isExpense = value;
                    type = value ? 2 : 1;
                  });
                },
                inactiveTrackColor: Colors.green[200],
                inactiveThumbColor: Colors.green,
                activeColor: Colors.red,
              ),
              IconButton(
                onPressed: () {
                  openDialog(null);
                },
                icon: Icon(Icons.add),
              )
            ],
          ),
        ),
        FutureBuilder<List<Category>>(
          future: getAllCategory(type),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Card(
                            elevation: 12,
                            child: ListTile(
                              leading: (isExpense)
                                  ? Icon(Icons.upload, color: Colors.red)
                                  : Icon(Icons.download, color: Colors.green),
                              title: Text(
                                snapshot.data![index].name,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        database.deletecategoryRepo(
                                            snapshot.data![index].id);
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.delete)),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        openDialog(snapshot.data![index]);
                                      },
                                      icon: Icon(Icons.edit))
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: Text("Tidak Ada Data"),
                  );
                }
              } else {
                return Center(
                  child: Text("Tidak Ada Data"),
                );
              }
            }
          },
        ),
      ],
    ));
  }
}
