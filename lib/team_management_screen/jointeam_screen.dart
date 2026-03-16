import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/BigButton.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Widgets/progless_line.dart';
import 'package:stemflow/Widgets/roundedfield.dart';
class JoinTeamScreen extends StatefulWidget {
  const JoinTeamScreen({super.key});

  @override
  State<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
  final TextEditingController codeC = TextEditingController();

  @override
  void dispose() {
    codeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  Row(children: [BackCircle(onTap: () => Navigator.pop(context)),
                    Spacer(),
                    Container(
                      height: 44,
                      width: 45,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/images/Logo.png")),
                      ),
                    )
                  ]),
                  const SizedBox(height: 16),

                  const Text(
                    "Step 1 of 2",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Mynor",

                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: ProgressLine(active: true)),
                      const SizedBox(width: 18),
                      Expanded(child: ProgressLine(active: true)),
                    ],
                  ),

                  SizedBox(height: mq.height * 0.06),

                  // big circle icon
                  Center(
                    child: Center(
                      child: Image.asset(
                        "assets/images/jointeam_image.png", // <-- add your image
                        height: 214,
                        width: 211,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.036),

                  const Text(
                    "Join Team",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Mynor",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Enter Invite Code to join Team!",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Mynor",
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),

                  RoundedField(
                    hint: "Enter Code...",
                    controller: codeC,
                  ),

                  SizedBox(height: mq.height * 0.033),

                  BigButton(
                    text: "Join Team",
                    onTap: () {
                      // TODO: join team API
                    },
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
