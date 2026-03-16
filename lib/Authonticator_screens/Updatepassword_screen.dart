import 'package:flutter/material.dart';
import 'package:stemflow/Authonticator_screens/Login_screen.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Widgets/backcircle.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

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

  Future<void> _handleUpdate() async {
    if (_passwordC.text.trim().isEmpty || _confirmC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please fill in all fields',
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

    if (_passwordC.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Password must be at least 6 characters',
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

    if (_passwordC.text.trim() != _confirmC.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Passwords do not match',
            style: TextStyle(fontFamily: "Mynor"),
          ),
          backgroundColor: Colors.red,
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
      // API call yahan add karein
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Password updated successfully!',
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
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => const LoginScreen()),
      //   (route) => false,
      // );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed: ${e.toString()}',
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

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

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
                    "Update Password",
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
                    "Enter your new password to update",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.04),

                  // Password field
                  _roundedField(
                    hint: "New Password...",
                    controller: _passwordC,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
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

                  // Confirm Password field
                  _roundedField(
                    hint: "Confirm Password...",
                    controller: _confirmC,
                    obscureText: _obscureConfirm,
                    suffix: IconButton(
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white.withOpacity(0.75),
                        size: 20,
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.04),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen(),
                        ),(Route<dynamic>route)=>false);
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
                        "Update Password",
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