import 'package:enono/main.dart';
import 'package:enono/presentation/Landing/landing_screen.dart';
import 'package:enono/presentation/Profile/profile_image.dart';
import 'package:enono/services/firestore_db.dart';
import 'package:flutter/material.dart';
import 'package:enono/data/local/local_database_service.dart';
import 'package:enono/presentation/Login/login_screen.dart';
import '../Landing/bloc/landing_bloc.dart';
import '../Login/bloc/login_bloc.dart';
import 'bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enono/presentation/Hamburger/hamburger.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen(
      {Key? key, required this.localStorageService, required this.uid})
      : super(key: key);

  final LocalStorageService localStorageService;
  static const String id = 'profile';
  final String uid;
  static bool closed = false;
  String userEmail = '';
  String userName = '';
  // String userImage =
  //     'https://png.pngtree.com/png-clipart/20220627/original/pngtree-graduate-student-profile-education-human-png-image_8217698.png';
  void imageClickHandler() {
    print("Edit my profile image");
  }

  List<dynamic> userSchedule = [];
  // Map<String, List<dynamic>> userFriendsData = {"name": [], "uid": []};
  List<dynamic> userFriendNames = [];
  List<dynamic> userFriendUids = [];

  // Future<dynamic> userInfo = getUserEmailAndName(localStorageService.uid);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(localStorageService)..add(const GetUserInfo()),
      child: Scaffold(
          drawer: Hamburger(
            localStorageService: localStorageService,
            uid: localStorageService.uid,
            imagePath:
                'https://png.pngtree.com/png-clipart/20220627/original/pngtree-graduate-student-profile-education-human-png-image_8217698.png',
          ),
          appBar: AppBar(
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ));
            }),
            title: const Text(
              "Profile",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
            backgroundColor: const Color(0xFFF1FAFF),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (BlocProvider<LandingBloc>(
                                    create: (_) =>
                                        LandingBloc(localStorageService),
                                    child:
                                        BlocBuilder<LandingBloc, LandingState>(
                                      builder: (context, state) {
                                        return LandingScreen(
                                          localStorageService:
                                              localStorageService,
                                          uid: localStorageService.uid,
                                        );
                                      },
                                    ),
                                  ))));
                    },
                    child: const Icon(
                      Icons.home_filled,
                      size: 28.0,
                      color: Colors.black,
                    ),
                  )),
            ],
          ),
          body: BlocConsumer<ProfileBloc, ProfileState>(
            listenWhen: (previousState, state) {
              return previousState != state; //listen only when state changes
            },
            listener: (context, state) {
              if (state is ProfileLogOutErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.code),
                  ),
                );
              }

              if (state is ProfileLogOutSuccessState) {
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
            builder: (BuildContext context, state) {
              if (state is ProfileLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ProfileSuccessState) {
                userEmail = state.userInfo['email'];
                userName = state.userInfo['name'];
              }
              if (state is GetUserScheduleSuccessState) {
                userSchedule =
                    state.userSchedule.isNotEmpty ? state.userSchedule : [];
              }
              if (state is GetFriendsSuccessState) {
                // userFriendsData = {
                //   "name": state.userFriends['name']!,
                //   "uid": state.userFriends['uid']!,
                // };
                userFriendNames = state.userFriends;
                userFriendUids = state.userFriendUids;
              }
              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  ProfileImage(
                      imagePath:
                          'https://png.pngtree.com/png-clipart/20220627/original/pngtree-graduate-student-profile-education-human-png-image_8217698.png',
                      onClicked: imageClickHandler),
                  const SizedBox(
                    height: 6,
                  ),
                  Column(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF21618C)),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        userEmail,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF2E86C1)),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.amber,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  GestureDetector(
                      child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFA9CCE3)),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: ExpansionTile(
                      title: const Text(
                        'Schedule',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      children: ScheduleTile(userSchedule),
                    ),
                  )),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                      child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFA9CCE3)),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: ExpansionTile(
                      title: const Text(
                        'Friends',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      children: FriendTile(userFriendNames, userFriendUids),
                    ),
                  )),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    color: Colors.amber,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  GestureDetector(
                    onTap: (() async {
                      final bloc = context.read<ProfileBloc>();
                      bloc.add(const ProfileTryLogOutEvent());
                      print("This button logs you out, just don't touch it");
                    }),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFA9CCE3)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFFC0392B)),
                            ),
                          ),
                          const Positioned(
                            left: 12,
                            top: 12,
                            child: Icon(
                              Icons.logout_rounded,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          )),
    );
  }

  // ignore: non_constant_identifier_names
  List<Widget> ScheduleTile(List<dynamic> schedule) {
    List<Widget> scheduleWidgetList = [];
    for (int i = 0; i < schedule.length; i++) {
      scheduleWidgetList.add(ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        title: Text(
          schedule[i]['time'],
          style: const TextStyle(fontSize: 14, color: Color(0xFF154360)),
        ),
        subtitle: Text(
          schedule[i]['work'],
          style: const TextStyle(fontSize: 12, color: Color(0xFF21618C)),
        ),
      ));
    }
    return scheduleWidgetList;
  }

  List<Widget> FriendTile(List<dynamic> friendNames, List<dynamic> friendUids) {
    // print(friendNames);
    List<Widget> friendsWidgetList = [];
    for (int i = 0; i < friendNames.length; i++) {
      friendsWidgetList.add(ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        title: Text(
          friendNames[i],
          style: const TextStyle(fontSize: 14, color: Color(0xFF154360)),
        ),
        trailing: GestureDetector(
            onTap: (() {
              print("Delete friend");
              deleteFriend(uid, friendUids[i]);
            }),
            child: const Icon(
              Icons.delete,
              color: Color(0xFFC0392B),
              size: 18,
            )),
      ));
    }
    return friendsWidgetList;
  }
}
