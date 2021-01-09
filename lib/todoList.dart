import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: Colors.blue,
//         accentColor: Colors.orange),
//     home: MyApp(),
//   ));
// }

class MyTodoList extends StatefulWidget {
  @override
  _MyTodoListState createState() => _MyTodoListState();
}

class _MyTodoListState extends State<MyTodoList> {
  // List todos = [];
  String input = "";

  createTodo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Todo").doc(input);

    Map<String, String> todos = {"todoTitle": input};
    documentReference.set(todos).whenComplete(() => print("$input created"));
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Todo").doc("$item");

    documentReference.delete().whenComplete(() => print("$item deleted"));
  }

  updateTodo(item, input) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Todo").doc("$item");

    documentReference.update(input).whenComplete(() => print("$input updated"));
  }

  Future<bool> updateDialog(BuildContext context, item) async {
    //selected document=item
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text("Update To-Do"),
            content: TextField(
              onChanged: (String value) {
                this.input = value;
              },
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    updateTodo(item, {'todoTitle': this.input}); //createTodo();
                    Navigator.of(context).pop();
                    // setState(() {
                    //   createTodo();
                    // });
                    // Navigator.of(context).pop();
                  },
                  child: Text("Update"))
            ],
          );
        });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   todo.add("hello");
  //   todo.add("hello2");
  //   todo.add("hello3  ");
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add To-Do "),
                  content: TextField(
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          createTodo(); //createTodo();
                          Navigator.of(context).pop();
                          // setState(() {
                          //   createTodo();
                          // });
                          // Navigator.of(context).pop();
                        },
                        child: Text("Add"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.red,
        ),
      ),
      body: Container(
        color: Colors.grey[850],
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Todo").snapshots(),
              builder: (context, snapshots) {
                // if (!snapshots.hasData) return LinearProgressIndicator();
                if (snapshots.data == null) return CircularProgressIndicator();

                return Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshots.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshots.data.documents[index];
                          return Dismissible(
                              key: UniqueKey(),
                              child: Card(
                                elevation: 4,
                                margin: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: ListTile(
                                    title: Text(documentSnapshot["todoTitle"]),
                                    trailing: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        deleteTodo(
                                            documentSnapshot["todoTitle"]);
                                      },
                                    ),
                                    onTap: () {
                                      //  print(documentSnapshot["todoTitle"]);
                                      updateDialog(context,
                                          documentSnapshot["todoTitle"]);
                                    }
                                    // updateTodo(documentSnapshot["todoTitle"]),
                                    ),
                              ));
                        }),
                    // FlatButton(
                    //   child: Text('Pop!'),
                    //   onPressed: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) => SecondScreen()));
                    //   },
                    // )
                  ],
                );
              },
            ),
            // Container(
            //   alignment: Alignment(-0.9, 0.9),
            //   child: FlatButton(
            //     child: Text('Ana Sayfaya Geri Dön'),
            //     onPressed: () {
            //       Navigator.pop(context,
            //           MaterialPageRoute(builder: (context) => SecondScreen()));
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
