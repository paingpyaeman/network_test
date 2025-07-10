import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PointChangeSchedule {
  late DateTime createdAt;
  late DateTime updatedAt;
  int? id;
  late DateTime scheduleDate;
  String? redeemKeyword;
  bool? status;

  PointChangeSchedule({
    required this.createdAt,
    required this.updatedAt,
    this.id,
    required this.scheduleDate,
    this.redeemKeyword,
    this.status,
  });

  PointChangeSchedule.fromJson(Map<String, dynamic> json) {
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int);
    updatedAt = DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int);
    id = json['id'];
    scheduleDate = DateTime.fromMillisecondsSinceEpoch(
      json['scheduleDate'] as int,
    );
    redeemKeyword = json['redeemKeyword'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    data['scheduleDate'] = scheduleDate;
    data['redeemKeyword'] = redeemKeyword;
    data['status'] = status;
    return data;
  }

  @override
  String toString() {
    return 'PointChangeSchedule{id: $id, scheduleDate: $scheduleDate, redeemKeyword: $redeemKeyword, status: $status}';
  }
}

class ScheduleSaveRequest {
  List<String>? scheduleDates;
  String? redeemKeyword;

  ScheduleSaveRequest({this.scheduleDates, this.redeemKeyword});

  ScheduleSaveRequest.fromJson(Map<String, dynamic> json) {
    scheduleDates = json['scheduleDates'].cast<String>();
    redeemKeyword = json['redeemKeyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheduleDates'] = this.scheduleDates;
    data['redeemKeyword'] = this.redeemKeyword;
    return data;
  }
}

class ScheduleDataSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];

  ScheduleDataSource({required List<PointChangeSchedule> schedules}) {
    int rowNo = 1;
    _dataGridRows = schedules.map<DataGridRow>((schedule) {
      return DataGridRow(
        cells: [
          DataGridCell<int>(columnName: 'ID', value: schedule.id),
          DataGridCell<int>(columnName: 'No', value: rowNo++),
          DataGridCell<String>(
            columnName: 'Schedule Date',
            value: DateFormat('yyyy-MM-dd').format(schedule.scheduleDate),
          ),
          DataGridCell<String>(
            columnName: 'Redeem Award',
            value: schedule.redeemKeyword,
          ),
          DataGridCell<String>(
            columnName: 'Status',
            value: schedule.status! ? 'Done' : 'Upcoming',
          ),
          DataGridCell<String>(
            columnName: 'Date Added',
            value: DateFormat(
              'yyyy-MM-dd hh:mm:ss a',
            ).format(schedule.createdAt),
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
