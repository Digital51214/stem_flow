import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/background.dart';

import 'notification_screen_teamSide.dart';

class HomeTask extends StatelessWidget {
  const HomeTask({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.065),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mq.height * 0.025),

                Row(
                  children: [
                    Image.asset(
                      "assets/images/Logo.png",
                      width: mq.width * 0.12,
                    ),
                    SizedBox(width: mq.width * 0.035),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "MEMBER DASHBOARD",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: mq.width * 0.025,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.7,
                          ),
                        ),
                        Text(
                          "Welcome Alex.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: mq.width * 0.047,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreenTeams(),
                          ),
                        );
                      },
                      child: Container(
                        height: mq.width * 0.145,
                        width: mq.width * 0.145,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Color(0xFF157E82),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: mq.height * 0.045),

                _SectionTitle(text: "My Tasks", mq: mq),

                SizedBox(height: mq.height * 0.018),

                _TaskCard(
                  mq: mq,
                  title: "Aerodynamic Tunnel Calibration",
                  project: "CFD Optimization",
                ),

                SizedBox(height: mq.height * 0.018),

                _TaskCard(
                  mq: mq,
                  title: "Aerodynamic Tunnel Calibration",
                  project: "Logistics",
                ),

                SizedBox(height: mq.height * 0.03),

                _SectionTitle(text: "Next Meeting", mq: mq),

                SizedBox(height: mq.height * 0.018),

                _MeetingCard(mq: mq),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Size mq;

  const _SectionTitle({
    required this.text,
    required this.mq,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: mq.width * 0.047,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Size mq;
  final String title;
  final String project;

  const _TaskCard({
    required this.mq,
    required this.title,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.115,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mq.width * 0.07,
        vertical: mq.height * 0.026,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF71C5C6).withOpacity(0.55),
        borderRadius: BorderRadius.circular(mq.width * 0.055),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.041,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: mq.height * 0.008),
          Text(
            "Project: $project",
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.031,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final Size mq;

  const _MeetingCard({
    required this.mq,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.2,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mq.width * 0.07,
        vertical: mq.height * 0.022,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF8BDCDD).withOpacity(0.65),
        borderRadius: BorderRadius.circular(mq.width * 0.055),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "In 45 Minutes",
            style: TextStyle(
              color: const Color(0xFF157E82),
              fontSize: mq.width * 0.032,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: mq.height * 0.022),
          Text(
            "Aerodynamic Sync",
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.041,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: mq.height * 0.008),
          Text(
            "Briefing on silverstone wind tunnel data\nwith the senior lead.",
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.029,
              height: 1.1,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _AvatarCircle(mq: mq, image: "assets/images/member1.png"),
              Transform.translate(
                offset: Offset(-mq.width * 0.018, 0),
                child: _AvatarCircle(mq: mq, image: "assets/images/member2.png"),
              ),
              Transform.translate(
                offset: Offset(-mq.width * 0.036, 0),
                child: _AvatarCircle(mq: mq, image: "assets/images/member3.png"),
              ),
              Transform.translate(
                offset: Offset(-mq.width * 0.054, 0),
                child: Container(
                  height: mq.width * 0.065,
                  width: mq.width * 0.065,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: const Color(0xFF157E82),
                    size: mq.width * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final Size mq;
  final String image;

  const _AvatarCircle({
    required this.mq,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.width * 0.065,
      width: mq.width * 0.065,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}