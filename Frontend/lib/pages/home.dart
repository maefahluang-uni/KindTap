import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:mini_project/pages/Project_detail.dart';
import 'package:mini_project/pages/component/bottombar.dart';
import 'package:mini_project/pages/model/Project.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late Future<List<Project>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = fetchProjectOnwer(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<List<Project>> fetchProjectOnwer(String userId) async {
    final response = await http.get(Uri.parse(
        'https://us-central1-mini-project-mobile-app-12b8e.cloudfunctions.net/api/get-all-project'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<Project> userProjects = [];

      responseData.forEach((projectId, projectData) {
        final projectOwner = projectData['project_owner'];
        if (projectOwner == userId) {
          final backersMap =
              projectData['project_share_holder'] as Map<String, dynamic>;
          final backers = backersMap.keys.join(', ');

          final project = Project(
            id: projectId,
            name: projectData['project_name'],
            project_owner: projectOwner,
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

          userProjects.add(project);
        }
      });

      if (userProjects.isEmpty) {
        throw ('User has no projects');
      }

      return userProjects;
    } else {
      throw Exception('Failed to load project details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: GFSize.LARGE,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Home',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GFAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
                backgroundColor: Colors.grey[200],
                size: GFSize.SMALL,
              )
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Project>>(
        future: _projects,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Project> projects = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    'My projects',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: projects.isEmpty
                      ? Center(
                          child: Text(
                            'No projects found',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final item = projects[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(project_uuid: item.id),
                                  ),
                                );
                              },
                              child: GFCard(
                                elevation: 8,
                                boxFit: BoxFit.cover,
                                image: Image.network(
                                  item.imageUrl,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                                showImage: true,
                                title: GFListTile(
                                  title: Text(
                                    item.name,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  subTitleText: "Owner: "+item.project_owner_displayname+"\nEmail: "+item.project_owner_email,
                                  description: Text((item.description!.length > 90)
                                      ? item.description!.substring(0, 90) +
                                          '...' +
                                          (item.duration.difference(DateTime.now()).inDays <
                                                          1 &&
                                                      item.duration
                                                              .difference(
                                                                  DateTime
                                                                      .now())
                                                              .inDays >
                                                          -1
                                                  ? '\n\nEnds in (cap 60 days): ${item.duration.difference(DateTime.now()).inHours} hours'
                                                  : '\n\nEnds in (cap 60 days): ${item.duration.difference(DateTime.now()).inDays} days')
                                              .toString()
                                      : item.description! +
                                          (item.duration.difference(DateTime.now()).inDays <
                                                          1 &&
                                                      item.duration
                                                              .difference(
                                                                  DateTime.now())
                                                              .inDays >
                                                          -1
                                                  ? '\n\nEnds in (cap 60 days): ${item.duration.difference(DateTime.now()).inHours} hours'
                                                  : '\n\nEnds (cap 60 days): in ${item.duration.difference(DateTime.now()).inDays} days')
                                              .toString()),
                                ),
                                content: Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                buttonBar: GFButtonBar(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Share ratio ' +
                                          item.ratio.toString() +
                                          '%',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 101, 156, 1),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(((item.progressValue /
                                                            item.totalValue)
                                                        .clamp(0.0, 1.0) *
                                                    100)
                                                .toStringAsFixed(2) +
                                            '%'),
                                        Text(
                                            item.totalValue.toStringAsFixed(2) +
                                                ' \$'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    GFProgressBar(
                                      percentage: ((item.progressValue /
                                              item.totalValue)
                                          .clamp(0.0, 1.0)),
                                      backgroundColor: Colors.black26,
                                      progressBarColor: GFColors.DANGER,
                                      lineHeight: 10.0,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createProject');
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CusBottomBar(
        currentIndex: 0,
      ),
    );
  }
}
