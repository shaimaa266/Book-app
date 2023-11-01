
import 'package:flutter/material.dart';

import 'model.dart';
import 'data_base.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {
  List<Book> bookList = [];
  TextEditingController booknameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0977cb),
        centerTitle: true,
        title: const Text(
          'Available Books',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Book>>(
            future: BookProvider.instance.getBook(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                bookList = snapshot.data!;
                return ListView.builder(
                    itemCount: bookList.length,
                    itemBuilder: (context, index) {
                      Book book = bookList[index];
                      return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Expanded(
                            flex: 3,
                            child: ListTile(
                              leading: Container(
                                color: Colors.lightBlue,
                                height: 250,
                                width: 100,
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    book.image.toString(),
                                  ),
                                ),
                              ),
                              title: Text(
                                book.Name.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  "Author: " + book.AuthorName.toString(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black54,
                                  size: 40,
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Delete Book',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35),
                                          ),
                                          content: const Text(
                                            'Are you sure you want to delete this book?',
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 25),
                                                )),
                                            TextButton(
                                                onPressed: () async {
                                                  if (book.id != null) {
                                                    await BookProvider.instance
                                                        .delete(book.id);
                                                  }
                                                  Navigator.of(context).pop();
                                                  setState(() {});
                                                },
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 25),
                                                )),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ),
                          ));
                    });
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          shape: CircleBorder(),
          backgroundColor: Color(0xff0977cb),
          onPressed: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              barrierColor: Colors.white70,
              backgroundColor: Colors.white,
              builder: (context) => Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                        TextFormField(
                          controller: booknameController,
                          decoration:
                          const InputDecoration(hintText: 'Book Title'),
                          autofocus: true,
                        ),
                        TextFormField(
                          controller: authorNameController,
                          decoration:
                          const InputDecoration(hintText: 'Book Author'),
                        ),
                        TextFormField(
                          controller: imageController,
                          decoration:
                          const InputDecoration(hintText: 'Book Cover URL'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 200,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () async {
                              await BookProvider.instance.insert(Book(
                                  image: imageController.text,
                                  Name: booknameController.text,
                                  AuthorName: authorNameController.text));
                              print(bookList);
                              imageController.clear();
                              booknameController.clear();
                              authorNameController.clear();
                              Navigator.pop(context);
                              // setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0977cb),
                            ),
                            child: const Text(
                              'ADD',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
            setState(() {});
          }),
    );
  }
}