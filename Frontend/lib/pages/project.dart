import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project/pages/Project_detail.dart';
import 'package:mini_project/pages/component/bottombar.dart';
import 'dart:convert';
import 'package:mini_project/pages/model/Project.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late List<Project> projects = [];
  late List<Project> filteredProjects = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void search(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProjects = List.from(projects);
      } else {
        filteredProjects = projects
            .where((project) =>
                project.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> fetchData() async {
    final url =
        'https://us-central1-mini-project-mobile-app-12b8e.cloudfunctions.net/api/get-all-project';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic>) {
          setState(() {
            projects = responseData.entries.map((entry) {
              final projectId = entry.key;
              final projectData = entry.value;
              return Project.fromJson({
                ...projectData,
                'id': projectId,
              });
            }).toList();
            filteredProjects = List.from(projects);
            isLoading = false;
          });
        } else {
          throw Exception('Invalid response format: Expected a map.');
        }
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SearchBar(
                      controller: searchController,
                      hintText: 'Enter the project name',
                      leading: Icon(Icons.search),
                      onChanged: search,
                      onTap: () {},
                      trailing: [
                        IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            searchController.clear();
                            search('');
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filteredProjects.isEmpty
                        ? Center(
                            child: Text('No projects available.'),
                          )
                        : ListView.builder(
                            itemCount: filteredProjects.length,
                            itemBuilder: (context, index) {
                              final project = filteredProjects[index];
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to detail page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        project_uuid: project.id,
                                      ),
                                    ),
                                  );
                                },
                                child: GFCard(
                                  elevation: 8,
                                  boxFit: BoxFit.cover,
                                  image: Image.network(
                                    project.imageUrl,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                  ),
                                  showImage: true,
                                  title: GFListTile(
                                    title: Text(
                                      project.name,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    subTitleText: "Owner: "+project.project_owner_displayname+"\nEmail: "+project.project_owner_email,
                                                                          description: Text((project.description!.length > 90)
                                      ? project.description!.substring(0, 90) +
                                          '...' +
                                          (project.duration.difference(DateTime.now()).inDays <
                                                          1 &&
                                                      project.duration
                                                              .difference(
                                                                  DateTime
                                                                      .now())
                                                              .inDays >
                                                          -1
                                                  ? '\n\nEnds in (cap 60 days): ${project.duration.difference(DateTime.now()).inHours} hours'
                                                  : '\n\nEnds in (cap 60 days): ${project.duration.difference(DateTime.now()).inDays} days')
                                              .toString()
                                      : project.description! +
                                          (project.duration.difference(DateTime.now()).inDays <
                                                          1 &&
                                                      project.duration
                                                              .difference(
                                                                  DateTime.now())
                                                              .inDays >
                                                          -1
                                                  ? '\n\nEnds in (cap 60 days): ${project.duration.difference(DateTime.now()).inHours} hours'
                                                  : '\n\nEnds in (cap 60 days): ${project.duration.difference(DateTime.now()).inDays} days')
                                              .toString()),
                                  ),
                                  content: Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  buttonBar: GFButtonBar(
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Share ratio ${project.ratio.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 101, 156, 1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ((project.progressValue /
                                                                project.totalValue)
                                                            .clamp(0.0, 1.0) *
                                                        100)
                                                    .toStringAsFixed(2) +
                                                '%',
                                          ),
                                          Text(
                                            project.totalValue
                                                    .toStringAsFixed(2) +
                                                ' \$',
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      GFProgressBar(
                                        percentage: ((project.progressValue /
                                                project.totalValue)
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
                  ),
                ],
              ),
      ),
      bottomNavigationBar: CusBottomBar(currentIndex: 1),
    );
  }
}
