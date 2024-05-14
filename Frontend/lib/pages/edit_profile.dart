import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/pages/component/bottombar.dart';
import 'package:mini_project/pages/component/globals.dart';
import 'package:mini_project/pages/component/toast.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<bool> _authenticate() async {
    String apiUrl =
        'https://us-central1-mini-project-mobile-app-12b8e.cloudfunctions.net/api/edit-profile-image';
    String? email = globalEmail;
    String? password = globalPassword;

    // var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    var response = await http.post(Uri.parse(apiUrl), body: {
      'email': email,
      'password': password,
      'image': base64Encode(_imageFile!.readAsBytesSync()),
    });

    if (response.statusCode == 200) {
      // Authentication successful
      print('Profile updated successful: ${response.body}');
      showToast(message: 'Profile updated');
      Navigator.pushNamed(context, '/profile');
      return true;
    } else {
      // Authentication failed
      print('Profile updated failed: ${response.body}');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: ListView(children: [
        SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        )
                      : Placeholder(
                          fallbackHeight: 200,
                          fallbackWidth: 200,
                        ),
                ),
                SizedBox(height: 4),
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.pink),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Pick Image from Gallery',
                    style: TextStyle(color: Colors.white),
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
                      onPressed: _authenticate,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Confirm',
                              style: TextStyle(
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
      bottomNavigationBar: CusBottomBar(currentIndex: 2),
    );
  }
}
