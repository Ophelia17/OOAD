import 'package:enono/data/local/local_database_service.dart';
import 'package:enono/presentation/Hamburger/bloc/hamburger_bloc.dart';
import 'package:enono/presentation/Login/bloc/login_bloc.dart';
import 'package:enono/presentation/Login/login_screen.dart';
import 'package:enono/presentation/Profile/bloc/profile_bloc.dart';
import 'package:enono/presentation/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:enono/presentation/Hamburger/bloc/hamburger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:enono/presentation/scheduler/scheduler_screen.dart';

class Hamburger extends StatelessWidget {
  Hamburger(
      {Key? key,
      required this.localStorageService,
      required this.uid,
      required this.imagePath})
      : super(key: key);

  final LocalStorageService localStorageService;
  static const String id = 'hamburger';
  static bool closed = false;
  final String uid;
  String imagePath;
  String userName = '';
  String userEmail = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HamburgerBloc(localStorageService)..add(const HamburgerGetUserInfo()),
      child: BlocConsumer<HamburgerBloc, HamburgerState>(
        listenWhen: (previousState, state) {
          return previousState != state; //listen only when state changes
        },
        listener: (context, state) {
          if (state is HamburgerLogOutErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.code),
              ),
            );
          }
          if (state is HamburgerGetUserInfoSuccessState) {
            userName = state.userInfo['name'];
            userEmail = state.userInfo['email'];
          }
          if (state is HamburgerLogOutSuccessState) {
            localStorageService.isLoggedIn = false;
            localStorageService.uid = 'null';
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
            //go to login page
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Successfully Logged Out")));
            closed = true;
          }
        },
        builder: (context, state) {
          if (state is HamburgerGetUserInfoLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // final image = NetworkImage(imagePath);
          return Drawer(
            backgroundColor: const Color(0xFFFFFEF9),
            child: ListView(
              // padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    // image: DecorationImage(
                    //     image: NetworkImage(
                    //         'https://img.freepik.com/premium-vector/city-map-with-pins-town-roads-residential-blocks-gps-navigation-route-with-pointers-abstract-urban-travel-locating-geo-infographic-background_176411-909.jpg?w=2000')),
                    color: Color(0xFFFFF6BF),
                    // borderRadius:
                    //     BorderRadius.only(topRight: Radius.circular(24))
                  ),
                  accountName: Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF154360),
                        fontWeight: FontWeight.w400),
                  ),
                  accountEmail: Text(
                    userEmail,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1F618D),
                        fontWeight: FontWeight.w400),
                  ),
                  currentAccountPicture: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFFD6EAF8), width: 6),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(16)),
                        ),
                        child: Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                      localStorageService: localStorageService,
                                      uid: localStorageService.uid,
                                    )));
                      },
                      visualDensity: const VisualDensity(vertical: -3),
                      leading: const Icon(
                        Icons.account_circle_sharp,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'My Account',
                        style: TextStyle(
                            color: Color(0xFF2471A3),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFFFEBAD),
                      thickness: 1,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return SchedulerScreen(localStorageService: localStorageService, uid: localStorageService.uid);
                            }));
                          },
                          visualDensity: VisualDensity(vertical: -3),
                          leading: Icon(
                            Icons.access_time_filled_rounded,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Schedule',
                            style: TextStyle(
                                color: Color(0xFF2471A3),
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        ListTile(
                          visualDensity: VisualDensity(vertical: -3),
                          leading: Icon(
                            Icons.group_rounded,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Friends',
                            style: TextStyle(
                                color: Color(0xFF2471A3),
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ]),
                    ),
                    const Divider(
                      color: Color(0xFFFFEBAD),
                      thickness: 1,
                    ),
                    ListTile(
                      onTap: (() async {
                        final bloc = context.read<HamburgerBloc>();
                        bloc.add(const HamburgerTryLogOutEvent());
                        print("This button logs you out, just don't touch it");
                      }),
                      visualDensity: VisualDensity(vertical: -4),
                      title: const Center(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              color: Color(0xFFC0392B),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFFFEBAD),
                      thickness: 1,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
