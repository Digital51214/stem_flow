import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stemflow/Authonticator_screens/Updatepassword_screen.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Widgets/backcircle.dart';

import '../Services/forget_password_service.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String otp;
  final int userId;

  const OtpScreen({
    super.key,
    required this.email,
    required this.otp,
    required this.userId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  String? _currentOtp;

  @override
  void initState() {
    super.initState();

    _currentOtp = widget.otp;

    print("OTP Screen Opened");
    print("Email: ${widget.email}");
    print("OTP: ${widget.otp}");
    print("User ID: ${widget.userId}");
  }

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }

    for (var f in _focusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  String get _enteredOtp {
    return _otpControllers.map((c) => c.text.trim()).join();
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
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

  void _onChanged(String val, int index) {
    if (val.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOtp();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (_isLoading) return;

    final code = _enteredOtp;

    print("Verify OTP clicked");
    print("Entered OTP: $code");
    print("Current OTP: $_currentOtp");

    if (code.length != 6) {
      _showSnack("Please enter complete OTP", error: true);
      return;
    }

    if (_currentOtp == null) {
      _showSnack("OTP expired. Please resend code", error: true);
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    if (code == _currentOtp) {
      print("OTP verified successfully");

      _currentOtp = null;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UpdatePasswordScreen(
            email: widget.email,
            otp: code,
            userId: widget.userId,
          ),
        ),
      );
    } else {
      print("Invalid OTP");
      _showSnack("Invalid OTP", error: true);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    if (_isLoading) return;

    print("Resend OTP clicked");

    setState(() => _isLoading = true);

    try {
      final result = await ForgetPasswordService.forgotPassword(
        email: widget.email,
      );

      print("Resend OTP result: $result");

      _currentOtp = result["otp"].toString();

      for (var c in _otpControllers) {
        c.clear();
      }

      if (!mounted) return;

      _focusNodes.first.requestFocus();

      _showSnack("OTP resent successfully");

      print("New OTP: $_currentOtp");
    } catch (e) {
      print("Resend OTP error: $e");

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

  Widget _otpBox(int index) {
    return SizedBox(
      width: 45,
      height: 48,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        enabled: !_isLoading,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: "Mynor",
          fontWeight: FontWeight.w800,
        ),
        cursorColor: const Color(0xFF6FE6E4),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color(0xFF287D80).withOpacity(0.3),
          contentPadding: const EdgeInsets.only(bottom: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (v) => _onChanged(v, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.height * 0.035),

                  Row(
                    children: [
                      BackCircle(onTap: () => Navigator.pop(context)),
                      SizedBox(width: mq.width * 0.03),
                      const Text(
                        "Forget Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: mq.width * 0.12),
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

                  SizedBox(height: mq.height * 0.08),

                  const Text(
                    "Enter Code",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Enter Code sent to ${widget.email}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                          (index) => _otpBox(index),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
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
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        "Verify",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.025),

                  Center(
                    child: TextButton(
                      onPressed: _isLoading ? null : _resendOtp,
                      child: const Text(
                        "Resend Code",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6FE6E4),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF6FE6E4),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}