import 'package:auction/models/bid_model.dart';
import 'package:auction/models/comment_model.dart';
import 'package:auction/models/user_model.dart';

class PostModel{
  String postUid;
  UserModel writeUser;
  String postTitle;
  String postContent;
  DateTime createTime;
  DateTime endTime;
  List<String> postImageList;
  List<String> priceList;
  List<UserModel> favoriteList;
  List<CommentModel> commentList;
  List<BidModel> bidList;
  bool isDone;

  PostModel({
    required this.postUid,
    required this.writeUser,
    required this.postTitle,
    required this.postContent,
    required this.createTime,
    required this.endTime,
    required this.postImageList,
    required this.priceList,
    List<UserModel>? favoriteList,
    List<CommentModel>? commentList,
    List<BidModel>? bidList,
    bool? isDone,
  }) : favoriteList = favoriteList ?? [],
        commentList = commentList ?? [],
        bidList = bidList ?? [],
        isDone = isDone ?? false;

  // PostModel을 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'postUid': postUid, // UserModel 변환
      'writeUser': writeUser.toMap(),
      'postTitle': postTitle,
      'postContent': postContent,
      'createTime': createTime,
      'endTime': endTime,
      'postImageList': postImageList, // List<String> 그대로 변환
      'priceList': priceList,         // List<String> 그대로 변환
      'favoriteList': favoriteList.map((user) => user.toMap()).toList(), // List<CommentModel> 변환
      'commentList': commentList.map((comment) => comment.toMap()).toList(), // List<CommentModel> 변환
      'bidList': bidList.map((bid) => bid.toMap()).toList(),                 // List<BidModel> 변환
      'isDone': isDone,
    };
  }

  // Map을 PostModel로 변환
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postUid: map['postUid'] ?? '',
      writeUser: UserModel.fromMap(map['writeUser']), // UserModel 변환
      postTitle: map['postTitle'] ?? '',
      postContent: map['postContent'] ?? '',
      createTime: map['createTime'] ?? '',
      endTime: map['endTime'] ?? '',
      postImageList: List<String>.from(map['postImageList'] ?? []), // List<String> 변환
      priceList: List<String>.from(map['priceList'] ?? []), // List<String> 변환
      favoriteList: List<UserModel>.from(map['favoriteList']?.map((user) => UserModel.fromMap(user)) ?? []),
      commentList: List<CommentModel>.from(map['commentList']?.map((comment) => CommentModel.fromMap(comment)) ?? []),
      bidList: List<BidModel>.from(map['bidList']?.map((bid) => BidModel.fromMap(bid)) ?? []),
      isDone: map['isDone'] ?? 'false',
    );
  }
}