import 'package:flutter/material.dart';

class TeamConfigurationScreen extends StatefulWidget {
  const TeamConfigurationScreen({super.key});

  @override
  State<TeamConfigurationScreen> createState() => _TeamConfigurationScreenState();
}

class _TeamConfigurationScreenState extends State<TeamConfigurationScreen> {
  // Sample team data
  List<Map<String, String>> teamMembers = [
    {"name": "Marcus Thorne", "role": "Lead Engineer"},
    {"name": "Sarah Jenkins", "role": "Structural Engineer"},
    {"name": "Marcus Thorne", "role": "Telemetry Specialist"},
  ];

  // Dropdown values for roles
  final List<String> roles = [
    "Lead Engineer",
    "Structural Engineer",
    "Telemetry Specialist",
    "Software Engineer",
    "Project Manager",
  ];

  // Controller for handling role change
  final Map<int, String> roleControllers = {};

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
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
                  const Spacer(),
                  Image.asset(
                    "assets/images/Logo.png",
                    height: 45,
                    width: 45,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                "Team Configuration",
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
                child: ListView.separated(
                  itemCount: teamMembers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final member = teamMembers[index];
                    return _TeamMemberCard(
                      member: member,
                      roles: roles,
                      onRoleChanged: (role) {
                        setState(() {
                          roleControllers[index] = role;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  // Add new member action
                },
                child: Container(
                  height: 56,
                  width: 56,
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
                    size: 30,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9DDFDD).withOpacity(0.75),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                        color: Color(0xFF287D80),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Mynor",
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamMemberCard extends StatelessWidget {
  final Map<String, String> member;
  final List<String> roles;
  final Function(String) onRoleChanged;

  const _TeamMemberCard({
    required this.member,
    required this.roles,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      height: mq.height * 0.15,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.06, vertical: mq.height * 0.015),
      decoration: BoxDecoration(
        color: const Color(0xFF79D4D3).withOpacity(0.55),
        borderRadius: BorderRadius.circular(mq.width * 0.045),
      ),
      child: Row(
        children: [
          Container(
            height: mq.width * 0.12,
            width: mq.width * 0.12,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/member1.png"), // Replace with dynamic member images
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.04,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  member['role']!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: mq.width * 0.032,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          DropdownButton<String>(
            value: member['role'],
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.white),
            underline: Container(
              height: 2,
              color: Colors.white,
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onRoleChanged(newValue);
              }
            },
            items: roles.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}