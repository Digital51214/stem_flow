import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/BottomNavigation_screen.dart';
import 'package:stemflow/EventsScreen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

import '../Services/add_event_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController =
  TextEditingController(text: "03:45 PM");

  bool isLoading = false;

  final int teamId = 1;

  @override
  void dispose() {
    eventTitleController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
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

  String convertDateToApiFormat(String date) {
    final parts = date.split('/');

    if (parts.length != 3) {
      return date;
    }

    final month = parts[0];
    final day = parts[1];
    final year = parts[2];

    return "$year-$month-$day";
  }

  Future<void> saveEvent() async {
    final title = eventTitleController.text.trim();
    final date = dateController.text.trim();
    final time = timeController.text.trim();

    if (title.isEmpty) {
      showToast("Please enter event title");
      return;
    }

    if (date.isEmpty) {
      showToast("Please select date");
      return;
    }

    if (time.isEmpty) {
      showToast("Please select time");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print("Save Event Button Pressed");
      print("Title: $title");
      print("Date Before Convert: $date");
      print("Time: $time");

      final apiDate = convertDateToApiFormat(date);

      print("Date For API: $apiDate");

      final result = await AddEventService.addEvent(
        teamId: teamId,
        title: title,
        date: apiDate,
        time: time,
      );

      print("Event Added Successfully: $result");

      showToast(result["message"] ?? "Event synchronized successfully");

      eventTitleController.clear();
      dateController.clear();
      timeController.text = "03:45 PM";

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WidgetTree()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("Save Event Error: $e");
      showToast("Failed to add event");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
                      "Add Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.05,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: mq.height * 0.018),
                    _EventImageCard(mq: mq),
                    SizedBox(height: mq.height * 0.015),
                    _GlassFormCard(
                      mq: mq,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * 0.06,
                          vertical: mq.height * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(mq: mq, title: "EVENT TITLE"),
                            SizedBox(height: mq.height * 0.014),
                            _EventTextField(
                              mq: mq,
                              controller: eventTitleController,
                              hintText: "e.g. Aerodynamics Review",
                              suffixIcon: Icons.edit_rounded,
                            ),
                            SizedBox(height: mq.height * 0.03),
                            _FieldLabel(mq: mq, title: "DATE"),
                            SizedBox(height: mq.height * 0.014),
                            _EventTextField(
                              mq: mq,
                              controller: dateController,
                              hintText: "mm/dd/yyyy",
                              readOnly: true,
                              suffixIcon: Icons.calendar_month_outlined,
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2035),
                                  initialDate: DateTime.now(),
                                );

                                if (pickedDate != null) {
                                  dateController.text =
                                  "${pickedDate.month.toString().padLeft(2, '0')}/"
                                      "${pickedDate.day.toString().padLeft(2, '0')}/"
                                      "${pickedDate.year}";
                                }
                              },
                            ),
                            SizedBox(height: mq.height * 0.03),
                            _FieldLabel(mq: mq, title: "TIME"),
                            SizedBox(height: mq.height * 0.014),
                            _EventTextField(
                              mq: mq,
                              controller: timeController,
                              hintText: "03:45 PM",
                              readOnly: true,
                              suffixIcon: Icons.access_time_rounded,
                              onTap: () async {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: const TimeOfDay(
                                    hour: 15,
                                    minute: 45,
                                  ),
                                );

                                if (pickedTime != null && context.mounted) {
                                  timeController.text =
                                      pickedTime.format(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: mq.height * 0.04),
                    _SaveEventButton(
                      mq: mq,
                      isLoading: isLoading,
                      onTap: isLoading ? null : saveEvent,
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

class _EventImageCard extends StatelessWidget {
  final Size mq;

  const _EventImageCard({
    required this.mq,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.width * 0.045),
      child: Container(
        height: mq.height * 0.16,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(mq.width * 0.045),
          image: const DecorationImage(
            image: AssetImage("assets/images/image5.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.38),
            borderRadius: BorderRadius.circular(mq.width * 0.045),
          ),
          padding: EdgeInsets.only(
            left: mq.width * 0.065,
            bottom: mq.height * 0.03,
          ),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Event Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.04,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: mq.height * 0.004),
              Text(
                "Project Hub",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.032,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final Size mq;
  final String title;

  const _FieldLabel({
    required this.mq,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: mq.width * 0.028,
        fontFamily: "Mynor",
        fontWeight: FontWeight.w900,
        letterSpacing: mq.width * 0.003,
      ),
    );
  }
}

class _EventTextField extends StatelessWidget {
  final Size mq;
  final TextEditingController controller;
  final String hintText;
  final IconData? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const _EventTextField({
    required this.mq,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height * 0.058,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontSize: mq.width * 0.03,
          fontFamily: "Mynor",
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: mq.width * 0.03,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: suffixIcon == null
              ? null
              : Icon(
            suffixIcon,
            color: Colors.white,
            size: mq.width * 0.047,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.05,
            vertical: mq.height * 0.014,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.65),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.9),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveEventButton extends StatelessWidget {
  final Size mq;
  final VoidCallback? onTap;
  final bool isLoading;

  const _SaveEventButton({
    required this.mq,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.058,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF287D80),
        borderRadius: BorderRadius.circular(mq.width * 0.09),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF287D80).withOpacity(0.32),
            blurRadius: mq.width * 0.012,
            offset: Offset(0, mq.height * 0.003),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(mq.width * 0.09),
        onTap: onTap,
        child: Center(
          child: isLoading
              ? SizedBox(
            height: mq.width * 0.05,
            width: mq.width * 0.05,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.save_outlined,
                color: Colors.white,
                size: mq.width * 0.04,
              ),
              SizedBox(width: mq.width * 0.018),
              Text(
                "Save Event",
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
      ),
    );
  }
}

class _GlassFormCard extends StatelessWidget {
  final Size mq;
  final Widget child;

  const _GlassFormCard({
    required this.mq,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.width * 0.055),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          height: mq.height * 0.419,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.48),
            borderRadius: BorderRadius.circular(mq.width * 0.055),
            border: Border.all(
              color: Colors.white.withOpacity(0.14),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}