import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stemflow/Authonticator_screens/Login_screen.dart';
import 'package:stemflow/Privacy%20policy%20_screen.dart';
import 'package:stemflow/Terms%20and%20condition%20_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController userC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController confirmC = TextEditingController();

  bool agree = true;
  bool obscure1 = true;
  bool obscure2 = true;

  @override
  void dispose() {
    userC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/BG 2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.height * 0.06),

                  // Logo Circle
                  Center(
                    child: Container(
                      height: 155,
                      width: 160,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage("assets/images/Logo.png"))
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height * 0.04),

                  // Title
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  const Text(
                    "Enter Your Details to SignUp",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.025),

                  // Username
                  _roundedField(
                    hint: "Username...",
                    controller: userC,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 5),

                  // Email
                  _roundedField(
                    hint: "Email Address...",
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 5),

                  // Password
                  _roundedField(
                    hint: "Password....",
                    controller: passC,
                    obscureText: obscure1,
                    suffix: IconButton(
                      onPressed: () => setState(() => obscure1 = !obscure1),
                      icon: Icon(
                        obscure1 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white.withOpacity(0.75),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Confirm Password
                  _roundedField(
                    hint: "Confirm Password...",
                    controller: confirmC,
                    obscureText: obscure2,
                    suffix: IconButton(
                      onPressed: () => setState(() => obscure2 = !obscure2),
                      icon: Icon(
                        obscure2 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white.withOpacity(0.75),
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Agree line
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => agree = !agree),
                        child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: agree
                                ? const Color(0xFF1A7A79)
                                : Colors.transparent,
                            border: Border.all(
                              color: agree
                                  ? const Color(0xFF287D80)
                                  : Colors.black.withOpacity(0.35),
                              width: 1.5,
                            ),
                          ),
                          child: agree
                              ? const Icon(Icons.check,
                              color: Colors.white, size: 13)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 11.5,
                              fontFamily: "Mynor",
                              fontWeight: FontWeight.w600,

                            ),
                            children: [
                              const TextSpan(text: "I agree with all "),
                              TextSpan(
                                text: "Terms & Conditions",
                                style: const TextStyle(
                                  color: Color(0xFF1A7A79),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w800,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsandconditionScreen()));

                                  },
                              ),
                              const TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: const TextStyle(
                                  color: Color(0xFF1A7A79),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w800,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacypolicyScreen()));
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: mq.height * 0.028),

                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()),
                                (Route<dynamic>route)=>false);                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF287D80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.065),

                  // Bottom text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.5,
                              fontFamily: "Mynor",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()),
                                    (Route<dynamic>route)=>false);
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Color(0xFF1A7A79),
                                  fontSize: 14.5,
                                  fontFamily: "Mynor",
                                  fontWeight: FontWeight.w900,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
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
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.55), width: 1.2),
        color: Colors.white.withOpacity(0.08),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white, fontSize: 14,
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