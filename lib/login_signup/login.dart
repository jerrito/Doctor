import 'dart:math';
import 'package:doctor/widgets/MainButton.dart';
import 'package:doctor/widgets/MainInput.dart';
import 'package:doctor/constants/Size_of_screen.dart';
import 'package:doctor/databases/firebase_services.dart';
import 'package:doctor/main.dart';
import 'package:doctor/login_signup/otp.dart';
import 'package:doctor/constants/strings.dart';
import 'package:doctor/userProvider.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  List<String> pics = [
    "doctor_1.jpg",
    "doctor_2.jpg",
    "doctor_3.jpg",
    "doctor_4.jpg"
  ];
  int passwordSee = 0;

  var firebaseService = FirebaseServices();
  UserProvider? userProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> formLogin = GlobalKey();
  bool loadingornot = false;
  // final TextEditingController number=TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  String? pic;
  int index_2 = 0;
  bool obscure_2 = true;
  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    pic = (pics[Random().nextInt(pics.length)]).toString();
    Random().nextInt(pics.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DoubleBack(
        message: "Tap again to exit app",
        child: Scaffold(
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
              ),
            ),
            child: Form(
              key: formLogin,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 30),
                        Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 10),
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
                        SizedBox(height: 15),
                        MainInput(
                          validator: phoneNumberValidator,
                          controller: number,
                          label: Text("Number"),
                          hintText: "0244444444",
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(Icons.numbers),
                          obscureText: false,
                          // suffixIcon:Icon(Icons.person) ,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MainInput(
                          validator: pinValidator,
                          controller: password,
                          obscure: '•',
                          obscureText: obscure_2,
                          label: Text("Password"),
                          prefixIcon: Icon(Icons.password),
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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: const Text("Forget password"),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SecondaryButton(
                    child: Text("Login"),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink,
                    onPressed: loadingornot
                        ? null
                        : () async {
                            if (formLogin.currentState?.validate() == true) {
                              await loginWithPhoneNumber();
                            }
                          },
                    color: Colors.pink,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                        child: Row(
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          child: const Text("Signup"),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "signup");
                          },
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          )),
    ));
  }

  String? phoneNumberValidator(String? value) {
    final pattern = RegExp("([0][2358])[0-9]{8}");

    if (pattern.stringMatch(value ?? "") != value) {
      return AppStrings.invalidPhoneNumber;
    }

    return null;
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

  Future<void> loginWithPhoneNumber() async {
    setState(() {
      loadingornot = true;
    });
    String completeNumber = "+233${number.text.substring(1)}";
    var result = await userProvider?.getUser(phoneNumber: completeNumber);
    if (result?.status == QueryStatus.Successful) {
      var user = result?.data;
      print("this is ${user?.number}");
      if (user?.number == completeNumber) {
        if (user?.password == password.text) {
          await phoneSignIn(phoneNumber: completeNumber);
        } else {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 5),
              content: Text("Password is invalid",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Color.fromRGBO(20, 100, 150, 1),
            ));
            loadingornot = false;
          });
        }
        return;
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 5),
            content: Text("Network error, please try again",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Color.fromRGBO(20, 100, 150, 1),
          ));
          loadingornot = false;
        });
      }
      // setState(() {
      //   isLoading = false;
      // });
      return;
    } else if (result?.status == QueryStatus.Failed) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content:
              Text("No account found", style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromRGBO(20, 100, 150, 1),
        ));
        loadingornot = false;
      });

      // print("user?. none");
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
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
          await _auth.signInWithCredential(authCredential);
        }
      }
      // setState(() {
      //   isLoading = false;
      // });
      //Navigator.pushNamed(context, '/transfer');
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    print("verification failed ${exception.message}");
    if (exception.code == 'invalid-phone-number') {
      setState(() {
        loadingornot = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text("The phone number entered is invalid!",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(20, 100, 150, 1),
      ));
    }
    setState(() {
      loadingornot = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 5),
      content: Text("Coudn't verify user, try again",
          style: TextStyle(color: Colors.white)),
      backgroundColor: Color.fromRGBO(20, 100, 150, 1),
    ));
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    // setState(() {
    //   isLoading = false;
    // });
    //ask();
    // this.verificationId = verificationId;
    // print(forceResendingToken);
    // print(sms);
    print(verificationId);
    // print("code sent");

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loadingornot = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTP_verify(
            otpRequest: OTPRequest(
                forceResendingToken: forceResendingToken,
                verifyId: verificationId,
                phoneNumber: number.text,
                //name: username.text,
                see: "register",
                onSuccessCallback: () async {
                  var result_2 = await userProvider?.getUser(
                      phoneNumber: "+233${number.text.substring(1)}");
                  if (result_2?.status == QueryStatus.Successful) {
                    await navigateHome().whenComplete(() =>
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text(
                              "Successfully logged in ${result_2?.data?.fullname}",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Color.fromRGBO(20, 100, 150, 1),
                        )));
                  }
                  // Future.delayed(Duration(seconds:120),(){
                  //   Navigator.pushNamed(context, 'login');
                  // });
                }),
          ),
        ),
      );
    });
  }

  Future<void> navigateHome() async {
    Navigator.pushNamed(context, 'homepage');
  }

  _onCodeTimeout(String timeout) {
    return null;
  }
}
