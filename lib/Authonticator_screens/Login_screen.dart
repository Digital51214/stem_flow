import 'package:flutter/material.dart';
import 'package:stemflow/Authonticator_screens/ForgetPAssword_screen.dart';
import 'package:stemflow/Authonticator_screens/SignUP_screen.dart';
import 'package:stemflow/services/login_service.dart';
import 'package:stemflow/services/session_manager.dart';
import 'package:stemflow/team_management_screen/teamstep1_screen.dart';
import 'package:stemflow/widgets/custom_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  bool rememberMe = false;
  bool obscure = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final email = emailC.text.trim();
    final password = passC.text.trim();

    print("=== LOGIN BUTTON CLICKED ===");
    print("Email: $email");
    print("Password: $password");
    print("Remember Me: $rememberMe");

    if (email.isEmpty) {
      CustomToast.show(
        context: context,
        message: "Please enter email",
        type: ToastType.error,
      );
      return;
    }

    if (!email.contains("@")) {
      CustomToast.show(
        context: context,
        message: "Please enter valid email",
        type: ToastType.error,
      );
      return;
    }

    if (password.isEmpty) {
      CustomToast.show(
        context: context,
        message: "Please enter password",
        type: ToastType.error,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await LoginService.login(
      email: email,
      password: password,
    );

    print("=== FINAL LOGIN RESULT ===");
    print(result.toString());

    if (result["success"] == true) {
      final dynamic userDynamic = result["user"];

      print("=== RAW USER FROM LOGIN RESPONSE ===");
      print(userDynamic);
      print("User runtimeType: ${userDynamic.runtimeType}");

      if (userDynamic != null && userDynamic is Map) {
        final Map<String, dynamic> user =
        Map<String, dynamic>.from(userDynamic);

        print("=== USER MAP TO SAVE ===");
        print(user);

        await SessionManager.instance.saveUserSession(user);

        final savedEmail = await SessionManager.instance.getEmail();
        final savedUsername = await SessionManager.instance.getUsername();
        final savedProfilePic = await SessionManager.instance.getProfilePic();

        print("=== SESSION VERIFY AFTER SAVE ===");
        print("Saved Email Verify: $savedEmail");
        print("Saved Username Verify: $savedUsername");
        print("Saved Profile Pic Verify: $savedProfilePic");
      } else {
        print("=== USER DATA NOT SAVED ===");
        print("Reason: user is null or not a Map");
      }

      setState(() {
        isLoading = false;
      });

      CustomToast.show(
        context: context,
        message: result["message"] ?? "Login successful",
        type: ToastType.success,
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TeamStep1Screen()),
        );
      });
    } else {
      setState(() {
        isLoading = false;
      });

      CustomToast.show(
        context: context,
        message: result["message"] ?? "Login failed",
        type: ToastType.error,
      );
    }
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
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Welcome Back! Enter Your Account Details",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: mq.height * 0.025),
                  _roundedField(
                    hint: "Email Address...",
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 5),
                  _roundedField(
                    hint: "Password....",
                    controller: passC,
                    obscureText: obscure,
                    suffix: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white.withOpacity(0.75),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => rememberMe = !rememberMe),
                        child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.75),
                              width: 1.5,
                            ),
                          ),
                          child: rememberMe
                              ? Center(
                            child: Container(
                              height: 9,
                              width: 9,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF6FE6E4),
                              ),
                            ),
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Remember Me",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12.5,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetpasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forget Password?",
                          style: TextStyle(
                            color: Color(0xFF287D80),
                            fontSize: 12.5,
                            fontFamily: "Mynor",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mq.height * 0.045),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF287D80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height * 0.165),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Don’t have an account? ",
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
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Color(0xFF287D80),
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
              color: Colors.white70,
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