import 'package:flutter/material.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Schedule List Screen"));
  }
}
