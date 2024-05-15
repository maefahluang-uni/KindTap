import 'package:flutter/material.dart';
import 'package:mini_project/pages/component/bottombar.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 140,
                        height: 42,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(244, 177, 179, 1),
                                Color.fromRGBO(228, 107, 248, 1)
                              ]),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                    spreadRadius: 2)
                              ]),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: Colors.transparent,
                              disabledForegroundColor:
                                  Colors.transparent.withOpacity(0.38),
                              disabledBackgroundColor:
                                  Colors.transparent.withOpacity(0.12),
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/withdraw');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Withdraw',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: 0.75,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 230,
                        height: 42,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.monetization_on,
                              size: 24,
                              color: Color.fromRGBO(255, 104, 249, 0.8),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "999,999",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(255, 104, 249, 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 5 USD
                    MaterialButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 194, 194, 194), width: 2.0),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      minWidth: 150,
                      height: 150,
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 80,
                            color: Color.fromRGBO(255, 104, 249, 0.8),
                          ),
                          Text(
                            '5',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 104, 249, 0.75),
                              fontSize: 32,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.75,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 32),
                    // 10 USD
                    MaterialButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 194, 194, 194), width: 2.0),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      minWidth: 150,
                      height: 150,
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 80,
                            color: Color.fromRGBO(255, 104, 249, 0.8),
                          ),
                          Text(
                            '10',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 104, 249, 0.75),
                              fontSize: 32,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.75,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 50 USD
                    MaterialButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 255, 130, 172), width: 2.0),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      minWidth: 150,
                      height: 150,
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 80,
                            color: Color.fromRGBO(255, 104, 249, 0.8),
                          ),
                          Text(
                            '50',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 104, 249, 0.75),
                              fontSize: 32,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.75,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 32),
                    // 100 USD
                    MaterialButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 255, 130, 172), width: 2.0),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      minWidth: 150,
                      height: 150,
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 80,
                            color: Color.fromRGBO(255, 104, 249, 0.8),
                          ),
                          Text(
                            '100',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 104, 249, 0.75),
                              fontSize: 32,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.75,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 500 USD
                    MaterialButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 204, 117, 255), width: 2.0),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      minWidth: 150,
                      height: 150,
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 80,
                            color: Color.fromRGBO(255, 104, 249, 0.8),
                          ),
                          Text(
                            '500',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 104, 249, 0.75),
                              fontSize: 32,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.75,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 32),
                    // 1000 USD
                    MaterialButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 204, 117, 255), width: 2.0),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      minWidth: 150,
                      height: 150,
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 80,
                            color: Color.fromRGBO(255, 104, 249, 0.8),
                          ),
                          Text(
                            '1000',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 104, 249, 0.75),
                              fontSize: 32,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.75,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Transform.rotate(
                angle: -0.5,
                child: Text(
                  'This function is not available in this version (Education version).',
                  style: TextStyle(
                    
                    color: Color.fromARGB(255, 255, 112, 101),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CusBottomBar(currentIndex: 3),
    );
  }
}