import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stemflow/Authonticator_screens/Updatepassword_screen.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Widgets/backcircle.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  bool _isLoading = false;

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

  void _onChanged(String val, int index) {

    if (val.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: "Mynor",
          fontWeight: FontWeight.w800,
        ),
        cursorColor: const Color(0xFF6FE6E4),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Color(0xFF287D80).withOpacity(0.3),
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
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: mq.height * 0.035),

                  /// Top Bar
                  Row(
                    children: [

                      BackCircle(onTap: () => Navigator.pop(context)),
                      SizedBox(width: mq.width*0.03,),


                      const Text(
                        "Forget Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: mq.width*0.12,),


                      Image.asset(
                        "assets/images/Logo.png",
                        height: 45,
                        width: 44,
                      )
                    ],
                  ),

                  SizedBox(height: mq.height * 0.09),

                  /// Lock Icon
                  Center(
                    child: Image.asset(
                      "assets/images/lock.png",
                      height: 166,
                      width: 135,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.08),

                  /// Title
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

                  /// Subtitle
                  const Text(
                    "Enter Code to Verify",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),

                  /// OTP Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                          (index) => _otpBox(index),
                    ),
                  ),
                  SizedBox(height: mq.height * 0.03),
                  /// Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdatePasswordScreen(),
                          ),
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF287D80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
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