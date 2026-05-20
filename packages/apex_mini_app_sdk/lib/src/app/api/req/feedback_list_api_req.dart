/// Pagination request for the support feedback list.
class FeedbackListApiReq {
  /// Maximum number of feedback rows to fetch.
  final int limit;

  /// Page number requested from the backend.
  final int page;

  /// Creates a feedback list request.
  const FeedbackListApiReq({
    required this.limit,
    required this.page,
  });

  /// Converts this request to backend JSON.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'limit': limit,
      'page': page,
    };
  }
}
