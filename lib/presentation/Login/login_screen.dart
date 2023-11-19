import 'package:enono/main.dart';
import 'package:enono/presentation/Landing/bloc/landing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'bloc/login_bloc.dart';
import 'package:enono/presentation/Landing/landing_screen.dart';
import '../Registration/bloc/registration_bloc.dart';
import '../Registration/registration_screen.dart';

const String landingPageId = "LandingScreen";

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final Map<String, dynamic> _formData = {"Email": Null, "password": Null};

final GlobalKey<FormState> _forgotPasswordKey = GlobalKey<FormState>();
String _forgotPasswordEmail = '';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'login';

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    const double heightFactor = 640;
    const double widthFactor = 360;
    final double heightScale = deviceHeight / heightFactor;
    final double widthScale = deviceWidth / widthFactor;
    return Theme(
      data: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: BlocConsumer<LoginBloc, LoginState>(
            listenWhen: (previousState, state) {
              return previousState != state; //listen only when state changes
            },
            listener: (context, state) {
              if (state is LoginErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.code),
                    //duration: const Duration(seconds: 3),
                  ),
                );
              }

              if (state is LoginSuccessState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (BlocProvider<LandingBloc>(
                      create: (_) => LandingBloc(localStorageService),
                      child: BlocBuilder<LandingBloc, LandingState>(
                        builder: (context, state) {
                          return LandingScreen(
                            localStorageService: localStorageService,
                            uid: localStorageService.uid,
                          );
                        },
                      ),
                    )),
                  ),
                );
                //go to landing page
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Successfully Logged In")));
              }
            },
            builder: (BuildContext context, state) {
              if (state is LoginTryingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Align(
                //child: SingleChildScrollView(
                //physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  //height: deviceHeight,
                  width: 268 * widthScale,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: 87 * heightScale),
                      child: SizedBox(
                          height: 100 * heightScale,
                          width: 100 * widthScale,
                          child:
                              const Image(image: AssetImage('./logo_new.jpg'))),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8 * heightScale),
                      child: const Text(
                        'Welcome to Enono',
                        style: TextStyle(
                          color: Color.fromRGBO(27, 79, 114, 1),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 24 * heightScale),
                              child: const Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 79, 114, 1),
                                  ),
                                ),
                              )),
                          //The Widget written in angular brackets specifies that all elements of the array will be of the type Widget
                          TextFormField(
                            decoration: InputDecoration(
                              constraints: BoxConstraints(
                                  minHeight: 22 * heightScale,
                                  maxHeight: 22 * heightScale),
                              filled: true,
                              fillColor: const Color.fromRGBO(255, 250, 221, 1),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 235, 173, 1),
                                ),
                              ),
                            ),
                            onChanged: (value) => _formData["email"] = value,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 8 * heightScale),
                              child: const Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 79, 114, 1),
                                  ),
                                ),
                              )),
                          TextFormField(
                            obscureText: true, //this is to hide password
                            obscuringCharacter: "*",
                            decoration: InputDecoration(
                              constraints: BoxConstraints(
                                  minHeight: 22 * heightScale,
                                  maxHeight: 22 * heightScale),
                              filled: true,
                              fillColor: const Color.fromRGBO(255, 250, 221, 1),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 235, 173, 1),
                                ),
                              ),
                            ),
                            onChanged: (value) => _formData["password"] = value,
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 8 * heightScale),
                              padding: const EdgeInsets.all(0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.all(0))),
                                  onPressed: () {
                                    AlertDialog(
                                      content: Column(
                                        children: [
                                          TextFormField(
                                            key: _forgotPasswordKey,
                                            decoration: InputDecoration(
                                              constraints: BoxConstraints(
                                                  minHeight: 22 * heightScale,
                                                  maxHeight: 22 * heightScale),
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  255, 250, 221, 1),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                                borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      255, 235, 173, 1),
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) =>
                                                _forgotPasswordEmail = value,
                                          ),
                                          FloatingActionButton(onPressed: () {
                                            try {
                                              FirebaseAuth.instance
                                                  .sendPasswordResetEmail(
                                                      email:
                                                          _forgotPasswordEmail);
                                            } catch (e) {
                                              Dialog(
                                                child: Text(e.toString()),
                                              );
                                            }
                                          })
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Color.fromRGBO(52, 152, 219, 1),
                                    ),
                                  ),
                                ),
                              )),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(164 * widthScale, 28 * heightScale),
                                backgroundColor:
                                    const Color.fromRGBO(118, 215, 196, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                            onPressed: () async {
                              final bloc = context.read<LoginBloc>();
                              if (!_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please enter email and password'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                              //firebase work
                              else {
                                if (_formData["email"] == null ||
                                    _formData["password"] == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter email and password'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else {
                                  bloc.add(TryLoginEvent(
                                      email: _formData["email"],
                                      password: _formData["password"]));
                                }
                              }
                            },
                            child: const Text(
                              'Login',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('or login with',
                        style: TextStyle(
                          color: Color.fromRGBO(40, 116, 166, 1),
                        )),
                    //Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(164 * widthScale, 28 * heightScale),
                          backgroundColor:
                              const Color.fromRGBO(130, 224, 170, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      child: const Text('Google'),
                      onPressed: () {
                        final bloc = context.read<LoginBloc>();
                        bloc.add(const LoginGoogleEvent());
                      },
                    ),
                    Tooltip(
                      message:
                          'If you have an existing email-password account and then log in with Google, you will be able to log in with Google only afterwards',
                      preferBelow: true,
                      showDuration: const Duration(seconds: 7),
                      triggerMode: TooltipTriggerMode.tap,
                      margin: EdgeInsets.fromLTRB(
                          46 * widthScale, 0, 46 * widthScale, 0),
                      decoration: ShapeDecoration(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Icon(Icons.info),
                    )
                    //],
                    //)
                    ,
                    // const Text(
                    //   'Note: If you have an existing email-password account and then log in with Google, you will be able to log in with Google only afterwards',
                    //   textAlign: TextAlign.justify,
                    // ),
                    Container(
                        margin: EdgeInsets.only(top: 16 * heightScale),
                        padding: const EdgeInsets.all(0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(0))),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      (BlocProvider<RegistrationBloc>(
                                    create: (_) =>
                                        RegistrationBloc(localStorageService),
                                    child: BlocBuilder<RegistrationBloc,
                                        RegistrationState>(
                                      builder: (context, state) {
                                        return const RegistrationScreen();
                                      },
                                    ),
                                  )),
                                ),
                              );
                            },
                            child: const Text(
                              'Donot have an account? Register',
                              style: TextStyle(
                                color: Color.fromRGBO(40, 116, 166, 1),
                              ),
                            ),
                          ),
                        )),
                  ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
