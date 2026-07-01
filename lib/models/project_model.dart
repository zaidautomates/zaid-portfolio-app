class ProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String category;
  final String imageUrl;
  final String githubUrl;
  final String liveUrl;
  final String status; // 'Completed', 'In Progress', 'Planned'

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    required this.category,
    required this.imageUrl,
    required this.githubUrl,
    required this.liveUrl,
    required this.status,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // Backend returns githubLink/githubUrl, liveLink/liveUrl.
    final gitUrl = json['githubUrl'] ?? json['githubLink'] ?? '';
    final lUrl = json['liveUrl'] ?? json['liveLink'] ?? '';
    
    return ProjectModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      technologies: List<String>.from(json['technologies'] ?? []),
      category: json['category'] ?? 'Web Development',
      imageUrl: json['imageUrl'] ?? '',
      githubUrl: gitUrl,
      liveUrl: lUrl,
      status: json['status'] ?? 'Completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'technologies': technologies,
      'category': category,
      'imageUrl': imageUrl,
      'githubUrl': githubUrl,
      'githubLink': githubUrl,
      'liveUrl': liveUrl,
      'liveLink': liveUrl,
      'status': status,
    };
  }
}
