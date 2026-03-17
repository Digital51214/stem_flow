import 'package:flutter/material.dart';
import 'package:stemflow/Authonticator_screens/Verify_screen.dart';
import 'package:stemflow/Widgets/background.dart';
import '../Widgets/backcircle.dart';

class ForgetpasswordScreen extends StatefulWidget {
  const ForgetpasswordScreen({super.key});

  @override
  State<ForgetpasswordScreen> createState() => _ForgetpasswordScreenState();
}

class _ForgetpasswordScreenState extends State<ForgetpasswordScreen> {

  final TextEditingController emailC = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
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

                  /// Top Row
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

                  /// Lock Image
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
                    "Verify Your Identity",
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Subtitle
                  const Text(
                    "Enter Your mail to vefry your identity",
                    style: TextStyle(
                      fontSize: 10.5,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),

                  /// Email Field
                  _roundedField(
                    hint: "Email Address...",
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: mq.height * 0.03),

                  /// Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(

                      onPressed: _isLoading
                          ? null
                          : () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(),
                          ),
                        );

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
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        "Send Code",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Rounded Field
  Widget _roundedField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
  }) {

    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 1.2,
        ),
        color: Colors.white.withOpacity(0.08),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
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
              fontSize: 12,
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