class CreateFeedbackApiReq {
  final String title;
  final String description;

  const CreateFeedbackApiReq({required this.title, required this.description});

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'title': title.trim(),
      'description': description.trim(),
    };
  }
}
