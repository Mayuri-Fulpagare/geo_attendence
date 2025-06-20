import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:slide_to_act/slide_to_act.dart';

import '../services/location_service.dart';

const String backendUrl = "http://192.168.1.36/flutter_api/mark_attendance.php";
const String checkOutUrl = "http://192.168.1.36/flutter_api/check_out.php";

class AttendancePage extends StatefulWidget {
  final String userId;
  const AttendancePage({super.key, required this.userId});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? _checkInTime;
  String? _checkOutTime;
  Duration _workingDuration = Duration.zero;
  Timer? _workingTimer;
  bool _isCheckedIn = false;

  Future<void> _markAttendance() async {
    Position position = await LocationService.getCurrentLocation();

    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": widget.userId,
        "latitude": position.latitude,
        "longitude": position.longitude,
      }),
    );

    final data = json.decode(response.body);
    if (data["success"] == true && data["message"].contains("Present")) {
      _checkInTime = data["check_in"];
      _isCheckedIn = true;
      _startWorkingTimer();
    }

    setState(() {});
  }

  void _startWorkingTimer() {
    _workingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _workingDuration += const Duration(seconds: 1);
      });
    });
  }

  void _stopWorkingTimer() async {
    _workingTimer?.cancel();

    final response = await http.post(
      Uri.parse(checkOutUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": widget.userId}),
    );

    final data = jsonDecode(response.body);
    if (data['success']) {
      setState(() {
        _checkOutTime = data['check_out'];
        final parts = data['working_hours'].split(":");
        _workingDuration = Duration(
          hours: int.parse(parts[0]),
          minutes: int.parse(parts[1]),
          seconds: int.parse(parts[2]),
        );
        _isCheckedIn = false;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes % 60)}:${twoDigits(duration.inSeconds % 60)}";
  }

  @override
  void dispose() {
    _workingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = "${now.day} ${_monthName(now.month)} ${now.year}";
    final formattedDay = _weekDay(now.weekday);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF), // light background
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF009688), // Teal
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            width: double.infinity,
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Attendance",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        formattedDay,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [
                const Text("Working Hours",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 10),
                Text(
                  _formatDuration(_workingDuration),
                  style: const TextStyle(
                    fontSize: 32,
                    color: Color(0xFF00796B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.orange),
                      SizedBox(width: 8),
                      Text("Shift: 10:00 AM - 7:00 PM"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.local_cafe, color: Colors.orange),
                      SizedBox(width: 8),
                      Text("Break: 00:00"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Today's Activity",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  if (_checkInTime != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.login, color: Colors.green),
                            SizedBox(width: 8),
                            Text("In"),
                          ],
                        ),
                        Text(_checkInTime!),
                      ],
                    ),
                  if (_checkOutTime != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Out"),
                            ],
                          ),
                          Text(_checkOutTime!),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SlideAction(
              borderRadius: 24,
              elevation: 4,
              innerColor: Colors.white,
              outerColor:
              _isCheckedIn ? Colors.redAccent : Colors.green.shade600,
              text: _isCheckedIn ? "Slide to Check-Out" : "Slide to Check-In",
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onSubmit: () {
                if (!_isCheckedIn) {
                  _markAttendance();
                } else {
                  _stopWorkingTimer();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  String _weekDay(int weekday) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[weekday - 1];
  }
}
