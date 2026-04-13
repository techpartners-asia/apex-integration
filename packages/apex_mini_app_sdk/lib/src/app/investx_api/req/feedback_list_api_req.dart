class FeedbackListApiReq {
  final int limit;
  final int page;

  const FeedbackListApiReq({
    required this.limit,
    required this.page,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'limit': limit,
      'page': page,
    };
  }
}
