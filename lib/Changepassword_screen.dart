import 'package:flutter/material.dart';
import 'package:stemflow/BottomNavigation_screen.dart';
import 'package:stemflow/HomeScreen.dart';
import 'package:stemflow/Widgets/background.dart';
import 'Widgets/backcircle.dart';

class ChangepasswordScreen extends StatefulWidget {
  const ChangepasswordScreen({super.key});

  @override
  State<ChangepasswordScreen> createState() =>
      _ChangepasswordScreenState();
}

class _ChangepasswordScreenState extends State<ChangepasswordScreen> {
  bool obscure1 = true;
  bool obscure2 = true;
  bool obscure3 = true;

  Widget buildTextField(String hint, bool obscure, VoidCallback toggle) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(color: Colors.white,fontFamily: "Mynor"),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white,fontFamily:"Mynor",fontSize: 10),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mqsize.height * 0.035),

                  /// Top Row
                  Row(
                    children: [
                      BackCircle(
                          onTap: () => Navigator.pop(context)),
                      const Spacer(),
                      Image.asset(
                        "assets/images/Logo.png",
                        height: 45,
                        width: 44,
                      )
                    ],
                  ),

                  SizedBox(height: mqsize.height * 0.03),

                  /// Title
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

                  /// Lock Image
                  Center(
                    child: Image.asset(
                      "assets/images/lock.png",
                      height: 166,
                      width: 135,
                    ),
                  ),

                  SizedBox(height: mqsize.height * 0.04),

                  /// TextFields
                  buildTextField(
                    "Enter Old Password...",
                    obscure1,
                        () => setState(() => obscure1 = !obscure1),
                  ),

                  buildTextField(
                    "Enter New Password...",
                    obscure2,
                        () => setState(() => obscure2 = !obscure2),
                  ),

                  buildTextField(
                    "Confirm New Password...",
                    obscure3,
                        () => setState(() => obscure3 = !obscure3),
                  ),

                  SizedBox(height: mqsize.height * 0.04),

                  /// Update Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>WidgetTree()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF287D80),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
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