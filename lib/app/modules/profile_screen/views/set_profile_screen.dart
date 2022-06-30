import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/request/profile_create_request_model.dart';
import 'package:plug/app/modules/home/views/home_view.dart';
import 'package:plug/app/modules/profile_screen/controllers/set_profile.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/utils/validation_mixin.dart';

class SetProfileScreenView extends GetView<SetProfileScreenController> {
  final String contact;
  final String deviceToken;

  SetProfileScreenView({required this.contact, required this.deviceToken});

  TextEditingController _nameController = TextEditingController();

  TextEditingController _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SetProfileScreenController());

  //APICALLS apicalls = APICALLS();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.back();
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF263238),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Center(child: SvgPicture.asset("resources/svg/pluhg_logo2.svg")),
              SizedBox(
                height: 99,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Set Your Profile",
                  style: TextStyle(
                      color: pluhgColour,
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width - 24,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _nameController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Fill field";
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Set your User Name (unique)",
                            labelStyle: TextStyle(
                                color: Color(0xff707070),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Muli",
                                fontStyle: FontStyle.normal,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02),
                          ),
                        ),
                      ),
                      PhoneValidator.validate(contact)
                          ? Container(
                              width: Get.width,
                              child: TextFormField(
                                validator: (value) {
                                  String error = _validateEmail(value);
                                  if (error.isNotEmpty) {
                                    return error;
                                  }
                                },
                                controller: _contactController,
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  labelText: "Set your email",
                                  prefixIcon: Icon(Icons.email_outlined),
                                  labelStyle: TextStyle(
                                      color: Color(0xff707070),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Muli",
                                      fontStyle: FontStyle.normal,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ),
                              ))
                          : Container(
                              width: Get.width,
                              child: Row(children: [
                                Container(
                                  width: 60,
                                  child: CountryCodePicker(
                                    boxDecoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xff707070))),
                                    onInit: (val) async {
                                      await controller.updateCountryCode(val);
                                    },
                                    onChanged: (val) async {
                                      await controller.updateCountryCode(val);
                                    },
                                    initialSelection:
                                        controller.isoCountryCode.value,
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.white,
                                    showFlag: false,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: controller.size.width - 60 - 10 - 24,
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      readOnly: controller.isLoading.value,
                                      validator: (value) {
                                        String error = _validatePhone(value);
                                        if (error.isNotEmpty) {
                                          return error;
                                        }
                                      },
                                      controller: _contactController,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFF080F18)),
                                        ),
                                        // border: UnderlineInputBorder(
                                        //   borderSide:
                                        //       BorderSide(color: Color(0xFF080F18)),
                                        // ),
                                        focusColor: Color(0xFF080F18),
                                        labelText: ' Enter Phone Number',
                                        labelStyle: TextStyle(
                                            color: Color(0xff707070),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Muli",
                                            fontStyle: FontStyle.normal,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02),
                                      )),
                                ),
                              ]),
                            )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 76,
              ),
              controller.isLoading.value
                  ? Center(child: pluhgProgress())
                  : GestureDetector(
                      onTap: _submit,
                      child: Center(
                        child: Container(
                          width: 261,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(59),
                              color: pluhgColour),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        )));
  }

  String _validatePhone(String? contact) {
    if (contact == null || !contact.isNotEmpty) {
      return "Please add phone number";
    }

    String phone = _preparePhoneNumber(contact);
    return !contact.isNum && !PhoneValidator.validate(phone)
        ? "Please provide valid phone number"
        : '';
  }

  String _validateEmail(String? contact) {
    if (contact == null || !contact.isNotEmpty) {
      return "Please add email";
    }

    return !EmailValidator.validate(contact)
        ? "Please provide valid email"
        : '';
  }

  String _preparePhoneNumber(String phone) {
    return "${controller.currentCountryCode.value}$phone";
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      print("[SetProfileScreen:submit] invalid form");
      return;
    }

    controller.isLoading.value = true;

    String newContact = _contactController.text;
    bool isPhoneContact = newContact.isNum;
    if (isPhoneContact) {
      newContact = this._preparePhoneNumber(newContact);
    }
    HTTPManager()
        .createProfile(CreateProfileRequestModel(
            deviceToken: deviceToken,
            phoneNumber: isPhoneContact ? newContact : contact,
            emailAddress: isPhoneContact ? contact : newContact,
            userName: _nameController.text))
        .then((value) async {
      // User user = await UserState.get();
      // await UserState.storeNewProfile(
      //     token: this.deviceToken,
      //     name: _nameController.text,
      //     contact: contact,
      //     regionCode: user.regionCode,
      //     countryCode: user.countryCode);
      // controller.isLoading.value = false;
      User user = await UserState.get();
      await UserState.store(
        User.registered(
            token: value?.token ?? "",
            id: value.user?.data?.sId ?? "",
            name: value.user?.data?.userName ?? "",
            phone: value.user?.data?.phoneNumber ?? "",
            email: value.user?.data?.emailAddress ?? "",
            regionCode: user.regionCode.isNotEmpty
                ? user.regionCode
                : User.DEFAULT_REGION_CODE,
            countryCode: user.countryCode.isNotEmpty
                ? user.countryCode
                : User.DEFAULT_COUNTRY_CODE,
            dynamicLink: user.dynamicLink ?? ""),
      );
      Get.offAll(() => HomeView(index: 1));
    }).catchError((onError) {
      controller.isLoading.value = false;
    });
    // print(
    //     "[SetProfileScreen:submit] contact [$contact] is phone number [$isPhoneContact]");
    // await apicalls.createProfile(
    //   token: this.token,
    //   contact: contact,
    //   contactType: isPhoneContact ? User.PHONE_CONTACT_TYPE : User
    //       .EMAIL_CONTACT_TYPE,
    //   username: _nameController.text,
    // );
  }
}
