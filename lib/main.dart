import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/items.dart';
import 'package:todolist/sqlite/DBHelper.dart';
import 'package:todolist/widget/addItem.dart';
import 'package:todolist/widget/card_body.dart';
import 'package:todolist/widget/card_model_bottom.dart';
import 'package:todolist/widget/editItem.dart';

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController searchControler;
  late DbHelper handler;

  List<DataItems> items = [
    DataItems(id: '1', name: 'han', completed: false, dateCreated: '2021'),
    DataItems(id: '2', name: 'phuc', completed: false, dateCreated: '2022'),
    DataItems(
        id: '3', name: 'phuc nguyen', completed: true, dateCreated: '2023')
  ];

  // xu ly them cong viec
  void _handleaddTask(String name, date) {
    // id : lấy giờ hiện tại
    final newItems =
        DataItems(id: DateTime.now().toString(), name: name, dateCreated: date);
    setState(() {
      items.add(newItems);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchControler = TextEditingController();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _handleDeleteTask(String id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  List<DataItems> results = [];
  void _filltersItems(String keyWord) {
    // for (var item in items) {
    //   if (item.name!.toLowerCase().contains(keyWord.toLowerCase())) {
    //     results.add(item);
    //   }
    // }

    results = items
        .where((element) =>
            element.name!.toLowerCase().contains(keyWord.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var getCompated =
        items.where((element) => element.completed == true).toList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFEEEFF5),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'TodoList',
            style: TextStyle(fontSize: 40),
          ),
          bottom: TabBar(
              indicator: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(10)),
              controller: _tabController,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(Icons.check),
                  text: 'Complate',
                ),
                Tab(
                  icon: Icon(Icons.flutter_dash_rounded),
                  text: 'Sqlite',
                ),
              ]),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: searchControler,
                  onChanged: (value) {
                    setState(() {
                      _filltersItems(value);
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20,
                      ),
                      hintText: 'Search',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onLongPress: () {
                            setState(() {
                              items.removeAt(index);
                            });
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditItem(items[index]),
                                )).whenComplete(() {
                              setState(() {});
                            });
                          },
                          leading: Icon(Icons.flutter_dash),
                          title: Text(
                            items[index].name!,
                            style: TextStyle(
                                decoration: items[index].completed!
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                          subtitle: Text(
                            items[index].dateCreated!,
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              setState(() {
                                items[index].completed =
                                    !items[index].completed!;
                              });
                            },
                            child: Icon(
                              items[index].completed!
                                  ? Icons.check
                                  : Icons.check_box_outline_blank,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      );
                    },

                    // items
                    //     .map((item) => CarBody(
                    //         index: items.indexOf(item),
                    //         item: item,
                    //         handleDeleteTask: _handleDeleteTask))
                    //     .toList(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ListView.builder(
                    itemCount: getCompated.length,
                    itemBuilder: (context, index) {
                      var complated = getCompated[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            setState(() {});
                          },
                          leading: Icon(Icons.flutter_dash),
                          title: Text(
                            '${complated.name}',
                          ),
                          subtitle: Text(items[index].dateCreated!),
                          trailing: Icon(
                            complated.completed!
                                ? Icons.check
                                : Icons.check_box_outline_blank,
                            color: Colors.amber,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: Text('man hinh 3'),
                )
              ]),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, size: 40),
          onPressed: () async {
            final data = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => addItem()));
            setState(() {
              items.addAll(data);
            });

            // showModalBottomSheet(
            //     shape: const RoundedRectangleBorder(
            //         borderRadius:
            //             BorderRadius.vertical(top: Radius.circular(20))),
            //     isScrollControlled: true,
            //     context: context,
            //     builder: (BuildContext context) {
            //       return ModelBottom(addTask: _handleaddTask);
            //     });
          },
        ),
      ),
    );
  }
}
