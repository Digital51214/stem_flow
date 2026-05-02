import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/background.dart';

class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body:Bg(

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mq.height * 0.015),

                Image.asset(
                  "assets/images/Logo.png",
                  height: mq.height * 0.055,
                ),

                SizedBox(height: mq.height * 0.035),

                Text(
                  "My Tasks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.042,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: mq.height * 0.02),

                _TaskCard(
                  mq: mq,
                  phase: "Testing Phase",
                  status: "To Do",
                  statusColor: Colors.white,
                  title: "Aerodynamic Tunnel Calibration",
                  date: "Oct 24, 2024",
                ),

                SizedBox(height: mq.height * 0.018),

                _TaskCard(
                  mq: mq,
                  phase: "Testing Phase",
                  status: "In Progress",
                  statusColor: const Color(0xFFD7C848),
                  title: "Aerodynamic Tunnel Calibration",
                  date: "Oct 20, 2024",
                ),

                SizedBox(height: mq.height * 0.018),

                _TaskCard(
                  mq: mq,
                  phase: "Testing Phase",
                  status: "On Hold",
                  statusColor: Colors.black,
                  title: "Aerodynamic Tunnel Calibration",
                  date: "Oct 28, 2024",
                ),

                SizedBox(height: mq.height * 0.018),

                Opacity(
                  opacity: 0.55,
                  child: _TaskCard(
                    mq: mq,
                    phase: "Testing Phase",
                    status: "Completed",
                    statusColor: Colors.redAccent,
                    title: "Aerodynamic Tunnel Calibration",
                    date: "Oct 24, 2024",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Size mq;
  final String phase;
  final String status;
  final Color statusColor;
  final String title;
  final String date;

  const _TaskCard({
    required this.mq,
    required this.phase,
    required this.status,
    required this.statusColor,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.13,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mq.width * 0.055,
        vertical: mq.height * 0.018,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF79D4D3).withOpacity(0.55),
        borderRadius: BorderRadius.circular(mq.width * 0.045),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  phase,
                  style: TextStyle(
                    color: const Color(0xFF287D80),
                    fontSize: mq.width * 0.026,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: mq.width * 0.026,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: mq.height * 0.012),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.034,
              fontWeight: FontWeight.w900,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: Colors.white,
                size: mq.width * 0.032,
              ),
              SizedBox(width: mq.width * 0.01),
              Text(
                date,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.024,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(width: mq.width * 0.05),

              Icon(
                Icons.speed_rounded,
                color: Colors.white,
                size: mq.width * 0.032,
              ),
              SizedBox(width: mq.width * 0.01),
              Text(
                "High Velocity",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.024,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}