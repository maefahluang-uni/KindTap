import 'package:flutter/material.dart';
import 'package:mini_project/pages/component/bottombar.dart';
import 'package:getwidget/getwidget.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key});

  @override
  State<WithdrawPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<WithdrawPage> {
  late String dropdown;
  var dropdownValue;
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                height: 65,
                width: double.infinity,
                margin: EdgeInsets.all(16),
                child: DropdownButtonHideUnderline(
                  child: GFDropdown(
                    itemHeight: 65,
                    isExpanded: true,
                    border: const BorderSide(color: Colors.black12, width: 1),
                    dropdownButtonColor: Colors.grey[300],
                    value: dropdownValue,
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: [
                      'Kbank',
                      'Bangkok',
                      'Mymo',
                      'NEXT'
                    ]
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Row(children: [Image.asset('assets/images/$value.png',height: 50,width: 50,),SizedBox(width: 5,),Text(value)],),
                            ))
                        .toList(),
                  ),
                ),
              ),
              // SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    labelText: 'Bank Account ID',
                    hintText: '0000 0000 0000 0000',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Minmium (1 USD):',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your amount of withdraw';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                            blurRadius: 5,
                            offset: Offset(3, 3),
                            spreadRadius: 3)
                      ]),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.transparent,
                      disabledForegroundColor:
                          Colors.transparent.withOpacity(0.38),
                      disabledBackgroundColor:
                          Colors.transparent.withOpacity(0.12),
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.comment, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Confirm',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CusBottomBar(currentIndex: 3),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onNameFocusChange);
  }

  void _onNameFocusChange() {
    if (!_nameFocusNode.hasFocus) {
      // Save to database here
      String name = _nameController.text;
      // Call a function to save the name to the database
      _saveNameToDatabase(name);
    }
  }

  void _saveNameToDatabase(String name) {
    // You can implement your database saving logic here
    print('Saving name to database: $name');
    // For demonstration purposes, just printing the name
  }
}
