import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluuter_project/components/my_button.dart';
import 'package:fluuter_project/controller/flow_controller.dart';
import 'package:fluuter_project/controller/sign_up_controller.dart';

class SignUpTwo extends StatefulWidget {
  const SignUpTwo({super.key});

  @override
  State<SignUpTwo> createState() => _SignUpTwoState();
}

class _SignUpTwoState extends State<SignUpTwo> {
  final mobileNumberController = TextEditingController().obs;
  final nameController = TextEditingController().obs;
  final collegeNameContoller = TextEditingController().obs;
  SignUpController signUpController = Get.put(SignUpController());
  FlowController flowController = Get.put(FlowController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          children: [
            Row(
              children: [
                
                const SizedBox(
                  width: 30,
                ),
                Text(
                  "Registar datos",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#4f4f4f"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Numero celular",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    onChanged: (value) {
                      signUpController.setMobileNumber(value);
                    },
                    onSubmitted: (value) {
                      signUpController.setMobileNumber(value);
                    },
                    controller: mobileNumberController.value,
                    keyboardType: TextInputType.number,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "09XXXXXXXXX",
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
                  Text(
                    "Nombres",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    onChanged: (value) {
                      signUpController.setName(value);
                    },
                    onSubmitted: (value) {
                      signUpController.setName(value);
                    },
                    controller: nameController.value,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "Nombre Apellido",
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
                  
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    onPressed: () {
                      if (signUpController.mobileNumber != null &&
                          signUpController.name != null ) {
                        flowController.setFlow(3);
                      } else {
                        Get.snackbar("Error", "Please fill all the fields");
                      }
                    },
                    buttonText: 'Proceed',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
