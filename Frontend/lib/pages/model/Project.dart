class Project {
  final String id;
  final String name;
  final String project_owner;
  final String project_owner_displayname;
  final String project_owner_email;
  final double progressValue;
  final double totalValue;
  final String imageUrl;
  final DateTime duration;
  final double ratio;
  final String? description;
  final String? backers;
  final String? news;

  Project({
    required this.id,
    required this.name,
    required this.project_owner,
    required this.project_owner_displayname,
    required this.project_owner_email,
    required this.progressValue,
    required this.totalValue,
    required this.imageUrl,
    required this.duration,
    required this.ratio,
    this.description,
    this.backers,
    this.news,
  });

factory Project.fromJson(Map<String, dynamic> json) {
  return Project(
    id: json['id'],
    name: json['project_name'],
    project_owner: json['project_owner'],
    project_owner_displayname: json['project_owner_displayname'],
    project_owner_email: json['project_owner_email'],
    description: json['project_about'],
    ratio: json['project_share_ratio'].toDouble(),
    progressValue: json['project_balance'].toDouble(),
    totalValue: json['project_goal'].toDouble(),
    imageUrl: json['project_image'],
    backers: (json['project_share_holder'] != null && json['project_share_holder']['holder_displayname'] != null) ? (json['project_share_holder']['holder_displayname'] as Map<String, dynamic>).keys.join(', ') : null,
    news: json['project_social'],
    duration: DateTime.fromMillisecondsSinceEpoch(json['project_duration']),
  );
}

}