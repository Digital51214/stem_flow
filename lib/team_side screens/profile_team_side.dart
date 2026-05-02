import 'package:flutter/material.dart';
import 'package:stemflow/Authonticator_screens/Login_screen.dart';
import 'package:stemflow/Changepassword_screen.dart';
import 'package:stemflow/EditProfile_screen.dart';
import 'package:stemflow/services/session_manager.dart';
import 'package:stemflow/team_side%20screens/change_password_teamside.dart';
import 'package:stemflow/team_side%20screens/edit_profile_team.dart';

import '../Widgets/background.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String userEmail = "";
  String profilePic = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      print("=== LOAD USER DATA START ===");

      final userData = await SessionManager.instance.getUserData();
      final username = await SessionManager.instance.getUsername();
      final fullName = await SessionManager.instance.getFullName();
      final email = await SessionManager.instance.getEmail();
      final pic = await SessionManager.instance.getProfilePic();

      print("UserData map from session: $userData");
      print("Username from session: $username");
      print("Full Name from session: $fullName");
      print("Email from session: $email");
      print("Profile Pic from session: $pic");

      final finalName = fullName.isNotEmpty
          ? fullName
          : (username.isNotEmpty ? username : "User");

      final finalEmail = email.isNotEmpty
          ? email
          : ((userData?["email"]?.toString() ?? "").isNotEmpty
          ? userData!["email"].toString()
          : "No Email");

      final finalProfilePic = pic.isNotEmpty
          ? pic
          : (userData?["profile_pic"]?.toString() ?? "");

      setState(() {
        userName = finalName;
        userEmail = finalEmail;
        profilePic = finalProfilePic == "null" ? "" : finalProfilePic;
        isLoading = false;
      });

      print("=== LOAD USER DATA SUCCESS ===");
      print("Final Name: $userName");
      print("Final Email: $userEmail");
      print("Final Profile Pic: $profilePic");
    } catch (e) {
      print("=== LOAD USER DATA ERROR ===");
      print("Error: $e");

      setState(() {
        userName = "User";
        userEmail = "No Email";
        profilePic = "";
        isLoading = false;
      });
    }
  }

  Future<void> logoutUser() async {
    try {
      print("=== LOGOUT START ===");
      await SessionManager.instance.clearSession();
      print("=== LOGOUT SUCCESS ===");

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      print("=== LOGOUT ERROR ===");
      print("Error: $e");
    }
  }

  Widget _buildProfileImage(Size mq) {
    if (profilePic.isNotEmpty && profilePic.startsWith("http")) {
      return ClipOval(
        child: Image.network(
          profilePic,
          height: mq.height * 0.2,
          width: mq.height * 0.2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("=== PROFILE IMAGE LOAD ERROR ===");
            print(error.toString());

            return Image.asset(
              "assets/images/profile.png",
              height: mq.height * 0.2,
              width: mq.height * 0.2,
              fit: BoxFit.cover,
            );
          },
        ),
      );
    }

    return Image.asset(
      "assets/images/profile.png",
      height: mq.height * 0.2,
      width: mq.height * 0.2,
      fit: BoxFit.cover,
    );
  }

  void showLogoutDialog() {
    final mq = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: mq.width * 0.08),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.06,
              vertical: mq.height * 0.028,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF103E46).withOpacity(0.96),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.14),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: mq.width * 0.15,
                  width: mq.width * 0.15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xffD94C4C).withOpacity(0.16),
                    border: Border.all(
                      color: const Color(0xffD94C4C).withOpacity(0.45),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: const Color(0xffD94C4C),
                    size: mq.width * 0.075,
                  ),
                ),
                SizedBox(height: mq.height * 0.02),
                Text(
                  "Logout",
                  style: TextStyle(
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w800,
                    fontSize: mq.width * 0.05,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: mq.height * 0.01),
                Text(
                  "Are you sure you want to logout from your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Mynor",
                    fontSize: mq.width * 0.034,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.82),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: mq.height * 0.028),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: mq.height * 0.056,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.14),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Mynor",
                              fontWeight: FontWeight.w700,
                              fontSize: mq.width * 0.035,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: mq.width * 0.03),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          logoutUser();
                        },
                        child: Container(
                          height: mq.height * 0.056,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xffD94C4C),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xffD94C4C).withOpacity(0.28),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            "Yes, Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Mynor",
                              fontWeight: FontWeight.w700,
                              fontSize: mq.width * 0.035,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xff287D80),
            ),
          )
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mq.height * 0.03),
                Image.asset(
                  "assets/images/Logo.png",
                  height: mq.height * 0.055,
                  width: mq.width * 0.12,
                  fit: BoxFit.contain,
                ),

                Center(
                  child: Column(
                    children: [

                      _buildProfileImage(mq),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: mq.width * 0.055,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: mq.width * 0.038,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                      SizedBox(height: mq.height * 0.018),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const EditProfileScreenTeamSide(),
                            ),
                          );
                          await loadUserData();
                        },
                        child: Container(
                          height: mq.height * 0.058,
                          width: mq.width * 0.40,
                          decoration: BoxDecoration(
                            color: const Color(0xff287D80),
                            borderRadius:
                            BorderRadius.circular(mq.width * 0.08),
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
                SizedBox(height: mq.height * 0.03),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const ChangepasswordScreenTeam(),
                      ),
                    );
                  },
                  child: Container(
                    height: mq.height * 0.073,
                    width: double.infinity,
                    padding:
                    EdgeInsets.symmetric(horizontal: mq.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius:
                      BorderRadius.circular(mq.width * 0.04),
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
                SizedBox(height: mq.height * 0.01),


                SizedBox(height: mq.height * 0.028),
                GestureDetector(
                  onTap: showLogoutDialog,
                  child: Container(
                    height: mq.height * 0.06,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                      BorderRadius.circular(mq.width * 0.08),
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
class _MoreTile extends StatelessWidget {
  final Size mq;
  final IconData? icon;
  final String? imagePath;
  final String title;

  const _MoreTile({
    required this.mq,
    this.icon,
    this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Center(
              child: icon != null
                  ? Icon(
                icon,
                size: mq.width * 0.045,
                color: const Color(0xff287D80),
              )
                  : imagePath != null
                  ? ClipOval(
                child: Image.asset(
                  imagePath!,
                  fit: BoxFit.cover,
                  width: mq.height * 0.048,
                  height: mq.height * 0.048,
                ),
              )
                  : const SizedBox(), // fallback if both null
            ),
          ),

          SizedBox(width: mq.width * 0.035),

          Expanded(
            child: Text(
              title,
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
    );
  }
}