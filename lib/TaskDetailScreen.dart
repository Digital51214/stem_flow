import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/BottomNavigation_screen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  String selectedStatus = "In Progress";

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
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.045),
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
                          height: mq.height * 0.052,
                          width: mq.width * 0.11,
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
                      "Project Alpha",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.05,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height * 0.022),

                    _TaskDetailsCard(mq: mq),

                    SizedBox(height: mq.height * 0.018),

                    _UpdateStatusCard(
                      mq: mq,
                      selectedStatus: selectedStatus,
                      onSelect: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),

                    SizedBox(height: mq.height * 0.038),

                    _UpdateStatusButton(
                      mq: mq,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WidgetTree()),
                            (Route<dynamic>route)=>false);
                      },
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

class _TaskDetailsCard extends StatelessWidget {
  final Size mq;

  const _TaskDetailsCard({
    required this.mq,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      height: mq.height * 0.236,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.07,
          vertical: mq.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: const Color(0xFF287D80),
                  size: mq.width * 0.06,
                ),
                SizedBox(width: mq.width * 0.03),
                Text(
                  "Task Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.042,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),

            SizedBox(height: mq.height * 0.01),

            Divider(
              color: Colors.white.withOpacity(0.95),
              thickness: 1,
              height: 1,
            ),

            SizedBox(height: mq.height * 0.012),

            Padding(
              padding: EdgeInsets.only(left: mq.width * 0.08),
              child: Text(
                "PHASE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.03,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            SizedBox(height: mq.height * 0.006),

            Row(
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  color: const Color(0xFF287D80),
                  size: mq.width * 0.058,
                ),
                SizedBox(width: mq.width * 0.03),
                Expanded(
                  child: Text(
                    "Wind Tunnel Testing",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF287D80),
                      fontSize: mq.width * 0.038,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SmallInfoColumn(
                  mq: mq,
                  title: "PRIORITY",
                  value: "High",
                  valueColor: Colors.red,
                ),
                _SmallInfoColumn(
                  mq: mq,
                  title: "ASSIGNED TO",
                  value: "Max Verstappen",
                  valueColor: const Color(0xFF287D80),
                ),
                _SmallInfoColumn(
                  mq: mq,
                  title: "DUE DATE",
                  value: "May 24,2026",
                  valueColor: const Color(0xFF287D80),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallInfoColumn extends StatelessWidget {
  final Size mq;
  final String title;
  final String value;
  final Color valueColor;

  const _SmallInfoColumn({
    required this.mq,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width * 0.24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.026,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: mq.height * 0.008),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: mq.width * 0.021,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateStatusCard extends StatelessWidget {
  final Size mq;
  final String selectedStatus;
  final ValueChanged<String> onSelect;

  const _UpdateStatusCard({
    required this.mq,
    required this.selectedStatus,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      height: mq.height*0.37,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.07,
          vertical: mq.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Status",
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.052,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
              ),
            ),

            SizedBox(height: mq.height * 0.014),

            Divider(
              color: Colors.white.withOpacity(0.95),
              thickness: 1,
              height: 1,
            ),

            SizedBox(height: mq.height * 0.03),

            Text(
              "CURRENT STATUS",
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.032,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),

            SizedBox(height: mq.height * 0.022),

            _StatusTile(
              mq: mq,
              title: "To Do",
              icon: Icons.circle_outlined,
              isSelected: selectedStatus == "To Do",
              onTap: () => onSelect("To Do"),
            ),

            SizedBox(height: mq.height * 0.012),

            _StatusTile(
              mq: mq,
              title: "In Progress",
              icon: Icons.bolt_rounded,
              isSelected: selectedStatus == "In Progress",
              onTap: () => onSelect("In Progress"),
            ),

            SizedBox(height: mq.height * 0.012),

            _StatusTile(
              mq: mq,
              title: "Completed",
              icon: Icons.circle_outlined,
              isSelected: selectedStatus == "Completed",
              onTap: () => onSelect("Completed"),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final Size mq;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusTile({
    required this.mq,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF287D80);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(mq.width * 0.08),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: Container(
            height: mq.height * 0.052,
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.055),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.23),
              borderRadius: BorderRadius.circular(mq.width * 0.08),
              border: Border.all(
                color: teal,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: mq.width * 0.055,
                  width: mq.width * 0.055,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? teal.withOpacity(0.92)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? teal
                          : Colors.blueGrey.withOpacity(0.55),
                      width: 1.4,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: mq.width * 0.034,
                  )
                      : null,
                ),

                SizedBox(width: mq.width * 0.04),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? teal : Colors.white,
                      fontSize: mq.width * 0.038,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateStatusButton extends StatelessWidget {
  final Size mq;
  final VoidCallback onTap;

  const _UpdateStatusButton({
    required this.mq,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.056,
      decoration: BoxDecoration(
        color: const Color(0xFF287D80),
        borderRadius: BorderRadius.circular(mq.width * 0.09),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(mq.width * 0.09),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sync_rounded,
              color: Colors.white,
              size: mq.width * 0.042,
            ),
            SizedBox(width: mq.width * 0.02),
            Text(
              "Update Status",
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.038,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
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
      borderRadius: BorderRadius.circular(mq.width * 0.055),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.5),
            borderRadius: BorderRadius.circular(mq.width * 0.055),
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