import 'package:flutter/material.dart';

import '../Widgets/background.dart';

class EventsMeetingsScreen extends StatelessWidget {
  const EventsMeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(

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

                SizedBox(height: mq.height * 0.04),

                Text(
                  "Events & Meetings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.04,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: mq.height * 0.018),

                _MainMeetingCard(mq: mq),

                SizedBox(height: mq.height * 0.018),

                Text(
                  "Yesterday",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: mq.width * 0.027,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: mq.height * 0.012),

                _SmallEventCard(
                  mq: mq,
                  title: "Wind Tunnel Prep",
                  date: "Oct 24, 2026",
                  type: "Aero Team",
                ),

                SizedBox(height: mq.height * 0.012),

                _SmallEventCard(
                  mq: mq,
                  title: "F1 Competition",
                  date: "Oct 29, 2026",
                  type: "Remote Link",
                ),

                SizedBox(height: mq.height * 0.012),

                _SmallEventCard(
                  mq: mq,
                  title: "Data Analysis Review",
                  date: "Oct 28, 2026",
                  type: "Mandatory",
                ),

                const Spacer(),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainMeetingCard extends StatelessWidget {
  final Size mq;

  const _MainMeetingCard({required this.mq});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.17,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mq.width * 0.055,
        vertical: mq.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF79D4D3).withOpacity(0.55),
        borderRadius: BorderRadius.circular(mq.width * 0.045),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "In 45 Minutes",
            style: TextStyle(
              color: Colors.red,
              fontSize: mq.width * 0.027,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: mq.height * 0.018),
          Text(
            "Aerodynamic Sync",
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.034,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: mq.height * 0.01),
          Text(
            "Briefing on silverstone wind tunnel data\nwith the senior lead.",
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.027,
              height: 1.15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallEventCard extends StatelessWidget {
  final Size mq;
  final String title;
  final String date;
  final String type;

  const _SmallEventCard({
    required this.mq,
    required this.title,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.095,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF79D4D3).withOpacity(0.62),
        borderRadius: BorderRadius.circular(mq.width * 0.04),
      ),
      child: Row(
        children: [
          SizedBox(width: mq.width * 0.045),

          Container(
            height: mq.height * 0.045,
            width: mq.width * 0.018,
            decoration: BoxDecoration(
              color: const Color(0xFF287D80),
              borderRadius: BorderRadius.circular(mq.width * 0.02),
            ),
          ),

          SizedBox(width: mq.width * 0.04),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.035,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: mq.height * 0.012),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size: mq.width * 0.031,
                    ),
                    SizedBox(width: mq.width * 0.012),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.023,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(width: mq.width * 0.04),

                    Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: mq.width * 0.031,
                    ),
                    SizedBox(width: mq.width * 0.012),
                    Text(
                      type,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.023,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}