import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/MainButton.dart';
import 'package:doctor/MainInput.dart';
import 'package:doctor/Size_of_screen.dart';
import 'package:doctor/firebase_services.dart';
import 'package:doctor/main.dart';
import 'package:doctor/mongo.dart';
import 'package:doctor/otp.dart';
import 'package:doctor/strings.dart';
import 'package:doctor/user.dart' as User_main;
import 'package:doctor/userProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mongo_dart/mongo_dart.dart' as Db;
import 'package:provider/provider.dart';

// showExceptionAlertDialog(
// context,
// exception: e,
// title: 'Sign In Failed',
// );

class Signuppage extends StatefulWidget {
  const Signuppage({Key? key}) : super(key: key);

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();
  GlobalKey<FormState> form = GlobalKey();

  var firebaseService = FirebaseServices();
  UserProvider? userProvider;
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  bool checkLoading = true;
  bool loadingornot = false;

  List<String> pics = [
    "doctor_1.jpg",
    "doctor_2.jpg",
    "doctor_3.jpg",
    "doctor_4.jpg"
  ];
  String? pic;
  int index_2 = 0;
  bool obscure_2 = true;
  @override
  void initState() {
    pic = (pics[Random().nextInt(pics.length)]).toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(210, 230, 250, 0.2),
                  Color.fromRGBO(210, 230, 250, 0.2)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Visibility(
              visible: !loadingornot,
              replacement: Center(
                  child: SpinKitFadingCube(
                color: Colors.pink,
                size: 50.0,
              )),
              child: Form(
                key: form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(height: 30),
                          Center(
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: h_s * 15,
                              backgroundImage: Image.asset(
                                "./assets/images/$pic",
                                height: h / 3,
                                width: w,
                              ).image,
                            ),
                          ),
                          //Center(child: Text("Let's get things going by signing up", style: TextStyle(fontSize: 17, color: Colors.black),)),
                          SizedBox(height: 15),
                          MainInput(
                            validator: FullNameValidator,
                            controller: fullname,
                            label: Text("Full Name"),
                            prefixIcon: Icon(Icons.person), obscureText: false,
                            // suffixIcon:Icon(Icons.person) ,
                          ),
                          SizedBox(height: 15),
                          MainInput(
                            validator: phoneNumberValidator,
                            controller: phoneNumber,
                            label: Text("Phone Number"),
                            prefixIcon: Icon(Icons.person),
                            keyboardType: TextInputType.number,
                            //  suffixIcon:Icon(Icons.remove_red_eye),
                            obscureText: false,
                          ),
                          SizedBox(height: 15),
                          MainInput(
                            validator: emailValidator,
                            controller: email,
                            label: Text("Email"),
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(Icons.email), obscureText: false,
                            // suffixIcon:Icon(Icons.person) ,
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          MainInput(
                            validator: pinValidator,
                            controller: password,
                            label: Text("Password"),
                            prefixIcon: Icon(Icons.password_outlined),
                            suffixIcon: IconButton(
                                icon: obscure_2 == true
                                    ? SvgPicture.asset("./assets/svgs/eye.svg",
                                        color: Colors.amber)
                                    : SvgPicture.asset(
                                        "./assets/svgs/eye-off.svg",
                                        color: Colors.amber),
                                onPressed: () {
                                  setState(() {
                                    obscure_2 = false;
                                    index_2++;
                                    if (index_2 % 2 == 0) {
                                      obscure_2 = true;
                                    }
                                  });
                                }),
                            obscureText: obscure_2,
                          ),
                        ],
                      ),
                    ),
                    SecondaryButton(
                      child: Text("Signup"),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pink,
                      onPressed: loadingornot
                          ? null
                          : () async {
                              if (form.currentState?.validate() == true) {
                                setState(() {
                                  loadingornot = true;
                                });
                                await ayaresapaRegister();

                                // Navigator.pushNamed(context,"homepage");
                              }
                            },
                      color: Colors.pink,
                    ),
                    Center(
                        child: Row(
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          child: const Text("Signin"),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "login");
                          },
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            )));
  }

  String? pinValidator(String? value) {
    final pattern = RegExp("[0-9]{4}");
    if (value?.isEmpty == true) {
      return AppStrings.isRequired;
    } else if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.isNotEqual;
    }
    return null;
  }

  String? phoneNumberValidator(String? value) {
    final pattern = RegExp("([0][2358])[0-9]{8}");

    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidPhoneNumber;
    }

    return null;
  }

  String? FullNameValidator(String? value) {
    final pattern = RegExp("([A-Z][a-z]+)[/s/ ]+([A-Z][a-z]+)");

    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidFullName;
    }

    return null;
  }

  String? NameValidator(String? value) {
    final pattern = RegExp("[A-Z]([a-z]+)");

    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidName;
    }

    return null;
  }

  String? emailValidator(String? value) {
    final pattern =
        RegExp("^([a-zA-Z0-9_/-/./]+)@([a-zA-Z0-9_/-/.]+)[.]([a-zA-Z]{2,5})");
    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidEmails;
    }
    return null;
  }

  Future<void> ayaresapaRegister() async {
    print("sup");
    String completePhoneNumber = "+233${phoneNumber.text.substring(1)}";
    var resultMain =
        await FirebaseServices().getUser(phoneNumber: completePhoneNumber);
    print(resultMain?.status);
    if (resultMain?.status == QueryStatus.Successful) {
      var userOld = resultMain?.data;
      if (userOld?.number == completePhoneNumber) {
        setState(() {
          loadingornot = false;
        });
        print("Account already exist");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Account already exist",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromRGBO(20, 100, 150, 1),
        ));
        return;
      }
      phoneSignIn(phoneNumber: "+233${phoneNumber.text.substring(1)}");
    } else {
      setState(() {
        loadingornot = false;
      });
      print("Account error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Error registering account",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(20, 100, 150, 1),
      ));
    }
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: phoneNumber,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    print(" ${authCredential.verificationId}");
    User? user = FirebaseAuth.instance.currentUser;

    if (authCredential.smsCode != null) {
      try {
        UserCredential credential =
            await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await auth.signInWithCredential(authCredential);
        }
      }
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    print("verification failed ${exception.message}");
    if (exception.code == 'invalid-phone-number') {}
    setState(() {
      loadingornot = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 5),
      content: Text("Verification failed. Please try again",
          style: TextStyle(color: Colors.white)),
      backgroundColor: Color.fromRGBO(20, 100, 150, 1),
    ));
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    setState(() {
      loadingornot = false;
    });
    print(verificationId);
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTP_verify(
            otpRequest: OTPRequest(
                forceResendingToken: forceResendingToken,
                verifyId: verificationId,
                phoneNumber: phoneNumber.text,
                //name: username.text,
                see: "register",
                onSuccessCallback: () async {
                  var user = User_main.User(
                      number: "+233${phoneNumber.text.substring(1)}",
                      fullname: fullname.text,
                      email: email.text,
                      password: password.text,
                      image: "",
                      ratings: 5,
                      //experience: ,
                      speciality: "Family physician",
                      location: "",
                      patients: 0);
                  var result = await FirebaseServices().saveUser(user: user);
                  if (result?.status == QueryStatus.Successful) {
                    await mongo.con();
                    await mongoAdd().whenComplete(() =>
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text("Successfully registered",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Color.fromRGBO(20, 100, 150, 1),
                        )));
                    //await showSnack();
                    var result2 = await userProvider?.getUser(
                        phoneNumber: "+233${phoneNumber.text.substring(1)}");
                    print(result2?.status);
                    if (result2?.status == QueryStatus.Successful) {
                      await navigate();
                    } else {
                      userGetFailed();
                    }
                  } else {
                    failed();
                  }
                }),
          ),
        ),
      );
    });
  }

  void failed() {
    Navigator.pop(context);
  }

  Future<String> mongoAdd() async {
    userProvider = context.read<UserProvider>();
    var _id = Db.ObjectId();

    var user = User_main.User(
        id: "",
        number: "+233${phoneNumber.text.substring(1)}",
        fullname: fullname.text,
        email: email.text,
        password: password.text,
        image: "",
        ratings: 5,
        //experience: ,
        speciality: "Family physician",
        shortBio: "",
        location: "",
        patients: 0);
    await RealtimeDatabase.write(userId: auth.currentUser!.uid, user: user);
    var result_2 = await mongo.insertDoctorDetail(user: user);
    return result_2;
  }

  Future<void> navigate() async {
    await Navigator.pushNamed(context, 'homepage');
  }

  // Future<void> showSnack() async {
  //   //userProvider=context.read<UserProvider>();
  //   print("Account success");
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //     duration: Duration(seconds: 5),
  //     content: Text("Successfully registered",
  //         style: TextStyle(color: Colors.white)),
  //     backgroundColor: Color.fromRGBO(20, 100, 150, 1),
  //   ));
  // }

  void userGetFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Please login with your details",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromRGBO(20, 100, 150, 1)),
    );
    Navigator.pushNamed(context, "login");
  }

  _onCodeTimeout(String timeout) {
    return null;
  }
}
