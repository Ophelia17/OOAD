import 'package:enono/main.dart';
import 'package:enono/presentation/Landing/bottom_sheet.dart';
import 'package:enono/presentation/Landing/search_dest_bottom_sheet.dart';
import 'package:enono/presentation/Login/bloc/login_bloc.dart';
import 'package:enono/presentation/Profile/profile_screen.dart';
import 'package:enono/services/firestore_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:enono/data/local/local_database_service.dart';
import 'package:enono/presentation/Login/login_screen.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'bloc/landing_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enono/presentation/Hamburger/hamburger.dart';

final MapController mapController = MapController(
    initMapWithUserPosition: true,
    areaLimit: const BoundingBox.world(),
  );
class LandingScreen extends StatelessWidget {
  LandingScreen(
      {Key? key, required this.localStorageService, required this.uid})
      : super(key: key);
  final LocalStorageService localStorageService;
  static const String id = 'landing';
  final String uid;
  static bool closed = false;
  // static bool showedRequests = false;
  List<dynamic> userFriendsList = [];
  List<dynamic> userFriendUidsList = [];
  String? friendName;

  late List<dynamic> userFriendUidsOptions;
  late List<dynamic> userFriendNamesOptions;

  dynamic currentFriend = '';
  dynamic currentFriendUid = '';
  bool friendIsSelected = false;


