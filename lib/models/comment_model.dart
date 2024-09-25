class CommentModel{
  String uId;
  String? userProfileImage;
  String comment;
  String commentTime;

  CommentModel({required this.uId, required this.comment,required this.commentTime, this.userProfileImage = ""});

  // CommentModel을 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'userProfileImage': userProfileImage, // Nullable 처리
      'comment': comment,
      'commentTime': commentTime,
    };
  }

  // Map을 CommentModel로 변환
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      uId: map['uId'] ?? '', // userId가 없으면 빈 문자열
      userProfileImage: map['userProfileImage'], // Nullable 처리
      comment: map['comment'] ?? '', // comment가 없으면 빈 문자열
      commentTime: map['commentTime'] ?? '', // commentTime이 없으면 빈 문자열
    );
  }
}