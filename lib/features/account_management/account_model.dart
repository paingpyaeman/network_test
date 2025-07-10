// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MyIDAccount {
  String phoneNumber;
  int? mainBalance;
  int? voiceBalance;
  int? dataBalance;
  String? dataExpireTime;
  int? loyaltyPoints;
  String? accessToken;
  String? refreshToken;

  MyIDAccount({
    this.phoneNumber = "0",
    this.mainBalance = 0,
    this.voiceBalance = 0,
    this.dataBalance = 0,
    this.dataExpireTime = "dd/MM/yyyy",
    this.loyaltyPoints = 0,
    this.accessToken,
    this.refreshToken,
  });

  void clearValues() {
    phoneNumber = "0";
    mainBalance = 0;
    voiceBalance = 0;
    dataBalance = 0;
    loyaltyPoints = 0;
    dataExpireTime = "dd/MM/yyyy";
    accessToken = null;
    refreshToken = null;
  }

  MyIDAccount copyWith({
    String? phoneNumber,
    int? mainBalance,
    int? voiceBalance,
    int? dataBalance,
    String? dataExpireTime,
    int? loyaltyPoints,
    String? accessToken,
    String? refreshToken,
  }) {
    return MyIDAccount(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mainBalance: mainBalance ?? this.mainBalance,
      voiceBalance: voiceBalance ?? this.voiceBalance,
      dataBalance: dataBalance ?? this.dataBalance,
      dataExpireTime: dataExpireTime ?? this.dataExpireTime,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'mainBalance': mainBalance,
      'voiceBalance': voiceBalance,
      'dataBalance': dataBalance,
      'dataExpireTime': dataExpireTime,
      'loyaltyPoints': loyaltyPoints,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory MyIDAccount.fromMap(Map<String, dynamic> map) {
    return MyIDAccount(
      phoneNumber: map['phoneNumber'] as String,
      mainBalance: map['mainBalance'] != null
          ? map['mainBalance'] as int
          : null,
      voiceBalance: map['voiceBalance'] != null
          ? map['voiceBalance'] as int
          : null,
      dataBalance: map['dataBalance'] != null
          ? map['dataBalance'] as int
          : null,
      dataExpireTime: map['dataExpireTime'] != null
          ? map['dataExpireTime'] as String
          : null,
      loyaltyPoints: map['loyaltyPoints'] != null
          ? map['loyaltyPoints'] as int
          : null,
      accessToken: map['accessToken'] != null
          ? map['accessToken'] as String
          : null,
      refreshToken: map['refreshToken'] != null
          ? map['refreshToken'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyIDAccount.fromJson(String source) =>
      MyIDAccount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyIDAccount(phoneNumber: $phoneNumber, mainBalance: $mainBalance, voiceBalance: $voiceBalance, dataBalance: $dataBalance, dataExpireTime: $dataExpireTime, loyaltyPoints: $loyaltyPoints, accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(covariant MyIDAccount other) {
    if (identical(this, other)) return true;

    return other.phoneNumber == phoneNumber &&
        other.mainBalance == mainBalance &&
        other.voiceBalance == voiceBalance &&
        other.dataBalance == dataBalance &&
        other.dataExpireTime == dataExpireTime &&
        other.loyaltyPoints == loyaltyPoints &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return phoneNumber.hashCode ^
        mainBalance.hashCode ^
        voiceBalance.hashCode ^
        dataBalance.hashCode ^
        dataExpireTime.hashCode ^
        loyaltyPoints.hashCode ^
        accessToken.hashCode ^
        refreshToken.hashCode;
  }
}
