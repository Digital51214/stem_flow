import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/CreateTeamList.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

class CreateTeamScreen2 extends StatefulWidget {
  const CreateTeamScreen2({super.key});

  @override
  State<CreateTeamScreen2> createState() => _CreateTeamScreen2State();
}

class _CreateTeamScreen2State extends State<CreateTeamScreen2> {
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
                        BackCircle(onTap: (){
                          Navigator.pop(context);
                        }),
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

                    SizedBox(height: mq.height * 0.05),

                    const Text(
                      "Create Team",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Initialize your high-performance engineering unit.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 8,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 26),

                    _GlassCard(
                      height: mq.height*0.19,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "TEAM NAME",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: mq.height*0.058,
                              child: TextField(
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: "Mynor",
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: "e.g. Aerodynamics Lead",
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.92),
                                    fontSize: 10,
                                    fontFamily: "Mynor",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
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
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    _CreateTeamButton(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamMemberListScreen()));

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

class _CreateTeamButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateTeamButton({
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Team",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 7),
              Icon(
                Icons.rocket_launch_outlined,
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