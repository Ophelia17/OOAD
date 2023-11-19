import 'package:enono/main.dart';
import 'package:enono/presentation/Landing/bloc/landing_bloc.dart';
import 'package:enono/presentation/Login/bloc/login_bloc.dart';
import 'package:enono/presentation/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/registration_bloc.dart';
import 'package:enono/presentation/Landing/landing_screen.dart';

const String landingPageId = "Landing Screen";

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final Map<String, dynamic> _formData = {
  "username": Null,
  "email": Null,
  "password": Null,
  "cpassword": Null
};

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String id = 'registration';

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
                child: BlocConsumer<RegistrationBloc, RegistrationState>(
                    listenWhen: (previousState, state) {
              return previousState != state;
            }, listener: (context, state) {
              if (state is RegistrationErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.code),
                  ),
                );
              }

              if (state is RegistrationSuccessState) {
                print(_formData["cpassword"]);
                print(_formData["email"]);
                print(_formData["password"].toString() ==
                    _formData["cpassword"].toString());
                print(_formData["password"]);
                print(_formData["password"] == _formData["cpassword"]);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (BlocProvider<LoginBloc>(
                      create: (_) => LoginBloc(localStorageService),
                      child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return const LoginScreen();
                        },
                      ),
                    )),
                  ),
                );
                //go to landing page......
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Successfully Registered")));
              }
            }, builder: (BuildContext context, state) {
              if (state is RegistrationTryingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Align(
                child: SizedBox(
                  width: 268 * widthScale,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: 87 * heightScale),
                      child: SizedBox(
                        height: 100 * heightScale,
                        width: 100 * widthScale,
                        child: const Image(image: AssetImage('./logo_new.jpg')),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8 * heightScale),
                      child: const Text(
                        'Welcome to Enono',
                        style: TextStyle(
                            color: Color.fromRGBO(27, 79, 114, 1),
                            fontSize: 20),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 8 * heightScale),
                          child: const Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Username:',
                              style: TextStyle(
                                  color: Color.fromRGBO(27, 79, 114, 1),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Material(
                            child: TextFormField(
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
                          onChanged: (value) => _formData["username"] = value,
                        )),
                        Container(
                          margin: EdgeInsets.only(top: 8 * heightScale),
                          child: const Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Email:',
                              style: TextStyle(
                                  color: Color.fromRGBO(27, 79, 114, 1),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Material(
                            child: TextFormField(
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
                        )),
                        Container(
                          margin: EdgeInsets.only(top: 8 * heightScale),
                          child: const Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Password:',
                              style: TextStyle(
                                  color: Color.fromRGBO(27, 79, 114, 1),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Material(
                            child: TextFormField(
                          obscureText: true,
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
                        )),
                        Container(
                          margin: EdgeInsets.only(top: 8 * heightScale),
                          child: const Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Confirm password:',
                              style: TextStyle(
                                  color: Color.fromRGBO(27, 79, 114, 1),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Material(
                            child: TextFormField(
                          obscureText: true,
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
                          onChanged: (value) => _formData["cpassword"] = value,
                        )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(164 * widthScale, 28 * heightScale),
                            backgroundColor:
                                const Color.fromRGBO(118, 215, 196, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () async {
                            final bloc = context.read<RegistrationBloc>();
                            if (!_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please enter the registration details'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                            //firebase work?
                            else {
                              if (_formData["email"] == null ||
                                  _formData["password"] == null ||
                                  _formData["cpassword"] == null ||
                                  _formData["username"] == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please enter all the registration details'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else if (_formData["password"] !=
                                  _formData["cpassword"]) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'The passwords do not match. Please recheck.'),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                              //else if(_formData["Password"]!=_formData["Confrim Password"]){
                              //ScaffoldMessenger.of(context).showSnackBar(
                              //const SnackBar(
                              //content: Text('The passwords do not match. Please recheck'),
                              //duration: Duration(seconds: 3),
                              //)
                              //);
                              //}
                              else {
                                bloc.add(TryRegistrationEvent(
                                  username: _formData["username"],
                                  email: _formData["email"],
                                  password: _formData["password"],
                                ));
                              }
                            }
                          },
                          child: const Text('Register'),
                        ),
                      ]), //put in the screen it would lead to if the button is preessed
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 4 * heightScale),
                        padding: const EdgeInsets.all(0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      (BlocProvider<LoginBloc>(
                                    create: (_) =>
                                        LoginBloc(localStorageService),
                                    child: BlocBuilder<LoginBloc, LoginState>(
                                      builder: (context, state) {
                                        return const LoginScreen();
                                      },
                                    ),
                                  )),
                                ),
                              );
                            },
                            child: const Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                  color: Color.fromRGBO(40, 116, 166, 1),
                                  fontSize: 10),
                            ),
                          ),
                        )),
                  ]),
                ),
              );
            }))));
  }
}
