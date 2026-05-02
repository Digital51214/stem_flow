import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/TeamconfigrationScreen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  int get teamId => 0;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  String selectedRole = "ENGINEER";

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
              child: Padding(
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
                      "Add Member",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height*0.04),

                    _GlassCard(
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "MEMBER NAME",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),

                            SizedBox(height: mq.height*0.015),

                            SizedBox(
                              height: mq.height * 0.058,
                              child: TextField(
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: "Mynor",
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: "e.g. Lewis Hamiton",
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.92),
                                    fontSize: 10,
                                    fontFamily: "Mynor",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 17,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.65),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: mq.height*0.031),

                            const Text(
                              "ASSIGN ROLE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),

                            SizedBox(height: mq.height*0.015),

                            Container(
                              height: mq.height * 0.058,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.65),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  _RoleChip(
                                    title: "ENGINEER",
                                    isSelected: selectedRole == "ENGINEER",
                                    onTap: () {
                                      setState(() {
                                        selectedRole = "ENGINEER";
                                      });
                                    },
                                  ),
                                  _RoleChip(
                                    title: "DESIGNER",
                                    isSelected: selectedRole == "DESIGNER",
                                    onTap: () {
                                      setState(() {
                                        selectedRole = "DESIGNER";
                                      });
                                    },
                                  ),
                                  _RoleChip(
                                    title: "MANAGER",
                                    isSelected: selectedRole == "MANAGER",
                                    onTap: () {
                                      setState(() {
                                        selectedRole = "MANAGER";
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const _InfoCard(),

                    const SizedBox(height: 35),

                    _AddMemberButton(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamConfigurationScreen( teamId: widget.teamId)));
                      },
                    ),
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

class _RoleChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: mq.height*0.044,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF287D80) : Colors.white,
              fontSize: 9,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height*0.126,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF287D80).withOpacity(0.35),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF287D80),
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  height: 1,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  const TextSpan(
                    text: "New members will receive an invite\n"
                        "to join the ",
                  ),
                  TextSpan(
                    text: "STEMFlow",
                    style: TextStyle(
                      color: const Color(0xFF287D80).withOpacity(0.95),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text: " workspace via\nemail.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddMemberButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMemberButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF287D80),
        borderRadius: BorderRadius.circular(35),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(35),
        onTap: onTap,
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add Member",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 7),
              Icon(
                Icons.person_add_alt_1_outlined,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}