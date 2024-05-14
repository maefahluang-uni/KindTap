import 'package:flutter/material.dart';
import 'package:mini_project/pages/component/bottombar.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Pay for token'),
        // automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure the container takes minimum space
            children: [
              Image.asset('assets/images/qr_code_barcode.jpg'),
              Text('{UUID}'),
              Text('{USD_Amount}'),
            ],
          ),
        ),
      ),

      // GFCard(
      //   border: Border.all(color: Colors.black,width: 3.0),
      //   borderRadius: BorderRadius.circular(10),
      //   title: GFListTile(
      //     title: Column(
      //       children: [
      //         Image.asset('assets/images/qr_code_barcode.jpg'),
      //         Text('{UUID}'), Text('{USD_Amount}')],
      //     ),
      //   ),
      // ),
      bottomNavigationBar: CusBottomBar(currentIndex: 3),
    );
  }
}
