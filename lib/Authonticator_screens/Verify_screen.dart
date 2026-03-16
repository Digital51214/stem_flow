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
  final List<FocusNode> _otpFocusNodes =
  List.generate(6, (_) => FocusNode());

  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _otpControllers) c.dispose();
    for (var n in _otpFocusNodes) n.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length > 1) {
      _otpControllers[index].text = value.substring(value.length - 1);
    }

    if (value.isNotEmpty) {
      if (index + 1 < _otpFocusNodes.length) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus();
      }
    } else {
      if (index - 1 >= 0) {
        _otpFocusNodes[index - 1].requestFocus();
      }
    }

    _otpControllers[index].selection = TextSelection.fromPosition(
      TextPosition(offset: _otpControllers[index].text.length),
    );

    setState(() {});
  }

  String get _enteredOtp =>
      _otpControllers.map((c) => c.text.trim()).join();

  Future<void> _handleVerify() async {
    if (_enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please enter the 6-digit OTP',
            style: TextStyle(fontFamily: "Mynor"),
          ),
          backgroundColor: const Color(0xFF287D80),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'OTP Verified Successfully!',
            style: TextStyle(fontFamily: "Mynor"),
          ),
          backgroundColor: const Color(0xFF287D80),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Next screen navigation yahan add karein
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      // );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification failed: ${e.toString()}',
            style: const TextStyle(fontFamily: "Mynor"),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Sirf digit ki AnimatedSwitcher animation baqi hai
  Widget _buildOtpBox(int index, double boxSize) {
    final bool hasValue = _otpControllers[index].text.isNotEmpty;

    return SizedBox(
      width: boxSize,
      height: boxSize * 1.25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Real TextField
          TextFormField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            autofocus: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              color: Colors.transparent,
              fontSize: 20,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w800,
            ),
            cursorColor: const Color(0xFF6FE6E4),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.45),
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF6FE6E4),
                  width: 1.8,
                ),
              ),
            ),
            onChanged: (val) => _onOtpChanged(val, index),
          ),

          // Digit AnimatedSwitcher — sirf yahi animation baqi hai
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: hasValue
                ? Text(
              _otpControllers[index].text,
              key: ValueKey<String>(_otpControllers[index].text),
              style: const TextStyle(
                fontSize: 20,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            )
                : SizedBox(
              key: const ValueKey<String>('empty'),
              width: boxSize * 0.01,
              height: boxSize * 0.01,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final double boxSize = mq.width * 0.123;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.height * 0.038),

                  // Back button
                  BackCircle(onTap: () => Navigator.pop(context)),

                  SizedBox(height: mq.height * 0.03),

                  // Logo
                  Center(
                    child: Container(
                      height: 155,
                      width: 160,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/Logo.png"),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.04),

                  // Title
                  const Text(
                    "Enter OTP Code",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  const Text(
                    "Enter code to verify your identity",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),

                  // OTP Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                          (i) => _buildOtpBox(i, boxSize),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.025),

                  // Resend OTP
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Resend logic yahan add karein
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Didn't receive the code? ",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                            const TextSpan(
                              text: "Resend",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF6FE6E4),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF6FE6E4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdatePasswordScreen()));
                      },
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
                        "Verify OTP",
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
}