import 'package:auction/models/user_model.dart';

class BidModel{
  UserModel bidUser;
  String bidTime;
  String bidPrice;

  BidModel({
    required this.bidUser,
    required this.bidTime,
    required this.bidPrice});


  Map<String, dynamic> toMap() {
    return {
      'bidUser': bidUser.toMap(),
      'bidTime': bidTime,
      'bidPrice': bidPrice,
    };
  }


  // Map을 BidModel로 변환
  factory BidModel.fromMap(Map<String, dynamic> map) {
    return BidModel(
      bidUser: UserModel.fromMap(map['bidUser']),
      bidTime: map['bidTime'] ?? '',
      bidPrice: map['bidPrice'] ?? '',
    );
  }
}