import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker/pages/models/database.dart';
import 'package:moneytracker/pages/models/transaction_with_category.dart';
import 'package:moneytracker/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;

  const HomePage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase database = AppDatabase();

  int _totalIncome = 0;
  int _totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _logTransactions(); // Log   transactions on initState
    _loadTotalAmount();
  }

  void _logTransactions() async {
    final transactions =
        await database.getTransactionByDateRepo(widget.selectedDate).first;
    print("Transactions on ${widget.selectedDate}: $transactions");
  }

  Future<void> _loadTotalAmount() async {
    final tahun = DateTime.now().year;
    final bulan = DateTime.now().month;
    final result = await database.getTotalAmountByMonthRepo(tahun, bulan);
    setState(() {
      _totalIncome = result['income']!;
      _totalExpense = result['expense']!;
    });
  }

  bool isExpense = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //DADSHBOARD TOTAL INCOME DAN EXSPENSE
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    //ROW INCOME
                    children: [
                      Container(
                        child: Icon(
                          Icons.download,
                          color: Colors.green,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Income",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Rp.$_totalIncome',
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    //ROW OUTCOME
                    children: [
                      Container(
                        child: Icon(
                          Icons.upload,
                          color: Colors.red,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Exspense",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            ' \Rp.$_totalExpense',
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          //TEXT TRANSACTION
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Transaction",
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),

          StreamBuilder<List<TransactionWithCategory>>(
              stream: database.getTransactionByDateRepo(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactionPage(
                                                transactionWithCategory:
                                                    snapshot.data![index],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await database.deleteTransactionRepo(
                                              snapshot
                                                  .data![index].transaction.id);
                                        },
                                      ),
                                    ],
                                  ),
                                  title: Text("Rp." +
                                      snapshot.data![index].transaction.amount
                                          .toString()),
                                  subtitle: Text(snapshot
                                          .data![index].category.name +
                                      "  (" +
                                      snapshot.data![index].transaction.name +
                                      ")"),
                                  leading: Container(
                                    child:
                                        (snapshot.data![index].category.type ==
                                                2)
                                            ? Icon(
                                                Icons.upload,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.download,
                                                color: Colors.green,
                                              ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text("Data transaksi kosong"),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("Tidak ada data"),
                    );
                  }
                }
              }),
        ],
      )),
    );
  }
}
