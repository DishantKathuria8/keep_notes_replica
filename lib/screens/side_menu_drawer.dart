import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                child: Text(
                  "Google Keep",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                )),
            sectionOne(),
            SizedBox(
              height: 5,
            ),
            sectionTwo(Icons.archive_outlined,"Archive"),
            SizedBox(
              height: 5,
            ),
            sectionTwo(Icons.delete_outline_outlined,"Trash"),
            SizedBox(
              height: 5,
            ),
            sectionTwo(Icons.settings_outlined,"Settings"),
          ],
        ),
      ),
    );
  }

  Widget sectionOne() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.lightBlueAccent.withOpacity(0.2)),
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
                Icon(Icons.lightbulb_outline,
                    size: 22, color: Colors.blueAccent),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Notes",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
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
                  width: 20,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7), fontSize: 16),
                )
              ],
            ),
          )),
    );
  }
}
