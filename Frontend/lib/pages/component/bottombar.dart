import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/pages/component/globals.dart';
import 'package:mini_project/pages/contact.dart';
import 'package:mini_project/pages/home.dart';
import 'package:mini_project/pages/profile.dart';
import 'package:mini_project/pages/project.dart';
import 'package:mini_project/pages/wallet.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class CusBottomBar extends StatefulWidget {
  final int currentIndex;

  const CusBottomBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<CusBottomBar> createState() => _CusBottomBarState();
}

class _CusBottomBarState extends State<CusBottomBar> {
  String _balance = "Loading...";

  @override
  void initState() {
    _fetchBalance();
    super.initState();
  }

  Future<void> _fetchBalance() async {
    var url = 'https://us-central1-mini-project-mobile-app-12b8e.cloudfunctions.net/api/profile';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'email': globalEmail,
      'password': globalPassword,
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _balance = NumberFormat('#,##0').format(double.parse(data['data']['balance'].toString())); // assuming the balance is returned as 'balance' in the API response
        });
      } else {
        setState(() {
          _balance = "Error"; // Handle error state if needed
        });
      }
    } catch (error) {
      setState(() {
        _balance = "Error"; // Handle error state if needed
      });
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        // Home
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: HomePage(), // Replace with your actual Home screen widget
          ),
        );
        break;
      case 1:
        // Project
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: ProjectPage(), // Replace with your actual Project screen widget
          ),
        );
        break;
      case 2:
        // Profile
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: ProfilePage(), // Replace with your actual Profile screen widget
          ),
        );
        break;
      case 3:
        // Wallet
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: WalletPage(), // Replace with your actual Wallet screen widget
          ),
        );
        break;
      case 4:
        // Wallet
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: ContactPage(), // Replace with your actual Wallet screen widget
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on, size: 24, color: Color.fromRGBO(255, 104, 249, 0.8)),
            SizedBox(width: 4),
            Text(
              _balance,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 104, 249, 0.8),
              ),
            ),
          ],
        ),
        SalomonBottomBar(
          currentIndex: widget.currentIndex,
          onTap: _onItemTapped,
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.favorite),
              title: Text("Project"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.account_circle),
              title: Text("Profile"),
              selectedColor: Colors.orange,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.wallet),
              title: Text("Wallet"),
              selectedColor: Colors.teal,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.contact_support),
              title: Text("contact"),
              selectedColor: Colors.lightBlue,
            ),
          ],
        ),
      ],
    );
  }
}
