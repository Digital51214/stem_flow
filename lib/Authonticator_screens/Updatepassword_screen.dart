import 'package:flutter/material.dart';
import 'package:stemflow/Authonticator_screens/Login_screen.dart';

import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Widgets/backcircle.dart';

import '../Services/forget_password_service.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  final int userId;

  const UpdatePasswordScreen({
    super.key,
    required this.email,
    required this.otp,
    required this.userId,
  });

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _passwordC = TextEditingController();
  final TextEditingController _confirmC = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: "Mynor"),
        ),
        backgroundColor: error ? Colors.red : const Color(0xFF287D80),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _handleUpdate() async {
    final password = _passwordC.text.trim();
    final confirmPassword = _confirmC.text.trim();

    print("Change password button clicked");
    print("Email: ${widget.email}");
    print("OTP: ${widget.otp}");
    print("User ID: ${widget.userId}");

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showSnack("Please fill in all fields", error: true);
      return;
    }

    if (password.length < 8) {
      _showSnack("Password must be at least 8 characters", error: true);
      return;
    }

    if (password != confirmPassword) {
      _showSnack("Passwords do not match", error: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ForgetPasswordService.resetPassword(
        email: widget.email,
        otp: widget.otp,
        newPassword: password,
        confirmPassword: confirmPassword,
        userId: widget.userId,
      );

      print("Reset password result: $result");

      if (!mounted) return;

      _showSnack(
        result["message"] ?? "Password has been changed successfully!",
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Reset password error: $e");

      if (!mounted) return;

      _showSnack(
        e.toString().replaceAll("Exception: ", ""),
        error: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.height * 0.035),

                  Row(
                    children: [
                      BackCircle(onTap: () => Navigator.pop(context)),
                      SizedBox(width: mq.width * 0.03),
                      const Text(
                        "Update Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: mq.width * 0.1),
                      Image.asset(
                        "assets/images/Logo.png",
                        height: 45,
                        width: 44,
                      ),
                    ],
                  ),

                  SizedBox(height: mq.height * 0.09),

                  Center(
                    child: Image.asset(
                      "assets/images/lock.png",
                      height: 166,
                      width: 135,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.101),

                  _roundedField(
                    hint: "Enter New Password...",
                    controller: _passwordC,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      onPressed: _isLoading
                          ? null
                          : () => setState(
                            () => _obscurePassword = !_obscurePassword,
                      ),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white.withOpacity(0.75),
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _roundedField(
                    hint: "Confirm New Password...",
                    controller: _confirmC,
                    obscureText: _obscureConfirm,
                    suffix: IconButton(
                      onPressed: _isLoading
                          ? null
                          : () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                      ),
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white.withOpacity(0.75),
                        size: 20,
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.042),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF287D80),
                        disabledBackgroundColor:
                        const Color(0xFF287D80).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : const Text(
                        "Change",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundedField({
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.55),
          width: 1.2,
        ),
        color: Colors.white.withOpacity(0.08),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: TextField(
          controller: controller,
          enabled: !_isLoading,
          obscureText: obscureText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Mynor",
          ),
          cursorColor: const Color(0xFF6FE6E4),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 10,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: suffix,
          ),
        ),
      ),
    );
  }
}