import 'package:flutter/material.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  String? _leaveType;
  DateTime? _selectedDate;
  String? _dayType;
  final TextEditingController _reasonController = TextEditingController();

  bool showDayOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Leave'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: const Color(0xFFF5F9FF),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20, // important
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Leave Type", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _leaveType,
                hint: const Text("Choose leave type"),
                items: const [
                  DropdownMenuItem(value: 'Casual', child: Text('Casual')),
                  DropdownMenuItem(value: 'Sick', child: Text('Sick')),
                  DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                ],
                onChanged: (value) {
                  setState(() => _leaveType = value);
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 20),
              const Text("Select Date", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      showDayOptions = true;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedDate == null
                          ? "Tap to select date"
                          : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              if (showDayOptions) ...[
                const Text("Applying Leave For", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _dayType,
                  hint: const Text("Select day type"),
                  items: const [
                    DropdownMenuItem(value: 'Full Day', child: Text('Full Day')),
                    DropdownMenuItem(value: 'Half Day', child: Text('Half Day')),
                    DropdownMenuItem(value: 'Second Half', child: Text('Second Half')),
                  ],
                  onChanged: (value) {
                    setState(() => _dayType = value);
                  },
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                const Text("Reason", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Mention your reason",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_leaveType != null &&
                        _selectedDate != null &&
                        _dayType != null &&
                        _reasonController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Leave request submitted successfully")),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
