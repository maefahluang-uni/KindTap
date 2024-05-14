import 'package:flutter/material.dart';
import 'package:mini_project/pages/component/ContactCard.dart';
import 'package:mini_project/pages/component/bottombar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Contact Information:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            ContactCard(
              icon: Icons.email,
              text: '6531503074@lamduan.mfu.ac.th',
            ),
            ContactCard(
              icon: Icons.phone,
              text: '+66994793969',
            ),
            // Add more contact cards as needed
          ],
        ),
      ),
      bottomNavigationBar: CusBottomBar(currentIndex: 4,),
    );
  }
}