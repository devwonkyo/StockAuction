import 'package:auction/models/bid_model.dart';
import 'package:auction/models/comment_model.dart';
import 'package:auction/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
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
  })
      : favoriteList = favoriteList ?? [],
        commentList = commentList ?? [],
        bidList = bidList ?? [],
        isDone = isDone ?? false;

  // Convert PostModel to Map
  Map<String, dynamic> toMap() {
    return {
      'postUid': postUid,
      'writeUser': writeUser.toMap(), // Assuming UserModel has a toMap() method
      'postTitle': postTitle,
      'postContent': postContent,
      'createTime': Timestamp.fromDate(createTime),
      'endTime': Timestamp.fromDate(endTime),
      'postImageList': postImageList,
      'priceList': priceList,
      'favoriteList': favoriteList.map((user) => user.toMap()).toList(),
      'commentList': commentList.map((comment) => comment.toMap()).toList(),
      'bidList': bidList.map((bid) => bid.toMap()).toList(),
      'isDone': isDone,
    };
  }

  // Create a PostModel from Map
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postUid: map['postUid'] ?? '',
      writeUser: UserModel.fromMap(map['writeUser']),
      // Assuming UserModel has a fromMap() method
      postTitle: map['postTitle'] ?? '',
      postContent: map['postContent'] ?? '',
      createTime: (map['createTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      postImageList: List<String>.from(map['postImageList'] ?? []),
      priceList: List<String>.from(map['priceList'] ?? []),
      favoriteList: (map['favoriteList'] as List<dynamic>?)
          ?.map((userMap) => UserModel.fromMap(userMap))
          .toList() ??
          [],
      commentList: (map['commentList'] as List<dynamic>?)
          ?.map((commentMap) => CommentModel.fromMap(commentMap))
          .toList() ??
          [],
      bidList: (map['bidList'] as List<dynamic>?)
          ?.map((bidMap) => BidModel.fromMap(bidMap))
          .toList() ??
          [],
      isDone: map['isDone'] ?? false,
    );
  }
}