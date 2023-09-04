import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:keep_notes_app/providers/landing_page_provider.dart';
import 'package:keep_notes_app/screens/bottom_navigation_bar.dart';
import 'package:keep_notes_app/screens/side_menu_drawer.dart';
import 'package:provider/provider.dart';
import '../models/notes.dart';
import 'create_note.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late final Box notesBox;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    var provider = Provider.of<LandingPageProvider>(context, listen: false);
    provider.checkConnectivity(context);
    //provider.getNotes();
    scrollController.addListener(() {
      if (scrollController.offset >=
              (scrollController.position.maxScrollExtent) &&
          !scrollController.position.outOfRange &&
          provider.isNetworkAvailable) {
        provider.getNotes();
      }
    });
    notesBox = Hive.box('notes');
    super.initState();
  }

  @override
  void dispose() {
    var provider = Provider.of<LandingPageProvider>(context, listen: false);
    scrollController.dispose();
    provider.streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LandingPageProvider>(
      builder: (_, provider, child) => Scaffold(
        endDrawerEnableOpenDragGesture: true,
        key: provider.drawerKey,
        drawer: SideMenu(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: scrollController,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  padding: EdgeInsets.only(left: 8, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28)),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                provider.drawerKey.currentState!.openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.black,
                              )),
                          SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 55,
                                width: 170,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Search Your Notes",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontSize: 17),
                                      )
                                    ])),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.grid_view,
                            color: Colors.black,
                            size: 28,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CircleAvatar(
                              //backgroundColor: Colors.black,
                              radius: 16,
                              backgroundImage:
                                  AssetImage("assets/images/profile.png")),
                        ],
                      ),
                    ],
                  ),
                ),
                provider.isNetworkAvailable
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        child: StreamBuilder<List<DocumentSnapshot>>(
                            stream: provider.streamController.stream,
                            builder: (context, projectSnap) {
                              if (projectSnap.connectionState ==
                                      ConnectionState.none &&
                                  projectSnap.hasData == null) {
                                return Container();
                              } else if (projectSnap.hasData) {
                                final documents = projectSnap.data!;
                                return Column(
                                  children: [
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: documents.length,
                                        itemBuilder: (context, index) {
                                          Notes note =
                                              Notes.fromSnap(documents[index]);
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddNewNote(
                                                            id: note.id,
                                                            title: note.title,
                                                            content:
                                                                note.content,
                                                            time: note.time,
                                                            isUpdate: true),
                                                  ));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xffcccccc)),
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(note.title,
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  note.title.isNotEmpty
                                                      ? SizedBox(
                                                          height: 15,
                                                        )
                                                      : SizedBox(),
                                                  Text(
                                                    note.content.length > 250
                                                        ? "${note.content.substring(0, 250)}..."
                                                        : note.content,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff757575)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                    provider.isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ))
                                        : SizedBox()
                                  ],
                                );
                              } else {
                                switch (projectSnap.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ));
                                  case ConnectionState.active:
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ));
                                  default:
                                    return Container();
                                }
                              }
                            }),
                      )
                    : ValueListenableBuilder(
                        valueListenable: notesBox.listenable(),
                        builder: (context, Box box, widget) {
                          if (box.isEmpty) {
                            return Center(
                              child: Text('No Notes Available'),
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: box.length,
                                reverse: true,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var currentBox = box;
                                  var note = currentBox.getAt(index);

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddNewNote(
                                                index: index,
                                                id: note["firebaseId"],
                                                title: note["title"],
                                                content: note["content"],
                                                time: note["lastUpdated"],
                                                isUpdate: true),
                                          ));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffcccccc)),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(note["title"],
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold)),
                                          note["title"].isNotEmpty
                                              ? SizedBox(
                                                  height: 15,
                                                )
                                              : SizedBox(),
                                          Text(
                                            note["content"].length > 250
                                                ? "${note["content"].substring(0, 250)}..."
                                                : note["content"],
                                            style: TextStyle(
                                                color: Color(0xff757575)),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0), // Adjust the radius as needed
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewNote(isUpdate: false),
                ));
          },
          backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                stops: [0.3,0.5,0.6,0.3],
                colors: [Colors.red,Colors.orangeAccent,Colors.blue, Colors.green], // Gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Icon(
              Icons.add,
              size: 36.0,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
