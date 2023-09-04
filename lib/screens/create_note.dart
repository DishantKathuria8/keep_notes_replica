import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_notes_app/providers/landing_page_provider.dart';
import 'package:keep_notes_app/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../providers/create_note_provider.dart';

import '../utils/network_connectivity_service.dart';

class AddNewNote extends StatefulWidget {
  final int? index;
  final String? id;
  final String? title;
  final String? content;
  final DateTime? time;
  final bool isUpdate;

  const AddNewNote(
      {this.index,
      this.id,
      this.title,
      this.content,
      this.time,
      required this.isUpdate,
      super.key});

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  String? formattedTime;

  @override
  void initState() {
    var addNoteProvider = Provider.of<AddNoteProvider>(context, listen: false);
    DateTime now = DateTime.now();
    print(widget.id);
    if (widget.isUpdate) {
      addNoteProvider.titleController.text = widget.title!;
      addNoteProvider.noteController.text = widget.content!;
      if (widget.time?.day == now.day) {
        formattedTime = DateFormat.Hm().format(widget.time ?? DateTime.now());
      } else {
        formattedTime = DateFormat.MMMd().format(widget.time ?? DateTime.now());
      }
    } else {
      addNoteProvider.titleController.clear();
      addNoteProvider.noteController.clear();
      formattedTime = DateFormat.Hm().format(now);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var addNoteProvider = Provider.of<AddNoteProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (widget.isUpdate &&
            ((widget.title != addNoteProvider.titleController.text) ||
                (widget.content != addNoteProvider.noteController.text))) {
          addNoteProvider.updateNotes(widget.id, widget.index, context);
        } else if ((widget.id == null) &&
            (addNoteProvider.titleController.text.isNotEmpty ||
                addNoteProvider.noteController.text.isNotEmpty)) {
          addNoteProvider.createNotes(context);
        }
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              if (widget.isUpdate &&
                  ((widget.title != addNoteProvider.titleController.text) ||
                      (widget.content !=
                          addNoteProvider.noteController.text))) {
                addNoteProvider.updateNotes(widget.id, widget.index, context);
              } else if ((widget.id == null) &&
                  (addNoteProvider.titleController.text.isNotEmpty ||
                      addNoteProvider.noteController.text.isNotEmpty)) {
                addNoteProvider.createNotes(context);
              }
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          actions: [
            Icon(
              Icons.push_pin_outlined,
              color: Color(0xff757575),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.add_alert_outlined,
              color: Color(0xff757575),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.archive_outlined,
              color: Color(0xff757575),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                TextField(
                  controller: addNoteProvider.titleController,
                  cursorColor: Colors.black,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Title",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(0.8))),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: TextField(
                    autofocus: widget.isUpdate ? false : true,
                    controller: addNoteProvider.noteController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    minLines: 50,
                    maxLines: null,
                    style: TextStyle(fontSize: 17, color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Note",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.withOpacity(0.8))),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.add_box_outlined,
                    color: Color(0xff757575),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.color_lens_outlined,
                    color: Color(0xff757575),
                  ),
                ],
              ),

              Text("Edited ${formattedTime}"),
              GestureDetector(
                onTap: (){
                  modalSheetForDelete(context);
                },
                  child: Icon(Icons.more_vert_outlined,color: Color(0xff757575),)),
              // GestureDetector(
              //     onTap: () {
              //       addNoteProvider.deleteNote(
              //           widget.id, widget.index, context);
              //       Navigator.pop(context);
              //     },
              //     child: Icon(
              //       Icons.delete_outline_outlined,
              //       color: Color(0xff757575),
              //     )),
            ],
          ),
        ),
      ),
    );
  }

  void modalSheetForDelete(BuildContext context){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              height: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionOne(),
                  SizedBox(
                    height: 5,
                  ),
                  sectionTwo(Icons.copy_rounded,"Make a copy"),
                  SizedBox(
                    height: 5,
                  ),
                  sectionTwo(Icons.share_outlined,"Send"),
                  SizedBox(
                    height: 5,
                  ),
                  sectionTwo(Icons.label_important_outline_rounded,"Labels"),
                ],
              ));
        });
  }


  Widget sectionOne() {
    var addNoteProvider = Provider.of<AddNoteProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 10,right: 10),
      child: TextButton(
          onPressed: () {
            addNoteProvider.deleteNote(
                widget.id, widget.index, context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(Icons.delete_outline_outlined,
                    size: 22, color: Colors.black.withOpacity(0.7)),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Delete",
                  style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 17),
                )
              ],
            ),
          )),
    );
  }

  Widget sectionTwo(icon,text) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                  ))),
          onPressed: () {},
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: Colors.black.withOpacity(0.7),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7), fontSize: 17),
                )
              ],
            ),
          )),
    );
  }

}
