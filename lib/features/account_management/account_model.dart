// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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

class NetworkAccount {
  int id;
  String phoneNumber;
  String? email;
  DateTime? lastRunDate;
  DateTime? lastUpdated;
  DateTime? lastAuthenticated;
  int loyaltyPoints;
  String? accessToken;
  String? refreshToken;
  bool isExpired;

  NetworkAccount({
    required this.id,
    this.phoneNumber = "0",
    this.email,
    this.lastRunDate,
    this.lastUpdated,
    this.lastAuthenticated,
    this.loyaltyPoints = 0,
    this.accessToken,
    this.refreshToken,
    this.isExpired = false,
  });

  @override
  String toString() {
    return 'NetworkAccount(id: $id, phoneNumber: $phoneNumber, lastRunDate: $lastRunDate, loyaltyPoints: $loyaltyPoints,accessToken: $accessToken,lastRunDate: $lastRunDate,isExpired: $isExpired,)';
  }

  Map<String, String> toMap(String? email) {
    return {
      'phone_number': phoneNumber,
      'last_run_date':
          lastRunDate?.toIso8601String() ?? "", // Handle null value
      'loyalty_points': loyaltyPoints.toString(),
      'access_token': accessToken ?? "", // Handle null value
      'refresh_token': refreshToken ?? "Invalid Token", // Handle null value
      'is_expired': isExpired.toString(),
      'last_updated': DateTime.now().toIso8601String(),
      'email': email ?? "",
    };
  }

  Map<String, String> toUpdateMap(String? email) {
    return {
      'phone_number': phoneNumber,
      'loyalty_points': loyaltyPoints.toString(),
      'access_token': accessToken ?? "", // Handle null value
      'refresh_token': refreshToken ?? "Invalid Token", // Handle null value
      'is_expired': isExpired.toString(),
      'last_updated': DateTime.now().toIso8601String(),
      'email': email ?? "",
    };
  }

  Map<String, String> toRefreshTokensMap() {
    return {
      'access_token': accessToken ?? "Invalid Token", // Handle null value
      'refresh_token': refreshToken ?? "Invalid Token", // Handle null value
      'last_updated': DateTime.now().toIso8601String(),
      'last_authenticated': DateTime.now().toIso8601String(),
      'is_expired': false.toString(),
    };
  }
}

class NetworkAccountDataSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];

  NetworkAccountDataSource({required List<NetworkAccount> accounts}) {
    int rowNo = 1;
    _dataGridRows = accounts.map<DataGridRow>((account) {
      return DataGridRow(
        cells: [
          DataGridCell<int>(columnName: "id", value: account.id),
          DataGridCell<int>(columnName: 'No', value: rowNo++),
          DataGridCell<String>(
            columnName: 'Phone Number',
            value: account.phoneNumber,
          ),
          DataGridCell<int>(
            columnName: 'Loyalty Points',
            value: account.loyaltyPoints,
          ),
          DataGridCell<String>(
            columnName: 'Date Added',
            value: account.lastRunDate != null
                ? DateFormat('yyyy-MM-dd HH:mm').format(account.lastRunDate!)
                : null,
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            dataGridCell.value?.toString() ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
