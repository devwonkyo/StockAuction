class CommentModel{
  String userId;
  String? userProfileImage;
  String comment;
  String time;

  CommentModel({required this.userId, required this.comment,required this.time, this.userProfileImage});
}