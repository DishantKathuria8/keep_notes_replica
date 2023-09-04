import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xffe2f0f8),
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.check_box_outlined),
            color: Colors.black.withOpacity(0.7),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(Icons.brush),
            color: Colors.black.withOpacity(0.7),
            onPressed: () {

            },
          ),

          IconButton(
            icon: Icon(Icons.mic_none_outlined),
            color: Colors.black.withOpacity(0.7),
            onPressed: () {

            },
          ),
          IconButton(
            icon: Icon(Icons.image),
            color: Colors.black.withOpacity(0.7),
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }
}
    //   BottomNavigationBar(
    //   type: BottomNavigationBarType.fixed,
    //   backgroundColor: Color(0xffe2f0f8),
    //   unselectedItemColor: Colors.black.withOpacity(0.7),
    //   selectedItemColor: Colors.black.withOpacity(0.7),
    //   items: <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(
    //         icon: Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: Icon(Icons.check_box_outlined),
    //         ),
    //         label: ''),
    //     BottomNavigationBarItem(
    //         icon: Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: Icon(Icons.brush),
    //         ),
    //         label: ''),
    //     BottomNavigationBarItem(
    //         icon: Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: Icon(Icons.mic_none_outlined),
    //         ),
    //         label: ''),
    //     BottomNavigationBarItem(
    //         icon: Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: Icon(Icons.image),
    //         ),
    //         label: ''),
    //   ],
    // );


