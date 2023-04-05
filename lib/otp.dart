import 'package:doctor/MainButton.dart';
import 'package:doctor/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:momo/components/button_input.dart';
//import 'package:momo/Screen.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:telephony/telephony.dart';
import 'package:doctor/user.dart' as User_main;
import 'package:doctor/userProvider.dart';
import 'package:doctor/main.dart';
import 'package:doctor/mongo.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:mongo_dart/mongo_dart.dart' as Db;
import 'package:firebase_auth/firebase_auth.dart';


class OTPRequest {
  String? verifyId, phoneNumber,see, name;
  int? forceResendingToken;
  void Function()? onSuccessCallback;

  OTPRequest({
    this.verifyId,
    this.name,
    this.see,
    this.phoneNumber,
    this.forceResendingToken,
    this.onSuccessCallback,
  });
}
class OTP_verify extends StatefulWidget {
  OTPRequest otpRequest;
  OTP_verify({
    super.key,
    required this.otpRequest,
  });


  @override
  State<OTP_verify> createState() => _OTP_verifyState();
}

class _OTP_verifyState extends State<OTP_verify> {
  FirebaseAuth auth=FirebaseAuth.instance;
  var verification;
  final _auth = FirebaseAuth.instance;
  Telephony telephony = Telephony.instance;
  String _otpString = "";
  OtpFieldController otpbox = OtpFieldController();
  String? verificationId;
  bool _wrongOtp = false;
  bool isLoading = false;
  bool isresend = true;
  String? sms;
  bool loadingornot= false;
  bool resend=false;
  String? see;




  // var verify;

  // FocusNode? pin7_get;
  timer_check(){
    Future.delayed(Duration(seconds: 90), (){
      setState((){
        resend=true;
      }) ;
    });
  }

