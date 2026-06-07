import 'package:flutter_grocery/features/order/domain/models/order_model.dart';

class UserInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  int? isPhoneVerified;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? emailVerificationToken;
  String? phone;
  String? cmFirebaseToken;
  String? loginMedium;
  String? referCode;
  double? walletBalance;
  double? point;
  int totalPointValue = 0;
  bool isMember = false;
  OrderModel? lastIncompleteOfflineBooking;

  UserInfoModel({this.id, this.fName, this.lName, this.email, this.image, this.isPhoneVerified, this.emailVerifiedAt, this.createdAt, this.updatedAt, this.emailVerificationToken, this.phone, this.cmFirebaseToken, this.loginMedium, this.referCode, this.walletBalance, this.point, this.totalPointValue = 0, this.isMember = false, this.lastIncompleteOfflineBooking});

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is num) {
      return value == 1;
    }

    final String stringValue = '${value ?? ''}'.toLowerCase();
    return stringValue == 'true' || stringValue == '1';
  }

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    loginMedium = '${json['login_medium'] ?? ''}';
    referCode = json['referral_code'];
    walletBalance = double.tryParse('${json['wallet_balance']}');
    point = double.tryParse('${json['loyalty_point']}');
    totalPointValue = int.tryParse('${json['total_point_value'] ?? 0}') ?? 0;
    isMember = _parseBool(json['is_member']);
    lastIncompleteOfflineBooking = json['last_incomplete_offline_booking'] != null ? OrderModel.fromJson(json['last_incomplete_offline_booking']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    data['is_phone_verified'] = isPhoneVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['email_verification_token'] = emailVerificationToken;
    data['phone'] = phone;
    data['cm_firebase_token'] = cmFirebaseToken;
    data['login_medium'] = loginMedium;
    data['referral_code'] = referCode;
    data['wallet_balance'] = walletBalance;
    data['point'] = point;
    data['total_point_value'] = totalPointValue;
    data['is_member'] = isMember;
    return data;
  }
}
