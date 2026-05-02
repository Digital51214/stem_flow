import 'package:flutter/material.dart';

import '../Widgets/background.dart';

class NotificationsScreenTeams extends StatelessWidget {
  const NotificationsScreenTeams({super.key});

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

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: mq.width * 0.105,
                        width: mq.width * 0.105,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: const Color(0xFF287D80),
                          size: mq.width * 0.045,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/images/Logo.png",
                      height: mq.height * 0.05,
                    ),
                  ],
                ),

                SizedBox(height: mq.height * 0.045),

                Text(
                  "Notifications",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: mq.height * 0.02),

                _DayLabel(text: "Today", mq: mq),

                SizedBox(height: mq.height * 0.012),

                _NotificationCard(
                  mq: mq,
                  title: "DRS Calibration Deadline",
                  subtitle: "Finalize Car Design is due in 4 hours.",
                  time: "2h ago",
                  indicatorColor: Colors.red,
                ),

                SizedBox(height: mq.height * 0.014),

                _NotificationCard(
                  mq: mq,
                  title: "Meeting Scheduled",
                  subtitle: "Team meeting at 3:00 PM",
                  time: "Today",
                  indicatorColor: const Color(0xFF287D80),
                ),

                SizedBox(height: mq.height * 0.014),

                _NotificationCard(
                  mq: mq,
                  title: "Front Wing Simult Complete",
                  subtitle: "Wind Tunnel Report submission is due 5PM",
                  time: "11h ago",
                  indicatorColor: const Color(0xFF287D80),
                ),

                SizedBox(height: mq.height * 0.025),

                _DayLabel(text: "Yesterday", mq: mq),

                SizedBox(height: mq.height * 0.012),

                _NotificationCard(
                  mq: mq,
                  title: "Meeting Scheduled",
                  subtitle: "Technical Review with Engineering Lead",
                  time: "Yesterday",
                  indicatorColor: const Color(0xFF287D80),
                ),

                SizedBox(height: mq.height * 0.014),

                _NotificationCard(
                  mq: mq,
                  title: "Task Completed Report",
                  subtitle: "Weekly Sprint Planning",
                  time: "Yesterday",
                  indicatorColor: const Color(0xFF287D80),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String text;
  final Size mq;

  const _DayLabel({
    required this.text,
    required this.mq,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.85),
        fontSize: mq.width * 0.028,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Size mq;
  final String title;
  final String subtitle;
  final String time;
  final Color indicatorColor;

  const _NotificationCard({
    required this.mq,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.092,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFF79D4D3).withOpacity(0.58),
        borderRadius: BorderRadius.circular(mq.width * 0.045),
      ),
      child: Row(
        children: [
          Container(
            height: mq.height * 0.056,
            width: mq.width * 0.017,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(mq.width * 0.025),
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
                    fontSize: mq.width * 0.036,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: mq.height * 0.007),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: mq.width * 0.026,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: mq.width * 0.02),

          Text(
            time,
            style: TextStyle(
              color: const Color(0xFF287D80),
              fontSize: mq.width * 0.027,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}