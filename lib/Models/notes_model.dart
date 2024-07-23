class Notes {
  final int? id;
  final String title;
  final String content;
  final DateTime timestamp;

  Notes({
    this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory Notes.fromMap(Map<String, dynamic> json) => Notes(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };
}
