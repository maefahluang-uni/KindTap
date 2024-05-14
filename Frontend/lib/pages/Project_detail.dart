import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mini_project/pages/component/bottombar.dart';
import 'package:mini_project/pages/component/globals.dart';
import 'package:mini_project/pages/component/toast.dart';
import 'package:mini_project/pages/model/Project.dart';

class DetailPage extends StatefulWidget {
  final String project_uuid;

  const DetailPage({Key? key, required this.project_uuid}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _balance = "Loading...";
  TextEditingController _donatecontroller = TextEditingController();
  late Future<Project?> _project;
  int _selectedButtonIndex = 0;
  String HolderDescription = "";

  // List of button features
  List<String> ListOfButtonFeature = ["About", "Backers", "News"];

  @override
  void initState() {
    _fetchBalance();
    super.initState();
    _project = fetchProjectDetails(widget.project_uuid);
  }

  Future<Project?> fetchProjectDetails(String projectId) async {
    final response = await http.get(Uri.parse(
        'https://us-central1-mini-project-mobile-app-12b8e.cloudfunctions.net/api/get-all-project'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey(projectId)) {
        final projectData = responseData[projectId];
        final backersMap =
            (projectData['project_share_holder'] as Map<String, dynamic>);
        final backers = backersMap.entries.map((entry) => '- ' + entry.value['holder_displayname']).join('\n');

        _handleButtonClick(
            0,
            Project(
              id: projectId,
              name: projectData['project_name'],
              project_owner: projectData['project_owner'],
              project_owner_displayname: projectData['project_owner_displayname'],
              project_owner_email: projectData['project_owner_email'],
              description: projectData['project_about'],
              ratio: projectData['project_share_ratio'].toDouble(),
              progressValue: projectData['project_balance'].toDouble(),
              totalValue: projectData['project_goal'].toDouble(),
              imageUrl: projectData['project_image'],
              backers: backers,
              news: projectData['project_social'],
              duration: DateTime.fromMillisecondsSinceEpoch(
                  projectData['project_duration']),
            ));

        return Project(
          id: projectId,
          name: projectData['project_name'],
          project_owner: projectData['project_owner'],
          project_owner_displayname: projectData['project_owner_displayname'],
          project_owner_email: projectData['project_owner_email'],
          description: projectData['project_about'],
          ratio: projectData['project_share_ratio'].toDouble(),
          progressValue: projectData['project_balance'].toDouble(),
          totalValue: projectData['project_goal'].toDouble(),
          imageUrl: projectData['project_image'],
          backers: backers,
          news: projectData['project_social'],
          duration: DateTime.fromMillisecondsSinceEpoch(
              projectData['project_duration']),
        );
      } else {
        throw Exception('Project not found');
      }
    } else {
      throw Exception('Failed to load project details');
    }
  }

  // Function to handle button clicks and update description
  void _handleButtonClick(int index, Project project) {
    setState(() {
      switch (index) {
        case 0:
          if (project.description != null) {
            _selectedButtonIndex = index;
            HolderDescription = project.description!;
          }
          break;
        case 1:
          if (project.backers != null) {
            _selectedButtonIndex = index;
            HolderDescription = project.backers!;
          }
          break;
        case 2:
          if (project.news != null) {
            _selectedButtonIndex = index;
            HolderDescription = project.news!;
          }
          break;
      }
    });
  }

  // Function to build GFProgressBar widget
  Widget buildProgressBar(Project project) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GFProgressBar(
        percentage:
            (project.progressValue / project.totalValue).clamp(0.0, 1.0),
        backgroundColor: Colors.black26,
        progressBarColor: GFColors.DANGER,
        lineHeight: 10.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/project');
          },
        ),
        automaticallyImplyLeading: false,
        title: const Text('Detail'),
        centerTitle: true,
      ),
      body: FutureBuilder<Project?>(
        future: _project,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Project project = snapshot.data!;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Image.network(
                      project.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.fitHeight,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 24),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${project.progressValue.toStringAsFixed(2)} \$ from ${project.totalValue.toStringAsFixed(0)} \$',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Collected ${((project.progressValue / project.totalValue) * 100).toStringAsFixed(2)}%',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Call buildProgressBar function
                          buildProgressBar(project),
                          SizedBox(height: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.rocket_launch),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(DateFormat('d MMMM')
                                          .format(project.duration)),
                                      Text('Started'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.timer_outlined),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(project.duration
                                                      .difference(
                                                          DateTime.now())
                                                      .inDays <
                                                  1 &&
                                              project.duration
                                                      .difference(
                                                          DateTime.now())
                                                      .inDays >
                                                  -1
                                          ? 'Ends in ${project.duration.difference(DateTime.now()).inHours} hours'
                                          : 'Ends in ${project.duration.difference(DateTime.now()).inDays} days'),
                                      Text('Left'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.favorite),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(project.project_owner_displayname),
                                      Text('Owner'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                ListOfButtonFeature.length,
                                (index) => Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          _handleButtonClick(index, project),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          _selectedButtonIndex == index
                                              ? Color.fromRGBO(248, 107, 175, 1)
                                              : Color.fromRGBO(
                                                  255, 222, 222, 1),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        ListOfButtonFeature[index],
                                        style: TextStyle(
                                          color: _selectedButtonIndex == index
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : Color.fromRGBO(
                                                  254, 114, 119, 1),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: 8), // Add SizedBox for spacing
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 16),
                          // Container(
                          //   width: double.infinity,
                          //   constraints: BoxConstraints(
                          //     minHeight:
                          //         100, // Set a minimum height for the container
                          //     maxHeight: MediaQuery.of(context).size.height *
                          //         0.6, // Set a maximum height based on screen height
                          //   ),
                          //   color: Color.fromRGBO(0, 0, 0, 0.045),
                          //   padding: EdgeInsets.symmetric(horizontal: 24),
                          //   child: SingleChildScrollView(
                          //     // Wrap the TextField with a SingleChildScrollView
                          //     child: Column(
                          //       children: [
                          //         TextField(
                          //           decoration: InputDecoration(
                          //             hintStyle: TextStyle(
                          //                 color:
                          //                     Color.fromRGBO(132, 132, 132, 1)),
                          //             hintText: HolderDescription,
                          //             border: InputBorder.none,
                          //           ),
                          //           readOnly: true,
                          //           enabled: false,
                          //           maxLines:
                          //               null, // Set maxLines to null to allow unlimited lines
                          //           textAlignVertical: TextAlignVertical.top,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight:
                                  100, // Set a minimum height for the container
                              maxHeight: MediaQuery.of(context).size.height *
                                  0.6, // Set a maximum height based on screen height
                            ),
                            color: Color.fromRGBO(0, 0, 0, 0.045),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: SingleChildScrollView(
                              // Wrap the Text with a SingleChildScrollView
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          HolderDescription,
                                          style: TextStyle(
                                            color: Color.fromRGBO(132, 132, 132, 1),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                onPressed: (project.duration
                                            .difference(DateTime.now())
                                            .inDays >=
                                        0)
                                    ? () {
                                        // Navigator to donate page
                                        DonatePopup(context);
                                      }
                                    : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.monetization_on_sharp,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Donate',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: CusBottomBar(currentIndex: 1),
    );
  }

  Future<void> _fetchBalance() async {
    var url =
        'https://us-central1-mini-project-mobile-app-12b8e.cloudfunctions.net/api/profile';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'email': globalEmail,
      'password': globalPassword,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          //chack _donatecontroller value if _donatecontroller have value then remove this value to balance and show how much balance left
          _balance = NumberFormat('#,##0').format(double.parse(data['data']
                  ['balance']
              .toString())); // assuming the balance is returned as 'balance' in the API response
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

  void DonatePopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
              title: Text('Donate',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              content: Column(
                children: [
                  SizedBox(height: 20),
                  Text('Enter the donation amount'),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _donatecontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // labelText: 'Donate Amount',
                      hintText: 'Minimum (1 USD):',
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Image.asset('assets/images/heart.png',
                        width: 24, height: 24),
                    SizedBox(width: 5),
                    Text(
                      'Thank you for your donation!',
                      textAlign: TextAlign.start,
                    )
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.monetization_on,
                          size: 24, color: Color.fromRGBO(255, 104, 249, 0.8)),
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
                  SizedBox(height: 10),
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
                        onPressed: () {
                          _donation();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.monetization_on_sharp,
                                color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Donate',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  Future<bool> _donation() async {
    String _projectId = widget.project_uuid;
    double _donateAmount = double.parse(_donatecontroller.text);

    String apiUrl =
        'https://us-central1-mini-project-mobile-app-12b8e.cloudfunctions.net/api/donate';
    String? email = globalEmail;
    String? password = globalPassword;
    print(_donateAmount);
    print(_projectId);
    // var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    var response = await http.put(Uri.parse(apiUrl), body: {
      'email': email,
      'password': password,
      'project_id': _projectId,
      'price': _donateAmount.toString(),
    });

    if (response.statusCode == 200) {
      // Authentication successful
      print('Donation successful: ${response.body}');
      showToast(message: 'Donation successfully!');
      //reload dateill page for update variable
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DetailPage(project_uuid: _projectId)));
      return true;
    } else {
      // Authentication failed
      print('Donation failed: ${response.body}');
      print('Donation failed: ${response.statusCode}');
      showToast(message: 'Donation failed!');
      return false;
    }
  }
}
