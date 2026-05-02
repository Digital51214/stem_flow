import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/BottomNavigation_screen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

class TeamConfigurationScreen extends StatefulWidget {
  const TeamConfigurationScreen({super.key, required int teamId});

  @override
  State<TeamConfigurationScreen> createState() =>
      _TeamConfigurationScreenState();
}

class _TeamConfigurationScreenState extends State<TeamConfigurationScreen> {
  String role1 = "Lead Engineer";
  String role2 = "Structural Engineer";
  String role3 = "Telemetry Specialist";

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
                      Colors.white.withOpacity(0.85),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: mq.height * 0.035),

                    Row(
                      children: [
                        BackCircle(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Spacer(),
                        Container(
                          height: 44,
                          width: 45,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/Logo.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: mq.height * 0.04),

                    const Text(
                      "Team Configuration",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Assign and update technical roles for thr engineering\n"
                          "team.Changes are logged to dashboards immediately.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 8,
                        height: 1.4,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _RoleMemberCard(
                      imagePath: "assets/images/image 1.png",
                      name: "Marcus Thorne",
                      roleTitle: "LEAD ENGINEER",
                      selectedRole: role1,
                      roles: const [
                        "Lead Engineer",
                        "Structural Engineer",
                        "Telemetry Specialist",
                        "Team Manager",
                      ],
                      onChanged: (value) {
                        setState(() {
                          role1 = value!;
                        });
                      },
                    ),

                    SizedBox(height: mq.height*0.01),

                    _RoleMemberCard(
                      imagePath: "assets/images/image 2.png",
                      name: "Sarah Jenkins",
                      roleTitle: "STRUCTURAL ENGINEER",
                      selectedRole: role2,
                      roles: const [
                        "Structural Engineer",
                        "Lead Engineer",
                        "Telemetry Specialist",
                        "Team Manager",
                      ],
                      onChanged: (value) {
                        setState(() {
                          role2 = value!;
                        });
                      },
                    ),

                    SizedBox(height: mq.height*0.01),

                    _RoleMemberCard(
                      imagePath: "assets/images/image 3.png",
                      name: "Marcus Thorne",
                      roleTitle: "TELEMETRY SPECIALIST",
                      selectedRole: role3,
                      roles: const [
                        "Telemetry Specialist",
                        "Lead Engineer",
                        "Structural Engineer",
                        "Team Manager",
                      ],
                      onChanged: (value) {
                        setState(() {
                          role3 = value!;
                        });
                      },
                    ),

                    SizedBox(height: mq.height*0.02),

                    _SaveChangesButton(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WidgetTree()),
                            (Route<dynamic>route)=>false);
                      },
                    ),

                    const SizedBox(height: 10),
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

class _RoleMemberCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String roleTitle;
  final String selectedRole;
  final List<String> roles;
  final ValueChanged<String?> onChanged;

  const _RoleMemberCard({
    required this.imagePath,
    required this.name,
    required this.roleTitle,
    required this.selectedRole,
    required this.roles,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return _GlassCard(
      height: mq.height*0.2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: mq.height*0.07,
                  width: mq.height*0.07,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(imagePath)),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        roleTitle,
                        style: const TextStyle(
                          color: Color(0xFF287D80),
                          fontSize: 8,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.more_vert,
                  color: Color(0xFF287D80),
                  size: 25,
                ),
              ],
            ),

            const SizedBox(height: 6),

            const Text(
              "Update Role",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: const Color(0xFF287D80),
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRole,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF287D80),
                    size: 28,
                  ),
                  dropdownColor: const Color(0xFF9ED5D6),
                  style: const TextStyle(
                    color: Color(0xFF287D80),
                    fontSize: 10,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w900,
                  ),
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final double height;
  final Widget child;

  const _GlassCard({
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.5),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SaveChangesButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SaveChangesButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height*0.058,
      decoration: BoxDecoration(
        color: const Color(0xFF287D80),
        borderRadius: BorderRadius.circular(35),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(35),
        onTap: onTap,
        child: const Center(
          child: Text(
            "Save Changes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}