  final GlobalKey mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LandingBloc(localStorageService)..add(const LoadLandingScreen()),
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
            "Enono",
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
                            builder: (context) => ProfileScreen(
                                  localStorageService: localStorageService,
                                  uid: localStorageService.uid,
                                )));
                  },
                  child: const Icon(
                    Icons.account_circle_sharp,
                    size: 28.0,
                    color: Colors.black,
                  ),
                )),
          ],
        ),
        body: BlocConsumer<LandingBloc, LandingState>(
          listenWhen: (previousState, state) {
            return previousState != state; //listen only when state changes
          },
          listener: (context, state) {
            if (state is LandingGetFriendsSuccessState) {
              userFriendsList = state.userFriends;
              userFriendUidsList = state.userFriendUids;
            }
            if (state is LandingGetFriendOptionsSuccess) {
              userFriendUidsOptions = state.friendUids;
              userFriendNamesOptions = state.friendNames;
            }
            if (state is LandingSelectFriendSuccess) {
              currentFriend = state.currentFriend;
              currentFriendUid = state.currentFriendUid;
              friendIsSelected = state.friendSelected;
            }
            // if (state is LogOutErrorState) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(state.code),
            //     ),
            //   );
            // }

            // if (state is LogOutSuccessState) {
            //   localStorageService.isLoggedIn = false;
            //   localStorageService.uid = 'null';
            //   closed = false;
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => (BlocProvider<LoginBloc>(
            //         create: (_) => LoginBloc(localStorageService),
            //         child: BlocBuilder<LoginBloc, LoginState>(
            //           builder: (context, state) {
            //             return const LoginScreen();
            //           },
            //         ),
            //       )),
            //     ),
            //   );
            //   //go to login page
            //   ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text("Successfully Logged Out")));
            // }
          },
          builder: (BuildContext context, state) {
            // if (state is LogOutTryingState || state is LandingLoadingState) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            if (state is LoadMapState) {

              return Align(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Color(0xFFD6EAF8),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                onChanged: (value) async {
                                  friendName = value;
                                  await getAllUsers();
                                  List<GeoPoint> existingPoint =
                                      await mapController.geopoints;
                                  print('existing points are $existingPoint');
                                  existingPoint.forEach((element) async {
                                    await mapController.removeMarker(element);
                                  });
                                  print(nameToLocation[value]![0]);
                                  await mapController.addMarker(GeoPoint(
                                      latitude: nameToLocation[value]![0],
                                      longitude: nameToLocation[value]![1]));
                                  List<GeoPoint> newPoints = await mapController.geopoints;
                                  print('New points are $newPoints');
                                  print('done');
                                  final bloc = context.read<LandingBloc>();
                                  bloc.add(LandingSelectFriend(
                                      friendName: value,
                                      friendNames: userFriendsList,
                                      friendUids: userFriendUidsList));
                                },
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1A5276),
                                ),
                                value: friendName,
                                items:
                                    userFriendsList.map<DropdownMenuItem<String>>(
                                  (value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                              ),
                            )),
                        Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 160,
                              width: MediaQuery.of(context).size.width,
                              child: OSMFlutter(
                                showContributorBadgeForOSM: true,
                                controller: mapController,
                                key: mapKey,
                                initZoom: 15,
                                trackMyPosition: true,
                                stepZoom: 1,
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: FloatingActionButton.small(
                                heroTag: 'relocate',
                                backgroundColor: const Color(0xFF21618C),
                                onPressed: () async {
                                  await mapController.currentLocation();
                                  print("Pressed to refresh my location");
                                },
                                child: const Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              left: 4,
                              child: FloatingActionButton.small(
                                heroTag: 'refresh',
                                backgroundColor: const Color(0xFF21618C),
                                onPressed: () async {
                                  // await mapController.removeMarker(GeoPoint(
                                  //     latitude: nameToLocation[friendName]![0],
                                  //     longitude:
                                  //         nameToLocation[friendName]![1]));
                                  await refreshLocations(friendName!);
                                  await mapController.addMarker(GeoPoint(
                                      latitude: nameToLocation[friendName]![0],
                                      longitude:
                                          nameToLocation[friendName]![1]));
                                  print("Pressed to refresh map");
                                },
                                child: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              top: 2,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await requestDialogs(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFAED6F1),
                                        shape: const StadiumBorder(),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8)),
                                    child: const Text(
                                      "View Requests",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF21618C)),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Positioned.fill(
                      bottom: 8,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: ((context) {
                                    if (friendIsSelected) {
                                      return buildSearchDestBottomSheet(
                                          context, uid,
                                          friendUid: currentFriendUid);
                                    } else {
                                      return buildBottomSheet(context, uid,
                                          friendNamesOptions:
                                              userFriendNamesOptions,
                                          friendUidsOptions:
                                              userFriendUidsOptions);
                                    }
                                  }));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFAED6F1),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8)),
                            child: Text(
                              friendIsSelected ? "Search Destination" : "Add Friend",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF21618C)),
                            )),
                      ),
                    )
                  ],
                ),
              );
            }
            // if (state is ShowRequestsState) {
            //   List<Widget> requestDialogs = [];
            //   int numberOfRequests = state.emailIds.length;
            //   List<String> requestsLeft = state.emailIds;
            //   for (var email in requestsLeft) {
            //     requestDialogs.add(Dialog(
            //       child: Column(
            //         children: [
            //           const Text("NEW FRIEND REQUEST!"),
            //           Text(email),
            //           // Row(
            //           //   children: [
            //           //     // ElevatedButton(onPressed: () async {
            //           //     //   await acceptFriendRequest(FirebaseAuth.instance.currentUser!.uid, email);
            //           //     //   numberOfRequests--;
            //           //     //   if (numberOfRequests == 0) {
            //           //     //     final bloc = BlocProvider.of(context);
            //           //     //   }
            //           //     // }, child: const Text('Accept')),
            //           //     // ElevatedButton(onPressed: () async {
            //           //     //   await declineFriendRequest(FirebaseAuth.instance.currentUser!.uid, email);
            //           //     // }, child: const Text('Decline')),
            //           //     // ElevatedButton(onPressed: onPressed, child: child),
            //           //   ],
            //           // )
            //         ],
            //       ),
            //     ));
            //   }
            //   //             final bloc = context.read<LandingBloc>();
            //   //             return Stack(
            //   //               children:
            //   //                 for (var email in requestsLeft) {
            //   //               AlertDialog(
            //   //                 barrierDismissible: false,
            //   //                 context: context,
            //   //                 builder: (BuildContext context) { return Column(
            //   //                   children: [
            //   //                     const Align(
            //   //                       child: Text('New Friend Request From: '),
            //   //                     ),
            //   //                     Align(
            //   //                       alignment: Alignment.topLeft,
            //   //                       child: Text(email),
            //   //                     ),
            //   //                     Row(
            //   //                       children: [
            //   //                         ElevatedButton(
            //   //                           onPressed: () {
            //   //                             bloc.add(AcceptRequestEvent(senderEmail: email));
            //   //                             numberOfRequests--;
            //   //                             requestsLeft.remove(email);
            //   //                             Navigator.pop(context);
            //   //                             if (numberOfRequests == 0){
            //   //                               final bloc = context.read<LandingBloc>();
            //   //                               bloc.add(const GetMemberLocations());
            //   //                             }
            //   //                           },
            //   //                           child: const Text('Accept'),
            //   //                         ),
            //   //                         ElevatedButton(
            //   //                           onPressed: () {
            //   //                             bloc.add(DeclineRequestEvent(senderEmail: email));
            //   //                             numberOfRequests--;
            //   //                             requestsLeft.remove(email);
            //   //                             Navigator.pop(context);
            //   //                             if (numberOfRequests == 0){
            //   //                               final bloc = context.read<LandingBloc>();
            //   //                               bloc.add(const GetMemberLocations());
            //   //                             }
            //   //                           },
            //   //                           child: const Text('Decline'),
            //   //                         ),
            //   //                         ElevatedButton(
            //   //                           onPressed: () {
            //   //                             numberOfRequests--;
            //   //                             Navigator.pop(context);
            //   //                             if (numberOfRequests == 0){
            //   //                               final bloc = context.read<LandingBloc>();
            //   //                               bloc.add(const GetMemberLocations());
            //   //                             }
            //   //                           },
            //   //                           child: const Text('See Later'),
            //   //                         ),
            //   //                       ],
            //   //                     )
            //   //                   ],
            //   //                 );},
            //   //               );
            //   //             }
            //   // ,
            //   //             );
            // }

            if (closed != true) {
              final bloc = context.read<LandingBloc>();
              bloc.add(const InitialEvent());
              return const Scaffold(
                  body: Align(
                child: Text('Loading.....'),
              ));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

Future<dynamic> requestDialogs(BuildContext context) async {
  dynamic requestEmailIds =
      await showExistingFriendRequests(localStorageService.uid);
  if (requestEmailIds == 'none') {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('No friend requests'),
          );
        });
    return;
  }
  // if (requestEmailIds == []) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return const Dialog(
  //           child: Text('You have no remaining friend requests to view'),
  //         );
  //       });
  // }
  if (requestEmailIds != false) {
    // if (requestEmailIds == 'none'){
    //   showDialog(context: context, builder: (context) {
    //     return const AlertDialog(title: Text('No friend requests'),);
    //   });
    // }
    for (var email in requestEmailIds) {
      print('insijiwf are $email');
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Friend request",
                style: TextStyle(color: Color(0xFF154360)),
              ),
              content: Text(
                "$email has sent a friend request to you",
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF21618C),
                    fontWeight: FontWeight.w400),
              ),
              actions: [
                ElevatedButton(
                    onPressed: (() async {
                      try {
                        print(
                            'clicked on accepted ${localStorageService.uid} $email');
                        acceptFriendRequest(localStorageService.uid, email);
                        print('after');
                        Navigator.pop(context);
                      } catch (e) {
                        print('error in acceting : ${e.toString()}');
                      }
                    }),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF48B07C),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 8)),
                    child: const Text(
                      "Accept",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )),
                ElevatedButton(
                    onPressed: (() async {
                      declineFriendRequest(localStorageService.uid, email);
                      Navigator.pop(context);
                    }),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC25348),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 8)),
                    child: const Text(
                      "Decline",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ))
              ],
            );
            // return Container(
            //   color: Color(0x33ffffff),
            //   alignment: Alignment.center,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //     Text('New friend request from \n $email'),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         ElevatedButton(
            //             onPressed: () async {
            //               acceptFriendRequest(localStorageService.uid, email);
            //               Navigator.pop(context);
            //             },
            //             child: const Text('Accept')),
            //         ElevatedButton(
            //             onPressed: () async {
            //               declineFriendRequest(localStorageService.uid, email);
            //               Navigator.pop(context);
            //             },
            //             child: const Text('Decline')),
            //         ElevatedButton(
            //             onPressed: () async {
            //               Navigator.pop(context);
            //             },
            //             child: const Text('See Later')),
            //       ],
            //     )
            //   ]),
            // );
          });
    }
  } else {
    showDialog(
        context: context,
        builder: (BuildContext ontext) {
          return const Dialog(
            child: Text('Error while fetching friend requests'),
          );
        });
  }
}
