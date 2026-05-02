import 'package:flutter/material.dart';
import 'package:stemflow/BottomNavigation_screen.dart';
import 'package:stemflow/Widgets/background.dart';

import '../Services/change_password_service.dart';
import '../Widgets/backcircle.dart';



class ChangepasswordScreenTeam extends StatefulWidget {
  const ChangepasswordScreenTeam({super.key});

  @override
  State<ChangepasswordScreenTeam> createState() => _ChangepasswordScreenTeamState();
}

class _ChangepasswordScreenTeamState extends State<ChangepasswordScreenTeam> {
  bool obscure1 = true;
  bool obscure2 = true;
  bool obscure3 = true;
  bool isLoading = false;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final ChangePasswordService _changePasswordService = ChangePasswordService();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Mynor",
          ),
        ),
        backgroundColor: const Color(0xFF287D80), // same as button
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      showMsg("Please enter old password");
      return;
    }

    if (newPassword.isEmpty) {
      showMsg("Please enter new password");
      return;
    }

    if (confirmPassword.isEmpty) {
      showMsg("Please confirm new password");
      return;
    }

    if (newPassword != confirmPassword) {
      showMsg("New password and confirm password do not match");
      return;
    }

    setState(() => isLoading = true);

    print("Button Pressed: Change Password");

    final result = await _changePasswordService.changePassword(
      userId: 6,
      currentPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    setState(() => isLoading = false);

    print("Final Result: $result");

    if (result["success"] == true) {
      showMsg(result["message"]);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WidgetTree()),
      );
    } else {
      showMsg(result["message"]);
    }
  }

  Widget buildTextField(
      String hint,
      bool obscure,
      VoidCallback toggle,
      TextEditingController controller,
      ) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontFamily: "Mynor"),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontFamily: "Mynor",
            fontSize: 10,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
              size: 22,
            ),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mqsize = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mqsize.height * 0.035),

                  Row(
                    children: [
                      BackCircle(onTap: () => Navigator.pop(context)),
                      const Spacer(),
                      Image.asset(
                        "assets/images/Logo.png",
                        height: 45,
                        width: 44,
                      ),
                    ],
                  ),

                  SizedBox(height: mqsize.height * 0.03),

                  const Text(
                    "Change Password",
                    style: TextStyle(
                      fontFamily: "Mynor",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: mqsize.height * 0.05),

                  Center(
                    child: Image.asset(
                      "assets/images/lock.png",
                      height: 166,
                      width: 135,
                    ),
                  ),

                  SizedBox(height: mqsize.height * 0.04),

                  buildTextField(
                    "Enter Old Password...",
                    obscure1,
                        () => setState(() => obscure1 = !obscure1),
                    oldPasswordController,
                  ),

                  buildTextField(
                    "Enter New Password...",
                    obscure2,
                        () => setState(() => obscure2 = !obscure2),
                    newPasswordController,
                  ),

                  buildTextField(
                    "Confirm New Password...",
                    obscure3,
                        () => setState(() => obscure3 = !obscure3),
                    confirmPasswordController,
                  ),

                  SizedBox(height: mqsize.height * 0.04),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF287D80),
                        disabledBackgroundColor:
                        const Color(0xFF287D80).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "Update",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Mynor",
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: mqsize.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}