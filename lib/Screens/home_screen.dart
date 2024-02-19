import 'package:flutter/material.dart';

import 'package:souzouseisaku/Utils/utils.dart';
import 'package:souzouseisaku/Screens/graph_screen.dart';
import 'package:souzouseisaku/Screens/button_screen.dart';
import 'package:souzouseisaku/Screens/profile_screen.dart';


class HomeScreen extends StatefulWidget {
  final String token;
  final bool isLogin = false;

  const HomeScreen({
    required this.token,
    Key? key
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {


  int currentPageIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title:const Text("home"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 50,),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text(
                "ログアウト",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              onTap: (){
                deleteStorage();
                navigateToLogin(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: "Menu",
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: "Profile",
          )
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: [
        GraphScreen(),
        ButtonScreen(),
        ProfileScreen(token: widget.token),
      ][currentPageIndex],
    );
  }
}



  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             "username: $username",
  //             style: const TextStyle(
  //               fontSize: 24
  //             ),
  //           ),
  //           Text(
  //             "email: $email",
  //             style: const TextStyle(
  //               fontSize: 24
  //             ),
  //           ),
  //           Text(
  //             "id: $id",
  //             style: const TextStyle(
  //               fontSize: 24,
  //             ),
  //           ),
  //           TextButton(
  //             child: const Text(
  //               "Get Account Info",
  //               style: TextStyle(
  //                   fontSize: 24
  //               ),
  //             ),
  //             onPressed: () async {
  //               await getInfo(context, widget.token);
  //             },
  //           ),
  //           TextButton(
  //             child: const Text(
  //               "Logout",
  //               style: TextStyle(
  //                   fontSize: 24
  //               ),
  //             ),
  //             onPressed: () async {
  //               navigateToLogin(context);
  //             },
  //           ),
  //
  //         ],
  //       ),
  //     )
  //   );
  // }

