import 'package:app_builder/controllers/login_controller.dart';
import 'package:app_builder/user/model/catchment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formState,
          child: GetX<LoginController>(
            init: loginController,
            builder: (controller) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/images/ic_app_icon.png",
                          width: 156,
                          height: 128,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<Catchment>(
                              onTap: () => FocusScope.of(context)
                                  .requestFocus(new FocusNode()),
                              validator: (value) =>
                                  (value == null) ? "Select division" : null,
                              value: controller.selectedDivision,
                              decoration: InputDecoration(
                                labelText: 'Division*',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onChanged: controller.setSelectedDivision,
                              items: List.generate(controller.divisions.length,
                                  (index) {
                                return DropdownMenuItem<Catchment>(
                                  value: controller.divisions[index],
                                  child: Text(controller
                                      .divisions[index].divisionLabel!),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<Catchment>(
                              onTap: () => FocusScope.of(context)
                                  .requestFocus(new FocusNode()),
                              validator: (value) =>
                                  (value == null) ? "Select district" : null,
                              value: controller.selectedDistrict,
                              decoration: InputDecoration(
                                labelText: 'District*',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onChanged: controller.setSelectedDistrict,
                              items: List.generate(controller.districts.length,
                                  (index) {
                                return DropdownMenuItem<Catchment>(
                                  value: controller.districts[index],
                                  child: Text(
                                      controller.districts[index].distLabel!),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<Catchment>(
                              onTap: () => FocusScope.of(context)
                                  .requestFocus(new FocusNode()),
                              validator: (value) =>
                                  (value == null) ? "Select upazila" : null,
                              value: controller.selectedUpazila,
                              decoration: InputDecoration(
                                labelText: 'Upazila*',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onChanged: (value) {
                                controller.selectedUpazila = value;
                              },
                              items: List.generate(controller.upazilas.length,
                                  (index) {
                                return DropdownMenuItem<Catchment>(
                                  value: controller.upazilas[index],
                                  child: Text(
                                      controller.upazilas[index].upazilaLabel!),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              initialValue: controller.userName.value,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Type valid username"
                                      : null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.zero,
                                ),
                                labelText: 'Username*',
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              onChanged: controller.updateUserMobile,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              obscureText:
                                  loginController.passwordVisible.value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              initialValue: loginController.userPassword.value,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Type correct password"
                                      : null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.zero,
                                ),
                                labelText: 'Password*',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    loginController.passwordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xFF07CF93),
                                  ),
                                  onPressed: loginController.togglePassword,
                                ),
                              ),
                              onChanged: loginController.updateUserPassword,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Obx(
                                () {
                                  return MaterialButton(
                                    height: 50,
                                    color: Color(0xFF06CB90),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        controller.communicatingWithServer.value
                                            ? Container(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.yellow),
                                                ),
                                              )
                                            : SizedBox(),
                                        SizedBox(width: 10),
                                        Text(
                                          "Log In",
                                          style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      if (formState.currentState != null &&
                                          formState.currentState!.validate() &&
                                          !controller
                                              .communicatingWithServer.value) {
                                        controller.handleLogin();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
