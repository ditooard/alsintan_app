import 'package:alsintan_app/views/detail_alsintan_page.dart';
import 'package:flutter/material.dart';
import 'package:alsintan_app/models/book.dart';
import 'package:alsintan_app/models/user.dart';
import 'package:alsintan_app/services/myserverconfig.dart';
import 'package:alsintan_app/views/user/tambah_alsintan_page.dart';

class DashboardUser extends StatefulWidget {
  @override
  State<DashboardUser> createState() => _DashboardUser();
}

class _DashboardUser extends State<DashboardUser> {
  List<Book> bookList = <Book>[];
  late double screenWidth, screenHeight;

  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  var color;
  String title = "";
  String author = "";

  @override
  void initState() {
    super.initState();
    loadBooks(title, author);
  }

  bool isSearchVisible = false;
  int axiscount = 2;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: 50, bottom: 10),
          child: Text('Alat dan Mesin Pertanian'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshBooks(author, title);
        },
        child: bookList.isEmpty
            ? const Center(child: Text("No Data"))
            : Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(bookList.length, (index) {
                        return Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailAlsintan(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: Container(
                                    width: screenWidth,
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      "assets/images/${bookList[index].bookId}.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        truncateString(bookList[index]
                                            .bookTitle
                                            .toString()),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahAlsintan()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF31C48D),
      ),
    );
  }

  String truncateString(String str) {
    if (str.length > 20) {
      str = str.substring(0, 20);
      return str + "...";
    } else {
      return str;
    }
  }

  Future<void> refreshBooks(String title, author) async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      loadDummyBooks();
    });
  }

  void loadBooks(String title, author) {
    setState(() {
      loadDummyBooks();
    });
  }

  void loadDummyBooks() {
    bookList = [
      Book(
        bookId: '1',
        bookTitle: 'Traktor Roda 2',
        bookAuthor: 'Author 1',
        bookPrice: '10.0',
        bookQty: '5',
      ),
      Book(
        bookId: '2',
        bookTitle: 'Traktor Roda 2',
        bookAuthor: 'Author 2',
        bookPrice: '15.0',
        bookQty: '3',
      ),
      Book(
          bookId: '3',
          bookTitle: 'Traktor Roda 2',
          bookAuthor: 'Author 3',
          bookPrice: '20.0',
          bookQty: '7'),
      Book(
          bookId: '3',
          bookTitle: 'Traktor Roda 2',
          bookAuthor: 'Author 3',
          bookPrice: '20.0',
          bookQty: '7'),
    ];
    numofpage = 1;
    numofresult = bookList.length;
  }
}
