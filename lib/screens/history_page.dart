import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final String userId;

  const HistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = "${now.day} ${_monthName(now.month)} ${now.year}";
    final formattedDay = _weekDay(now.weekday);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Column(
        children: [
          // 🔷 Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF009688),
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
                  child: Text(
                    "History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formattedDate,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                      Text(formattedDay,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔄 Scrollable history content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔸 Attendance History
                  _sectionTitle("🗓 Attendance History"),
                  _historyCard(
                    children: const [
                      _HistoryItem(
                        date: "18 June 2025",
                        status: "Present",
                        checkIn: "09:00 AM",
                        checkOut: "06:10 PM",
                      ),
                      _HistoryItem(
                        date: "17 June 2025",
                        status: "Absent",
                      ),
                      _HistoryItem(
                        date: "16 June 2025",
                        status: "Present",
                        checkIn: "09:05 AM",
                        checkOut: "05:58 PM",
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 💰 Payment History
                  _sectionTitle("💰 Payment History"),
                  _historyCard(
                    children: const [
                      _PaymentItem(
                        month: "June 2025",
                        status: "Paid",
                        amount: "₹22,000",
                        date: "05 June 2025",
                      ),
                      _PaymentItem(
                        month: "May 2025",
                        status: "Paid",
                        amount: "₹22,000",
                        date: "05 May 2025",
                      ),
                      _PaymentItem(
                        month: "April 2025",
                        status: "Pending",
                        amount: "₹22,000",
                        date: "-",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _historyCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(children: children),
    );
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  String _weekDay(int weekday) {
    const days = [
      "Monday", "Tuesday", "Wednesday", "Thursday",
      "Friday", "Saturday", "Sunday"
    ];
    return days[weekday - 1];
  }
}

// 🔹 Attendance Item
class _HistoryItem extends StatelessWidget {
  final String date;
  final String status;
  final String? checkIn;
  final String? checkOut;

  const _HistoryItem({
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor =
    status == "Present" ? Colors.green : Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.w500)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(status, style: TextStyle(color: statusColor)),
              if (status == "Present" && checkIn != null && checkOut != null)
                Text("In: $checkIn | Out: $checkOut",
                    style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}

// 💸 Payment Item
class _PaymentItem extends StatelessWidget {
  final String month;
  final String status;
  final String amount;
  final String date;

  const _PaymentItem({
    required this.month,
    required this.status,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor =
    status == "Paid" ? Colors.green : Colors.orangeAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month, style: const TextStyle(fontWeight: FontWeight.w500)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("$status ($amount)", style: TextStyle(color: statusColor)),
              Text("Credited on: $date", style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
