import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/pages/component/globals.dart';
import 'package:mini_project/pages/component/toast.dart';
import 'dart:io';


class CreateFundRaisePage extends StatefulWidget {
  const CreateFundRaisePage({Key? key}) : super(key: key);
  @override
  State<CreateFundRaisePage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<CreateFundRaisePage>
    with SingleTickerProviderStateMixin {
  double _currentSliderValue = 0;
  String _selectedDuration = '1 Day';
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectRegionController = TextEditingController();
  TextEditingController projectAboutController = TextEditingController();
  TextEditingController projectSocialController = TextEditingController();
  TextEditingController projectGoalController = TextEditingController();
  TextEditingController projectDurationController = TextEditingController();

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

  int parseDuration(String selectedDuration) {
    // Extract numeric part from the selected duration string
    final numericPart = selectedDuration.split(' ').first;
    // Parse the numeric part to an integer
    return int.parse(numericPart);
  }

  Future<bool> _authenticate() async {
    String projectName = projectNameController.text;
    String projectRegion = projectRegionController.text;
    String projectAbout = projectAboutController.text;
    String projectSocial = projectSocialController.text;
    String projectTags = "Cat,Dog";
    double projectGoal = double.parse(projectGoalController.text);
    int selectedDurationInDays = parseDuration(_selectedDuration);
    int projectDuration = selectedDurationInDays * 24 * 60 * 60;
    double projectShareRatio = _currentSliderValue;

    String apiUrl =
        'https://us-central1-mini-project-mobile-app-12b8e.cloudfunctions.net/api/create-project';
    String? email = globalEmail;
    String? password = globalPassword;

    // var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    var response = await http.post(Uri.parse(apiUrl), body: {
      'email': email,
      'password': password,
      'project_name': projectName,
      'project_region': projectRegion,
      'project_about': projectAbout,
      'project_tags': projectTags,
      'project_social': projectSocial,
      'project_goal': projectGoal.toString(),
      'project_duration': projectDuration.toString(),
      'project_share_ratio': projectShareRatio.toString(),
      'project_image': base64Encode(_imageFile!.readAsBytesSync()),
    });

    if (response.statusCode == 200) {
      // Authentication successful
      print('Project created successful: ${response.body}');
      showToast(message: 'Project created successfully!');
      Navigator.pushNamed(context, '/home');
      return true;
    } else {
      // Authentication failed
      print('Project created failed: ${response.body}');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    projectNameController.dispose();
    projectRegionController.dispose();
    projectAboutController.dispose();
    projectSocialController.dispose();
    projectGoalController.dispose();
    projectDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fundraise'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 380,
              child: Column(
                children: [
                  TextFormField(
                    controller: projectRegionController,
                    decoration: InputDecoration(
                      labelText: 'Region project',
                      hintText: 'USA, Thailand, ...',
                    ),
                  ),
                  SizedBox(height: 12),
                  Divider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    ],
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: projectNameController,
                    decoration: InputDecoration(
                      labelText: 'Project name',
                      hintText: '...',
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: projectAboutController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      labelText: 'About',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: projectSocialController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'News & social',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: projectGoalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Fundraise goal',
                      hintText: 'Minimum (10 USD):',
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fundraise duration',
                    ),
                    value: _selectedDuration,
                    items: [
                      '1 Day',
                      '7 Day',
                      '30 Day',
                      '60 Day'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      // Handle the value change
                      setState(() {
                        _selectedDuration = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Share ratio: ' +
                        _currentSliderValue.toStringAsFixed(2) +
                        '%',
                    style: TextStyle(fontSize: 16),
                  ),
                  Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: 5,
                    divisions: 100,
                    label: _currentSliderValue.toStringAsFixed(2),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: 128,
                    height: 48,
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
                            Text(
                              'Submit',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16, // Font size
                                fontFamily:
                                    'Roboto', // Font family (replace with your desired font)
                                fontWeight: FontWeight
                                    .bold, // Font weight (optional, you can remove this line if not needed)
                                fontStyle: FontStyle
                                    .normal, // Font style (optional, you can remove this line if not needed)
                                letterSpacing:
                                    0.75, // Letter spacing (optional, you can remove this line if not needed)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
