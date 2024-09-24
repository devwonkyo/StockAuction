class CommentModel{
  String userId;
  String? userProfileImage;
  String comment;
  String commentTime;

  CommentModel({required this.userId, required this.comment,required this.commentTime, this.userProfileImage = ""});

  // CommentModel을 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userProfileImage': userProfileImage, // Nullable 처리
      'comment': comment,
      'commentTime': commentTime,
    };
  }

  // Map을 CommentModel로 변환
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'] ?? '', // userId가 없으면 빈 문자열
      userProfileImage: map['userProfileImage'], // Nullable 처리
      comment: map['comment'] ?? '', // comment가 없으면 빈 문자열
      commentTime: map['commentTime'] ?? '', // commentTime이 없으면 빈 문자열
    );
  }
}