import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/color.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String buttonName = 'Click';
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 25.0,
          color: Color.fromARGB(255, 251, 246, 246),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 251, 249, 249),
      body: Center(
        child: getCurrentPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
              color: icons,
            ),
          ),
          
          BottomNavigationBarItem(
            label: 'Read List',
            icon: Icon(
              Icons.list,
              color:icons,
            ),
          ),

          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
              Icons.settings,
              color: icons,
            ),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget getCurrentPage() {
    switch (currentIndex) {
      case 0:
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    buttonName = 'Clicked';
                  });
                },
                child: Text(buttonName),
              ),
            ],
          ),
        );
      case 1:
        return ListView(
          children: [
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Item 1'),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Item 2'),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Item 3'),
            ),
          ],
        );

      case 2:
      return Center(
          child: Text('Settings Page'),
        );
        
      default:
        return Container();
    }
  }
}
