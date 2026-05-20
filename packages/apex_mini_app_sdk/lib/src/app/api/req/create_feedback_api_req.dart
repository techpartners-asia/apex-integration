/// Request body for creating a support feedback ticket.
class CreateFeedbackApiReq {
  /// Feedback title.
  final String title;

  /// Feedback body/description.
  final String description;

  /// Creates a feedback creation request.
  const CreateFeedbackApiReq({required this.title, required this.description});

  /// Converts this request to backend JSON after trimming text fields.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'title': title.trim(),
      'description': description.trim(),
    };
  }
}
