import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                            "Rp. 3.000.000",
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
                            "Rp. 3.000.000",
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

          //LIST TRANSACTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.edit),
                  ],
                ),
                title: Text("Rp.20.000"),
                subtitle: Text("Makan Siang"),
                leading: Container(
                  child: Icon(
                    Icons.upload,
                    color: Colors.red,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          //LIST TRANSACTION 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.edit),
                  ],
                ),
                title: Text("Rp.50.000"),
                subtitle: Text("Nemu Uang"),
                leading: Container(
                  child: Icon(
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
          )
        ],
      )),
    );
  }
}
