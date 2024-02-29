import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:email_validator/email_validator.dart';

// ignore: unused_import
import 'package:fluuter_project/components/my_button.dart';
import 'package:fluuter_project/controller/flow_controller.dart';
import 'package:fluuter_project/controller/sign_up_controller.dart';

import '../../login/login.dart';

List<String> list = <String>['Pembaca', 'Penulis'];

class SignUpOne extends StatefulWidget {
  const SignUpOne({super.key});

  @override
  State<SignUpOne> createState() => _SignUpOneState();
}

class _SignUpOneState extends State<SignUpOne> {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  SignUpController signUpController = Get.put(SignUpController());
  FlowController flowController = Get.put(FlowController());

  String dropdownValue = list.first;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    debugPrint(signUpController.userType);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          children: [
            Row(
              children: [
                
                const SizedBox(
                  width: 40,
                ),
                Text(
                  "Crear cuenta",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#4f4f4f"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  // Email Input
                  Text(
                    "Correo",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: emailController.value,
                    onChanged: (value) {
                      validateEmail(value);
                      signUpController.setEmail(value);
                    },
                    onSubmitted: (value) {
                      signUpController.setEmail(value);
                    },
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "hello@gmail.com",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      _errorMessage,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Password Input
                  Text(
                    "Contraseña",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    onChanged: (value) {
                      signUpController.setPassword(value);
                    },
                    onSubmitted: (value) {
                      signUpController.setPassword(value);
                    },
                    obscureText: true,
                    controller: passwordController.value,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "*************",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      focusColor: HexColor("#44564a"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Proceed Button
                  MyButton(
                    buttonText: 'Siguiente',
                    onPressed: () async {
                      if (signUpController.userType != null &&
                          signUpController.email != null &&
                          signUpController.password != null) {
                        bool isRegistered = await signUpController.registerUser(
                          signUpController.email.toString(),
                          signUpController.password.toString(),
                        );
                        debugPrint(isRegistered.toString());
                        if (isRegistered) {
                          Get.snackbar("Success", "Usuario registrado");
                          flowController.setFlow(2);
                        } else {
                          Get.snackbar("Error", "Por favor rellene los campos");
                        }
                      }
                    },
                  ),
                  // Login Navigation
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "ya tienes cuenta?",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                        ),
                        TextButton(
                          child: Text(
                            "Iniciar sesion",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: HexColor("#64af94"),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "El correo no puede estar vacio";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "El correo es invalido";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }
}
