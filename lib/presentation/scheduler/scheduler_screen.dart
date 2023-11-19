import 'package:enono/presentation/Hamburger/hamburger.dart';
import 'package:enono/presentation/Scheduler/bloc/scheduler_bloc.dart';
import 'package:flutter/material.dart';
import 'package:enono/data/local/local_database_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'lib/services/firestore_db.dart';
//import 'package:enono/services/firestore_db.dart';

class SchedulerScreen extends StatelessWidget {
  SchedulerScreen(
      {Key? key, required this.localStorageService, required this.uid})
      : super(key: key);
  final LocalStorageService localStorageService;
  final String uid;
  int tasks = 2;
  final List<Map<String, String>> userSchedule = [
    {"Work": "Sleep", "Time": "8:00 am - 9:00 am"},
    {"Work": "Eat", "Time": "10:00 am - 11:20 am"}
  ];
  bool isReadOnly = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SchedulerBloc(localStorageService),
      child: Theme(
        data: ThemeData(textTheme: GoogleFonts.interTextTheme()),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: BlocConsumer<SchedulerBloc, SchedulerState>(
                listenWhen: (previousState, state) {
              return previousState != state;
            }, listener: (context, state) {
              if (state is ScheduleErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.code)),
                );
              }
              // if (state is ScheduleViewState) {
              //   isReadOnly = true;
              // }
              // if (state is ScheduleEditState) {
              //   isReadOnly = false;
              // }
              // // TODO: implement listener
            },
                // builder: (context, state) {
                //   return SingleChildScrollView(
                //       child: BlocConsumer<SchedulerBloc, SchedulerState>(
                //           listenWhen: (previousState, state) {
                //     return previousState != state;
                //   }, listener: (context, state) {
                //     if (state is ScheduleViewState) {
                //       isReadOnly = true;
                //     }
                //     if (state is ScheduleEditState) {
                //       isReadOnly = false;
                //     }
                //   },
                builder: (BuildContext context, state) {
              if (state is ScheduleEditState) {
                isReadOnly = false;
              }
              if (state is ScheduleViewState) {
                isReadOnly = true;
              }
              return Scaffold(
                backgroundColor: const Color(0xFFE5E5E5),
                resizeToAvoidBottomInset: true,
                drawer: Hamburger(
                  localStorageService: localStorageService,
                  uid: localStorageService.uid,
                  imagePath:
                      'https://png.pngtree.com/png-clipart/20220627/original/pngtree-graduate-student-profile-education-human-png-image_8217698.png',
                ),
                appBar: AppBar(
                  // leading: BurgerIcon(),
                  // backgroundColor: Color(0xF1FAFF),
                  centerTitle: false,
                  title: const Text(
                    'Scheduler',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      //leading to menu screen. now that is something I definitely don't know.....
                    },
                    child: const Icon(
                      Icons.menu,
                      size: 28.0,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: const Color(0xFFF1FAFF),
                  actions: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.home_sharp,
                            size: 28.0,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
                floatingActionButton: isReadOnly
                    ? FloatingActionButton(
                        onPressed: () async {
                          final bloc = context.read<SchedulerBloc>();
                          bloc.add(const EditScheduler());
                        },
                        isExtended: true,
                        tooltip: "Edit Schedule",
                        child: const Icon(
                          Icons.mode_edit_sharp,
                          size: 28.0,
                          color: Colors.black,
                        ))
                    : Positioned(
                        bottom: 16,
                        left: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                                onPressed: () async {
                                  final bloc = context.read<SchedulerBloc>();
                                  bloc.add(SaveScheduler(
                                      userSchedule: userSchedule));
                                },
                                child: const Icon(
                                  Icons.save_sharp,
                                  size: 28.0,
                                  color: Colors.black,
                                )),
                            SizedBox(
                              width: 12,
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                tasks++;
                                userSchedule.add({"Work": " ", "Time": " "});
                              },
                              child: const Icon(
                                Icons.add,
                                size: 28.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            FloatingActionButton(
                                onPressed: () async {
                                  tasks--;
                                  var temp = userSchedule.removeLast();
                                },
                                child: const Icon(
                                  const IconData(0xe516,
                                      fontFamily: 'MaterialIcons'),
                                  size: 28.0,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                // floatingActionButton: Column(children: [
                //   FloatingActionButton(
                //     onPressed: () {},
                //     isExtended: true,
                //     tooltip: isReadOnly ? "Edit Schedule" : "Save Schedule",
                //     child: isReadOnly
                //         ? const Icon(
                //             Icons.edit_sharp,
                //             size: 28.0,
                //             color: Colors.black,
                //           )
                //         : const Icon(
                //           Icons.save_sharp,
                //           size: 28.0,
                //           color: Colors.black,
                //         ),
                //   ),
                //   FloatingActionButton(
                //     onPressed: (){
                //       tasks++;
                //     }

                //   )
                // ]),
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //getUserSchedule(uid),
                      // Container(
                      //     alignment: Alignment.topRight,
                      //     margin: const EdgeInsets.only(right: 12.0),
                      //     padding: const EdgeInsets.only(top: 15.0, right: 5.0),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8),
                      //         color: const Color(0xFFE5E5E5)),
                      //     child: GestureDetector(
                      //       onTap: () {},
                      //       child: isReadOnly
                      //           ? const Icon(
                      //               Icons.edit_sharp,
                      //               size: 28.0,
                      //               color: Colors.black,
                      //             )
                      //           : const Icon(
                      //               Icons.save_sharp,
                      //               size: 28.0,
                      //               color: Colors.black,
                      //             ),
                      //     )),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(12.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFE5E5E5)),
                        child: const Text(
                          "Today's Schedule",
                          style: TextStyle(
                            fontSize: 28,
                            //                  fontStyle: "Inter",
                            color: Color(0xFF21618C),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: tasks,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Container(
                                  margin: const EdgeInsets.only(
                                      right: 15.238, left: 15.238, bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFD6EAF8),
                                      border:
                                          Border.all(color: Color(0xFF2E86C1)),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12))),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: TextField(
                                          onChanged: (value) {
                                            userSchedule[index]["Time"] = value;
                                          },
                                          readOnly: isReadOnly,
                                          controller: TextEditingController(
                                              text: userSchedule[index]
                                                  ["Time"]),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(2),
                                            isDense: true,
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: Color(0xFFD6EAF8),
                                          ),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: TextField(
                                          onChanged: (value) {
                                            userSchedule[index]["Work"] = value;
                                          },
                                          readOnly: isReadOnly,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          controller: TextEditingController(
                                              text: userSchedule[index]
                                                  ["Work"]),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(2),
                                            isDense: true,
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: Color(0xFFD6EAF8),
                                          ),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ));
                            }),
                      )
                    ]
                    //
                    ),
              );
            })),
      ),
    );
  }
}