  @override
  void initState() {


    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        // print(message.address); //+977981******67, sender nubmer
        // print(message.body); //Your OTP code is 34567
        // print(message.date); //1659690242000, timestamp

        String sms = message.body.toString(); //get the message


        if(message.address == "Google" || message.address=="CloudOTP" ||
            message.address=="wasime" || message.address=="Wasime"){
          //verify SMS is sent for OTP with sender number
          String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'),'');
          //prase code from the OTP sms
          // print("This is $otpcode");
          otpbox.set(otpcode.split(""));
          //split otp code to list of number
          //and populate to otb boxes
          setState(() {});}
        else{print("Normal message.");}
      },
      // onBackgroundMessage:(SmsMessage message) {
      //   String sms = message.body.toString();
      //   if(message.address == "Google" || message.address=="CloudOTP" ||
      //       message.address=="wasime" || message.address=="Wasime"){
      //     String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'),'');
      //     otpbox.set(otpcode.split(""));
      //   }} ,
      listenInBackground: false,
    );
    timer_check();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void get_remove_focus(String value, FocusNode focus) {
    if (value.length == 1) {
      focus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: SizeConfig.blockSizeVertical * 2.3125),
              SizedBox(height:50),
              Text(
                  "We've sent a code to the number ${widget.otpRequest.phoneNumber}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width:double.infinity,
                      child:OTPTextField(
                        length: 6,
                        onChanged: onKeyPressed,
                        keyboardType: TextInputType.number,
                        controller: otpbox,
                        otpFieldStyle: OtpFieldStyle(

                        ),
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: w_s*13.89,
                        style: TextStyle(
                            fontSize: 17
                        ),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        //fieldStyle: F,
                        onCompleted: (val) async{
                          print(val);
                          Future.delayed(Duration(seconds: 1),(){_verifyOtpCode();});

                        },
                      ),
                    ),
                    // SizedBox(height:SizeConfig.blockSizeVertical*0.5),
                    //timer(),
                  ],
                ),
              ),
              //SizedBox(height: SizeConfig.blockSizeVertical * 59.75),
              SizedBox(width: double.infinity,height:h_s*7.5,
                child: SecondaryButton(
                  onPressed:_otpString.length!=6?null: () async {
                    _verifyOtpCode();
                  },
                  backgroundColor: Colors.pink,
                  color:Colors.pink,
                  foregroundColor: Colors.white,
                   child: Text("Confirm"),
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: resend,
                    child: const Text("Didn't receive OTP?",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLoading ;
                          isresend=false;
                        });
                       // Signuppage. phoneSignIn(widget.otpRequest.phoneNumber.toString());  //phoneSignIn(phoneNumber: userNumber.text);
                      },
                      child:  Visibility(
                        visible:resend,
                        child: Text("Resend",
                            style: TextStyle(
                              fontSize: 15,)),
                      ))
                ],
              )
            ],
          ),
        ));
  }
  void onKeyPressed(String inputValue) {
    setState(() {
      print("This is "+inputValue);
      _otpString = inputValue;
    });
  }
  _verifyOtpCode() async {
    setState(() {
      isLoading = true;
      _wrongOtp = false;
    });
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.otpRequest.verifyId.toString() , smsCode: _otpString);

    try {
      var result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        widget.otpRequest.onSuccessCallback?.call();
      }
      
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);

      }

      if (e.code == "invalid-verification-code") {
        setState(() {
          _wrongOtp = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid Otp code",style:TextStyle(color:Colors.white)),
                backgroundColor: Color.fromRGBO(20, 100, 150, 1),
                duration:Duration(seconds:5))
        );
      }

      // PrimarySnackBar(context).displaySnackBar(
      //   message: "Wrong OTP code provided",
      //   backgroundColor: AppColors.errorRed,
      // );
    }

    setState(() {
      isLoading = false;
    });
  }
  // Future<void> phoneSignIn({required String phoneNumber}) async {
  //   await auth.verifyPhoneNumber(
  //     timeout: const Duration(seconds:120),
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: _onVerificationCompleted,
  //     verificationFailed: _onVerificationFailed,
  //     codeSent: _onCodeSent,
  //     codeAutoRetrievalTimeout: _onCodeTimeout,
  //   );
  // }
  //
  // _onVerificationCompleted(PhoneAuthCredential authCredential) async {
  //   print("verification completed ${authCredential.smsCode}");
  //   print(" ${authCredential.verificationId}");
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (authCredential.smsCode != null) {
  //     try {
  //       UserCredential credential =
  //       await user!.linkWithCredential(authCredential);
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'provider-already-linked') {
  //         await auth.signInWithCredential(authCredential);
  //       }
  //     }
  //
  //   }
  // }
  //
  // _onVerificationFailed(FirebaseAuthException exception) {
  //   print("verification failed ${exception.message}");
  //   if (exception.code == 'invalid-phone-number') {
  //
  //   }
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(duration: Duration(seconds: 5),
  //         content: Text("Verification failed. PLease try again",style:TextStyle(color:Colors.white)),
  //         backgroundColor: Color.fromRGBO(20, 100, 150, 1),));
  // }
  //
  // _onCodeSent(String verificationId, int? forceResendingToken) {
  //   setState(() {
  //     loadingornot = false;
  //   });
  //   print(verificationId);
  //   Future.delayed(Duration(seconds: 2),(){
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => OTP_verify(
  //           otpRequest: OTPRequest(
  //               forceResendingToken: forceResendingToken,
  //               verifyId: verificationId,
  //               phoneNumber: widget.otpRequest.phoneNumber,
  //               //name: username.text,
  //               see: "register",
  //               onSuccessCallback: () async {
  //                 var user = User_main.User(
  //                     number: "+233${widget.otpRequest.phoneNumber?.substring(1)}",
  //                     fullname: widget.otpRequest.fullname,
  //                     email:widget.otpRequest.email,
  //                     password:password
  //                 );
  //                 var result = await FirebaseServices().saveUser(user: user);
  //                 if (result?.status == QueryStatus.Successful) {
  //                   await mongoAdd();
  //
  //                   await showSnack();
  //                   var result2= await userProvider?.getUser(phoneNumber: "+233${phoneNumber.text.substring(1)}");
  //                   print(result2?.status);
  //                   if (result2?.status == QueryStatus.Successful) {
  //                     await navigate();
  //                   }
  //                   else{
  //                     userGetFailed();
  //                   }
  //                 }
  //                 else{
  //                   failed();
  //                 }
  //               }
  //
  //
  //           ),),
  //       ),
  //     );
  //   });
  // }
  // void failed(){
  //   Navigator.pop(context);
  // }
  // Future<String> mongoAdd()async{
  //   userProvider=context.read<UserProvider>();
  //   var _id=Db.ObjectId();
  //   var user = User_main.User(
  //       id: "",
  //       number: "+233${phoneNumber.text.substring(1)}",
  //       fullname: fullname.text,
  //       email:email.text,
  //       password:password.text,
  //       image: ""
  //   );
  //   var  result_2=  await  mongo.insertDoctorDetail(user: user);
  //   return result_2;
  // }
  // Future<void> navigate()  async{
  //   await Navigator.pushNamed(context, 'homepage');
  // }
  // Future<void> showSnack()async{
  //   print("Account success");
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(duration: Duration(seconds: 5),
  //         content: Text("Successfully registered ${userProvider?.appUser?.fullname}",style:TextStyle(color:Colors.white)),
  //         backgroundColor: Color.fromRGBO(20, 100, 150, 1),));
  // }
  // void userGetFailed(){
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar( duration: Duration(seconds: 5),
  //         content: Text("Please login with your details"),));
  //   Navigator.pushNamed(context,"login");
  // }
  // _onCodeTimeout(String timeout) {
  //   return null;
  // }

}