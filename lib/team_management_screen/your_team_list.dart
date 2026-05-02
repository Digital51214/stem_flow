import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stemflow/Widgets/BigButton.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Widgets/progless_line.dart';
import 'package:stemflow/Widgets/roundedfield.dart';
import 'package:stemflow/services/join_team_service.dart';
import 'package:stemflow/Services/session_manager.dart';
import '../AddMemberScreen.dart';
import '../Services/team_list_service.dart';
import '../TeamconfigrationScreen.dart';
import '../models/teams_models.dart';
import 'add_members_screen.dart';
import 'create_new_team.dart';

class YourTeamsScreen extends StatefulWidget {
  const YourTeamsScreen({super.key});

  @override
  State<YourTeamsScreen> createState() => _YourTeamsScreenState();
}

class _YourTeamsScreenState extends State<YourTeamsScreen> {
  bool isLoading = false;
  List<MyTeamModel> teams = [];

  @override
  void initState() {
    super.initState();
    fetchMyTeams();
  }

  Future<void> fetchMyTeams() async {
    setState(() => isLoading = true);

    try {
      final userIdText = await SessionManager.instance.getUserId();
      final userId = int.tryParse(userIdText) ?? 0;

      final result = await MyTeamService.getMyTeams(
        userId: userId,
        apiKey: "YOUR_API_KEY_HERE",
      );
      if (!mounted) return;
      setState(() => teams = result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> openCreateTeamScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTeamScreen()),
    );
    fetchMyTeams();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mq.height * 0.015),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Color(0xFF287D80),
                        ),
                      ),
                    ),
                    Image.asset("assets/images/Logo.png", height: 45, width: 45),
                  ],
                ),

                const SizedBox(height: 28),

                const Text(
                  "Your Teams",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Mynor",
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Assign and update technical roles for the engineering\nteam. Changes are logged to dashboards immediately.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Mynor",
                  ),
                ),

                const SizedBox(height: 28),

                Expanded(
                  child: RefreshIndicator(
                    color: const Color(0xFF287D80),
                    onRefresh: fetchMyTeams,
                    child: isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF287D80),
                      ),
                    )
                        : teams.isEmpty
                        ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Center(
                          child: Text(
                            "No teams found",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Mynor",
                            ),
                          ),
                        ),
                      ],
                    )
                        : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: teams.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Pass team.id to navigate
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TeamConfigurationScreen(
                                  teamId: teams[index].id,
                                ),
                              ),
                            );
                          },
                          child: TeamCard(
                            team: teams[index],
                            showMembers: index % 2 != 0,
                            onPlusTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddMemberScreen1(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Column(
                  children: [
                    Transform.translate(
                      offset: const Offset(110, 0),
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Image.asset(
                          "assets/images/errow.png",
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 36,
                          width: 150,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9DDFDD).withOpacity(0.75),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Create your new Team",
                            style: TextStyle(
                              color: Color(0xFF287D80),
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Mynor",
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: openCreateTeamScreen,
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF287D80),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  Widget plusSmall(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 22,
        width: 22,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, size: 16, color: Color(0xFF555555)),
      ),
    );
  }

  Widget memberAvatar(String image) {
    return CircleAvatar(
      radius: 13,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 12,
        backgroundImage: AssetImage(image),
      ),
    );
  }

  Widget overlapAvatar(String image) {
    return Transform.translate(
      offset: const Offset(-8, 0),
      child: memberAvatar(image),
    );
  }

// ─── TeamCard (same as before) ───────────────────────────────────────────────

class TeamCard extends StatelessWidget {
  final MyTeamModel team;
  final bool showMembers;
  final VoidCallback onPlusTap;

  const TeamCard({
    super.key,
    required this.team,
    required this.showMembers,
    required this.onPlusTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: 96,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF6FC7C8).withOpacity(0.55),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/member1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            team.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Mynor",
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          team.inviteCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Mynor",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      team.year,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Mynor",
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        showMembers
                            ? Row(
                          children: [
                            memberAvatar("assets/images/member1.png"),
                            overlapAvatar("assets/images/member2.png"),
                            Transform.translate(
                              offset: const Offset(-8, 0),
                              child: overlapAvatar(
                                  "assets/images/member3.png"),
                            ),
                            Transform.translate(
                              offset: const Offset(-22, 0),
                              child: plusSmall(onPlusTap),
                            ),
                          ],
                        )
                            : plusSmall(onPlusTap),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: team.inviteCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Invite code copied")),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.copy, size: 15, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "copy Code",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Mynor",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget plusSmall(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 22,
        width: 22,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, size: 16, color: Color(0xFF555555)),
      ),
    );
  }

  Widget memberAvatar(String image) {
    return CircleAvatar(
      radius: 13,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 12,
        backgroundImage: AssetImage(image),
      ),
    );
  }

  Widget overlapAvatar(String image) {
    return Transform.translate(
      offset: const Offset(-8, 0),
      child: memberAvatar(image),
    );
  }
}