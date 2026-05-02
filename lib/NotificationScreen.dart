import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.white.withOpacity(0.88),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.055),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: mq.height * 0.045),

                    Row(
                      children: [
                        BackCircle(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Spacer(),
                        Container(
                          height: mq.height * 0.06,
                          width: mq.width * 0.13,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/Logo.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: mq.height * 0.03),

                    Text(
                      "Notifications",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.05,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height * 0.018),

                    _SectionTitle(mq: mq, title: "Today"),

                    SizedBox(height: mq.height * 0.013),

                    _NotificationCard(
                      mq: mq,
                      indicatorColor: Colors.red,
                      title: "Task Deadline Approaching",
                      description: "Finalize Car Design is due romorrow.",
                      time: "2h ago",
                    ),

                    SizedBox(height: mq.height * 0.01),

                    _NotificationCard(
                      mq: mq,
                      indicatorColor: const Color(0xFF287D80),
                      title: "Meeting Scheduled",
                      description: "Team meeting at 3:00 PM",
                      time: "Today",
                    ),

                    SizedBox(height: mq.height * 0.01),

                    _NotificationCard(
                      mq: mq,
                      indicatorColor: Colors.red,
                      title: "Task Deadline Approaching",
                      description: "Wind Tunnel Report submission is due 5PM",
                      time: "Today",
                    ),

                    SizedBox(height: mq.height * 0.025),

                    _SectionTitle(mq: mq, title: "Yesterday"),

                    SizedBox(height: mq.height * 0.013),

                    _NotificationCard(
                      mq: mq,
                      indicatorColor: const Color(0xFF287D80),
                      title: "Meeting Scheduled",
                      description: "Technical Review with Engineering Lead",
                      time: "Yesterday",
                    ),

                    SizedBox(height: mq.height * 0.01),

                    _NotificationCard(
                      mq: mq,
                      indicatorColor: const Color(0xFF287D80),
                      title: "Meeting Scheduled",
                      description: "Weekly Sprint Planning",
                      time: "Yesterday",
                    ),

                    SizedBox(height: mq.height * 0.08),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final Size mq;
  final String title;

  const _SectionTitle({
    required this.mq,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: mq.width * 0.038,
        fontFamily: "Mynor",
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Size mq;
  final Color indicatorColor;
  final String title;
  final String description;
  final String time;

  const _NotificationCard({
    required this.mq,
    required this.indicatorColor,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF287D80);

    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.width * 0.055),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          height: mq.height * 0.108,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.06),
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.48),
            borderRadius: BorderRadius.circular(mq.width * 0.055),
            border: Border.all(
              color: Colors.white.withOpacity(0.14),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: mq.height * 0.066,
                width: mq.width * 0.03,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(mq.width * 0.03),
                ),
              ),

              SizedBox(width: mq.width * 0.045),

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
                        fontSize: mq.width * 0.03,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height * 0.006),

                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.021,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: mq.width * 0.018),

              Text(
                time,
                maxLines: 1,
                style: TextStyle(
                  color: teal,
                  fontSize: mq.width * 0.03,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}