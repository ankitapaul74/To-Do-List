class Note {
  final String id;
  final String? title;
  final String? content;
  final String contentJson;
  final int dateCreated;
  final int dateModified;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.contentJson,
    required this.dateCreated,
    required this.dateModified,
  });

  // Convert Note object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'contentJson': contentJson,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      contentJson: map['contentJson'] ?? '',
      dateCreated: map['dateCreated'] ?? 0,
      dateModified: map['dateModified'] ?? 0,
    );
  }
}
