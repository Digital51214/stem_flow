import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/AddEventsScreen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

import 'Services/show_team_events.dart';
import 'models/team_event_model.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool isLoading = false;
  TeamEventsModel? teamEvents;
  Timer? refreshTimer;

  final int teamId = 1;
  final String apiKey = 'YOUR_API_KEY_HERE';

  @override
  void initState() {
    super.initState();
    fetchTeamEvents();

    refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      print('Auto refreshing team events...');
      fetchTeamEvents(showLoader: false);
    });
  }

  Future<void> fetchTeamEvents({bool showLoader = true}) async {
    if (!mounted) return;

    if (showLoader) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      print('Fetching team events...');

      final result = await ShowTeamEventService.getTeamEvents(
        teamId: teamId,
        apiKey: apiKey,
      );

      print('Team events updated on screen');
      print('Upcoming Events Count: ${result.upcomingSchedule.length}');

      if (!mounted) return;

      setState(() {
        teamEvents = result;
      });
    } catch (e) {
      print('Fetch Team Events Error: $e');

      if (mounted) {
        showToast('Failed to load team events');
      }
    } finally {
      if (mounted && showLoader) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF287D80),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Future<void> openAddEventScreen() async {
    final isAdded = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEventScreen(),
      ),
    );

    print('Returned from Add Event Screen: $isAdded');

    if (isAdded == true) {
      print('Refreshing upcoming schedule...');
      fetchTeamEvents(showLoader: false);
    }
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final activeSprint = teamEvents?.activeSprint;
    final upcomingSchedule = teamEvents?.upcomingSchedule ?? [];

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
              child: RefreshIndicator(
                color: const Color(0xFF287D80),
                onRefresh: () => fetchTeamEvents(showLoader: false),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: mq.width * 0.055),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: mq.height * 0.045),

                      Row(
                        children: [
                          BackCircle(onTap: () => Navigator.pop(context)),
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
                        "Events & Meetings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: mq.width * 0.05,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      SizedBox(height: mq.height * 0.02),

                      if (isLoading)
                        SizedBox(
                          height: mq.height * 0.45,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF287D80),
                            ),
                          ),
                        )
                      else ...[
                        _GlassCard(
                          mq: mq,
                          height: mq.height * 0.16,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: mq.width * 0.03,
                              horizontal: mq.width * 0.045,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeSprint?.title ?? "No Active Sprint",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: mq.width * 0.042,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: mq.height * 0.006),
                                Text(
                                  activeSprint?.subtitle ?? "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: mq.width * 0.028,
                                  ),
                                ),
                                SizedBox(height: mq.height * 0.02),
                                Padding(
                                  padding:
                                  EdgeInsets.only(left: mq.width * 0.012),
                                  child: SizedBox(
                                    height: mq.width * 0.09,
                                    width: mq.width * 0.30,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          left: 0,
                                          child: _Avatar(
                                            mq,
                                            "assets/images/member1.png",
                                          ),
                                        ),
                                        Positioned(
                                          left: mq.width * 0.055,
                                          child: _Avatar(
                                            mq,
                                            "assets/images/member2.png",
                                          ),
                                        ),
                                        Positioned(
                                          left: mq.width * 0.110,
                                          child: _Avatar(
                                            mq,
                                            "assets/images/member3.png",
                                          ),
                                        ),
                                        Positioned(
                                          left: mq.width * 0.165,
                                          child: Container(
                                            height: mq.width * 0.09,
                                            width: mq.width * 0.09,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(
                                                mq.width * 0.03,
                                              ),
                                            ),
                                            child: Text(
                                              activeSprint?.membersLabel ??
                                                  "+0",
                                              style: TextStyle(
                                                color:
                                                const Color(0xFF287D80),
                                                fontWeight: FontWeight.w900,
                                                fontSize: mq.width * 0.028,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: mq.height * 0.018),

                        Text(
                          "Upcoming Schedule",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: mq.width * 0.032,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        SizedBox(height: mq.height * 0.012),

                        if (upcomingSchedule.isEmpty)
                          SizedBox(
                            height: mq.height * 0.18,
                            child: const Center(
                              child: Text(
                                "No upcoming events found",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: upcomingSchedule.length,
                            itemBuilder: (context, index) {
                              final event = upcomingSchedule[index];

                              return _EventCard(
                                mq,
                                title: event.title,
                                date: event.date,
                                time: event.time,
                              );
                            },
                          ),
                      ],

                      SizedBox(height: mq.height * 0.025),

                      GestureDetector(
                        onTap: openAddEventScreen,
                        child: Container(
                          height: mq.height * 0.058,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF287D80),
                            borderRadius:
                            BorderRadius.circular(mq.width * 0.09),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: mq.width * 0.05,
                              ),
                              SizedBox(width: mq.width * 0.015),
                              Text(
                                "Add Events",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: mq.width * 0.04,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: mq.height * 0.08),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Avatar(Size mq, String image) {
    return Container(
      height: mq.width * 0.09,
      width: mq.width * 0.09,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.03),
        border: Border.all(
          color: const Color(0xFF287D80),
          width: 2,
        ),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Size mq;
  final String title;
  final String date;
  final String time;

  const _EventCard(
      this.mq, {
        required this.title,
        required this.date,
        required this.time,
      });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF287D80);

    return Padding(
      padding: EdgeInsets.only(bottom: mq.height * 0.01),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(mq.width * 0.055),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: mq.height * 0.1,
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            decoration: BoxDecoration(
              color: const Color(0xFF4EB7BD).withOpacity(0.48),
              borderRadius: BorderRadius.circular(mq.width * 0.055),
              border: Border.all(
                color: Colors.white.withOpacity(0.14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: mq.height * 0.055,
                  width: mq.width * 0.025,
                  decoration: BoxDecoration(
                    color: teal,
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
                          fontSize: mq.width * 0.04,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: mq.height * 0.006),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: mq.width * 0.035,
                          ),
                          SizedBox(width: mq.width * 0.015),
                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mq.width * 0.03,
                            ),
                          ),
                          SizedBox(width: mq.width * 0.04),
                          Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: mq.width * 0.035,
                          ),
                          SizedBox(width: mq.width * 0.015),
                          Expanded(
                            child: Text(
                              time,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: mq.width * 0.03,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: mq.width * 0.06,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Size mq;
  final double height;
  final Widget child;

  const _GlassCard({
    required this.mq,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.width * 0.055),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.48),
            borderRadius: BorderRadius.circular(mq.width * 0.055),
            border: Border.all(
              color: Colors.white.withOpacity(0.14),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}