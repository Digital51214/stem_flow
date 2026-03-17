import 'package:flutter/material.dart';
import 'package:stemflow/Authonticator_screens/Login_screen.dart';
import 'package:stemflow/Changepassword_screen.dart';
import 'package:stemflow/EditProfile_screen.dart';
import 'Widgets/background.dart';

class Morescreen extends StatefulWidget {
  const Morescreen({super.key});

  @override
  State<Morescreen> createState() => _MorescreenState();
}

class _MorescreenState extends State<Morescreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mq.height * 0.035),

                /// Top Logo
                Image.asset(
                  "assets/images/Logo.png",
                  height: mq.height * 0.055,
                  width: mq.width * 0.12,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: mq.height * 0.02),

                /// Profile Section
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: mq.height * 0.004),
                    Image(image: AssetImage("assets/images/profile.png"),
                    height: mq.height*0.2,
                    width: mq.height*0.2,),

                    Text(
                        "Rehan R",
                        style: TextStyle(
                          fontSize: mq.width * 0.055,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        "Exmple@mail.com",
                        style: TextStyle(
                          fontSize: mq.width * 0.038,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),

                      SizedBox(height: mq.height * 0.018),

                      /// Edit Profile Button
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                        },
                        child: Container(
                          height: mq.height * 0.058,
                          width: mq.width * 0.40,
                          decoration: BoxDecoration(
                            color: const Color(0xff287D80),
                            borderRadius: BorderRadius.circular(mq.width * 0.08),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: mq.width * 0.02,
                                offset: Offset(0, mq.height * 0.004),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                size: mq.width * 0.05,
                                color: Colors.white,
                              ),
                              SizedBox(width: mq.width * 0.025),
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: mq.width * 0.033,
                                  fontFamily: "Mynor",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: mq.height * 0.045),

                /// Change Password Card
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>ChangepasswordScreen()));
                  },
                  child: Container(
                    height: mq.height * 0.073,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(mq.width * 0.04),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                        width: mq.width * 0.003,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: mq.height * 0.048,
                          width: mq.height * 0.048,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff287D80),
                              width: mq.width * 0.0025,
                            ),
                          ),
                          child: Icon(
                            Icons.lock,
                            size: mq.width * 0.045,
                            color: const Color(0xff287D80),
                          ),
                        ),

                        SizedBox(width: mq.width * 0.035),

                        Expanded(
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                              fontSize: mq.width * 0.034,
                              fontFamily: "Mynor",
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Icon(
                          Icons.chevron_right,
                          color: const Color(0xff2A9DA0),
                          size: mq.width * 0.08,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: mq.height * 0.028),

                /// Logout Button
                /// Logout Button
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final mq = MediaQuery.of(context).size;

                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(mq.width * 0.04),
                          ),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                              fontFamily: "Mynor",
                              fontWeight: FontWeight.w700,
                              fontSize: mq.width * 0.045,
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to logout?",
                            style: TextStyle(
                              fontFamily: "Mynor",
                              fontSize: mq.width * 0.035,
                            ),
                          ),
                          actions: [
                            /// Cancel Button
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // dialog close
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Mynor",
                                ),
                              ),
                            ),

                            /// Yes Button
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // dialog close

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(), // <-- apni login screen lagao
                                  ),
                                );
                              },
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  color: const Color(0xffD94C4C),
                                  fontFamily: "Mynor",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: mq.height * 0.06,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(mq.width * 0.08),
                      border: Border.all(
                        color: const Color(0xffD94C4C),
                        width: mq.width * 0.003,
                      ),
                    ),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: mq.width * 0.035,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Mynor",
                        color: const Color(0xffD94C4C),
                      ),
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