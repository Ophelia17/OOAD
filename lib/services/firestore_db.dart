import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

final db = FirebaseFirestore.instance;

Future<List<String>> getGroups(String uid) async {
  try {
    final event = await db.collection("Users").get();
    for (var doc in event.docs) {
      if (doc.id == uid) {
        if (doc.data()['Name'] == null) {
          //start registration flow
        }
        return List<String>.from(doc.data()['groups']);
      }
    }
  } catch (e) {
    throw Exception("Error with code: ${e.toString()}");
  }
  throw Exception("error");
}

Future<Map<String, GeoPoint>> allUserLocations(String gid) async {
  dynamic users = await getUIDs(gid);
  if (users.runtimeType != List<String>) {
    throw Exception("Error while fetching users");
  }
  Map<String, GeoPoint> locations = {};
  dynamic currLocationAndName;
  for (String user in users) {
    currLocationAndName =
        await getUserLocationAndName(user.replaceAll(" ", ""));
    // if (currLocat ion.runtimeType != GeoPoint){
    //   throw Exception("Error while fetching position of user $user");
    // }
    print(currLocationAndName);
    locations
        .addAll({currLocationAndName["name"]: currLocationAndName["location"]});
  }
  return locations;
}

Future<dynamic> allUsersStreams(String gid) async {
  dynamic users = await getUIDs(gid);
  if (users.runtimeType != List<String>) {
    return "Error";
  }
  List<Stream> usersStream = [];
  dynamic currUser;
  for (String uid in users) {
    currUser = await userStream(uid);
    if (currUser.runtimeType != Stream) {
      return "Error while fetching info for user $uid";
    }
    usersStream.add(currUser);
  }
  return usersStream;
}

//return stream of user
Future<dynamic> userStream(String uid) async {
  try {
    return db.collection("Users").doc(uid).snapshots(); //returns a stream
  } on FirebaseException catch (e) {
    return e.toString();
  }
}

//function to return a list containing user ids of all users of a group
//returning first document only
Future<dynamic> getUIDs(String gid) async {
  try {
    final event = await db.collection("Groups").get();
    for (var doc in event.docs) {
      if (doc.id == gid) {
        return List<String>.from(
            doc.data()['users']); //returns List<String> containing uids
      }
    }
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> getUserLocationAndName(String uid) async {
  try {
    final event = await db.collection("Users").get();
    for (var doc in event.docs) {
      if (doc.id == uid) {
        if (doc.data()['Name'] == null) {
          return 'registration_pending';
          //start regostration flow
        }
        print(doc.data()['Name']);
        return {
          "location": doc.data()['location'],
          "name": doc.data()['Name']
        }; //returns instance of GeoPoint and a String -> name
      }
    }
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> registerNewUser(
    String uid, String name, String emailId, List<double> currLocation) async {
  try {
    db.collection("Users").doc(uid).set({
      "Name": name,
      "email_id": emailId,
      "location": GeoPoint(currLocation[0], currLocation[1]),
      "groups": [],
      "existing_friend_requests": [],
      "pending_friend_requests": [],
      "friends": [],
      "schedule": [],
    });
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<dynamic> addUserToGroup(String uid, String gid) async {
  List<String> existingUserGroups = [];
  List<String> newUserGroups, newUsers;
  List<String> existingUsers = [];
  try {
    existingUserGroups = await getGroups(uid);
    newUserGroups = existingUserGroups + [gid];
    final userRef = db.collection("Users").doc(uid);
    userRef.update({"groups": newUserGroups});
    existingUsers = await getUIDs(gid);
    newUsers = existingUsers + [uid];
    final groupRef = db.collection("Groups").doc(gid);
    groupRef.update({"users": newUsers});
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

List<Widget> markerWidgets = [];

Future<void> WIdgets() async {
  late dynamic users;
  bool noError;
  users = await allUsersStreams("Test_Group_1");
  if (users.runtimeType != List<Stream>) {
    noError = false;
    return;
  }

  for (Stream user in users) {
    print(user.first);
    markerWidgets.add(StreamBuilder(
      stream: user,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          throw Exception('error while adding strems');
        }
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.none:
            throw Exception('error while adding strems');
          case ConnectionState.waiting:
            throw Exception('error while adding strems');
          case ConnectionState.active:
            {
              return Text("x:${asyncSnapshot.data['location'].x}");
            }
          case ConnectionState.done:
            return Text("x:${asyncSnapshot.data['location'].x}");
        }
      },
    ));
  }
}

Map<String, String> emailToUID = {};
Map<String, String> uidToEmail = {};
Map<String, List<double>> uidToLocation = {};
Map<String, List<double>> nameToLocation = {};

Future<dynamic> getAllUsers() async {
  try {
    final event = await db.collection("Users").get();
    for (var doc in event.docs) {
      print('${doc.data()['email_id']} : ${doc.id}');
      emailToUID.addAll({doc.data()['email_id']: doc.id});
      uidToEmail.addAll({doc.id: doc.data()['email_id']});
      uidToLocation.addAll({
        doc.id: [
          doc.data()['location'].latitude,
          doc.data()['location'].longitude
        ]
      });
      nameToLocation.addAll({
        doc.data()['Name']: [
          doc.data()['location'].latitude,
          doc.data()['location'].longitude
        ]
      });
    }
    print('friends and locations are $nameToLocation');
    print(uidToEmail);
    print(emailToUID);
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> refreshLocations(String friendName) async {
  try {
    final event = await db.collection("Users").get();
    for (var doc in event.docs) {
      if (doc.data()['Name'] == friendName) {
        nameToLocation[friendName] = [
          doc.data()['location'].latitude,
          doc.data()['location'].longitude
        ];
      }
    }
  } catch (e) {
    print('error with code : ${e.toString()}');
    return false;
  }
}

Future<dynamic> getUIDfromEmail(String email) async {
  try {
    return emailToUID[email];
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> sendFriendRequest(
    String senderUid, String newFriendEmailId) async {
  dynamic findUser = await getUIDfromEmail(newFriendEmailId);
  try {
    final receiverUser = await db.collection("Users").doc(findUser).get();
    db.collection("Users").doc(findUser).update({
      'existing_friend_requests':
          receiverUser.data()!['existing_friend_requests'] + [senderUid]
    });
    final senderUser = await db.collection("Users").doc(senderUid).get();
    db.collection("Users").doc(senderUid).update({
      'pending_friend_requests':
          senderUser.data()!['pending_friend_requests'] + [findUser]
    });
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> acceptFriendRequest(
    String receiverUID, String senderEmail) async {
  try {
    print('inside accept req function');
    final String senderUID = emailToUID[senderEmail]!;
    db.collection("Users").doc(senderUID).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map;
      final pendingFriendRequests = data['pending_friend_requests'];
      final exisitingFriends = data['friends'];
      print('exisiting friends are $exisitingFriends');
      exisitingFriends.add(receiverUID);
      print('new friends are $exisitingFriends');
      pendingFriendRequests.remove(receiverUID);
      db.collection('Users').doc(senderUID).update({
        'pending_friend_requests': pendingFriendRequests,
        'friends': exisitingFriends
      });
    });
    db.collection("Users").doc(receiverUID).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map;
      final friendFriends = data['existing_friend_requests'];
      final exisitingFriends = data['friends'];
      exisitingFriends.add(senderUID);
      friendFriends.remove(senderUID);
      db.collection('Users').doc(receiverUID).update({
        'existing_friend_requests': friendFriends,
        'friends': exisitingFriends
      });
    });
    print("Friend added");
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> declineFriendRequest(
    String receiverUID, String senderEmail) async {
  try {
    final String senderUID = emailToUID[senderEmail]!;
    db.collection("Users").doc(senderUID).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map;
      final pendingFriendRequests = data['pending_friend_requests'];
      pendingFriendRequests.remove(receiverUID);
      db
          .collection('Users')
          .doc(senderUID)
          .update({'pending_friend_requests': pendingFriendRequests});
    });
    db.collection("Users").doc(receiverUID).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map;
      final friendFriends = data['existing_friend_requests'];
      friendFriends.remove(senderUID);
      db
          .collection('Users')
          .doc(receiverUID)
          .update({'existing_friend_requests': friendFriends});
    });
    print("Friend deleted");
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> deleteFriend(String uid, String friendUid) async {
  try {
    db.collection("Users").doc(uid).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map;
      final userFriends = data['friends'];
      userFriends.remove(friendUid);
      db.collection('Users').doc(uid).update({'friends': userFriends});
    });
    db.collection("Users").doc(friendUid).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map;
      final friendFriends = data['friends'];
      friendFriends.remove(friendUid);
      db.collection('Users').doc(friendUid).update({'friends': friendFriends});
    });
    print("Friend deleted");
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> showExistingFriendRequests(String uid) async {
  try {
    print('in showrequests');
    final user = await db.collection("Users").doc(uid).get();
    print(user.data()!['existing_friend_requests']);
    List<dynamic> existingRequestsUIDs =
        user.data()!['existing_friend_requests'];
    List<String> existingRequestEmails = [];
    for (var suid in existingRequestsUIDs) {
      existingRequestEmails.add(uidToEmail[suid]!);
    }
    if (existingRequestEmails.isEmpty) {
      return 'none';
    }
    print(
        'FRs are $existingRequestEmails and if they are equal is ${existingRequestEmails.isEmpty}');
    return existingRequestEmails;
  } catch (e) {
    print(e.toString());
    print('error while fetching requests');
    return false;
  }
}
Map<String, GeoPoint> friendsAndLocations = {};

Future<dynamic> getFriendsAndLocations(String uid) async {
  try {
    print("reacherd fetFriendsvdssf00");
    final allUsers = await db.collection("Users").get();
    print("allusersa are $allUsers");
    List<String> friends = [];
    for (var user in allUsers.docs) {
      print(user.id);
      if (user.id == uid) {
        print(List<String>.from(user.data()['friends']));
        friends = List<String>.from(user.data()['friends']);
        print('found');
      }
    }
    // final List<String> friends = allUsers.docs.firstWhere((element) => element.id == uid).data()['friends'];
    print("freids are $friends");
    friendsAndLocations = {};
    for (var friend in friends) {
      dynamic currFriendData =
          allUsers.docs.firstWhere((element) => element.id == friend).data();
      friendsAndLocations
          .addAll({currFriendData['Name']: currFriendData['location']});
    }
    print("friendsAndLocations in firestore_db.dart is $friendsAndLocations");
    return friendsAndLocations;
  } catch (e) {
    return 'Error with code: ${e.toString()}';
  }
}

Future<dynamic> updatePosition(List<double> location, String uid) async {
  try {
    db.collection("Users").doc(uid).get().then((DocumentSnapshot doc) {
      db
          .collection('Users')
          .doc(uid)
          .update({'location': GeoPoint(location[0], location[1])});
    });
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<dynamic> getLocationsOfAType(String type) async {
  try {
    db.collection("Places").doc(type).get().then((DocumentSnapshot doc) {
      return doc.data();
    });
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<dynamic> getUserEmailAndName(String uid) async {
  try {
    final event = await db.collection("Users").get();
    for (var doc in event.docs) {
      if (doc.id == uid) {
        if (doc.data()['Name'] == null) {
          return 'registration_pending';
          //start regostration flow
        }
        // print(doc.data()['Name']);
        Map<String, dynamic> usermap = {
          "email": doc.data()['email_id'],
          "name": doc.data()['Name']
        };
        return usermap;
      }
    }
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> getUserSchedule(String uid) async {
  try {
    final event = await db.collection("Users").get();
    for (var doc in event.docs) {
      if (doc.id == uid) {
        if (doc.data()['Name'] == null) {
          return 'registration_pending';
          //start registration flow
        }
        List<dynamic> schedule = doc.data()['schedule'];
        // print(schedule);
        return schedule;
      }
    }
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> getNameListFromUids(List<dynamic> uid) async {
  List<dynamic> friendNames = [];
  try {
    final event = await db.collection("Users").get();
    for (var doc in event.docs) {
      int i;
      for (i = 0; i < uid.length; i++) {
        if (doc.id == uid[i]) {
          friendNames.add(doc.data()['Name']);
        }
      }
      if (i == uid.length - 1) {
        return friendNames;
      }
    }
    return friendNames;
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> getUserFriends(String uid) async {
  try {
    final event = await db.collection("Users").get();
    for (var doc in event.docs) {
      if (doc.id == uid) {
        if (doc.data()['Name'] == null) {
          return 'registration_pending';
          //start registration flow
        }
        List<dynamic> userFriends = doc.data()['friends'];
        return userFriends;
      }
    }
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> getUserFriendOptions(String uid) async {
  List<dynamic> friendOptions = [];
  List<dynamic> friendCurrent = await getUserFriends(uid);
  try {
    final event = await db.collection("Users").get();
    for (var doc in event.docs) {
      friendOptions.add(doc.id);
      for (int i = 0; i < friendCurrent.length; i++) {
        if (doc.id == friendCurrent[i]) {
          friendOptions.remove(doc.id);
        }
      }
    }
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
  friendOptions.remove(uid);
  return friendOptions;
}

Future<dynamic> getDestinationsByType(dynamic type) async {
  List<List<dynamic>> destinations = [];
  try {
    print("Hello1");
    dynamic dest =
        db.collection("Places").doc(type).get().then((DocumentSnapshot doc) {
      print("Hello2");
      final data = doc.data() as Map;
      print("Hello3");
      print(data);
      print("Hello4");
      int i = 0;
      List<dynamic> temp = [];
      print("Hello5");
      for (var destinationName in data.keys) {
        temp = [];
        temp.add(destinationName);
        temp.add(data[destinationName].latitude);
        temp.add(data[destinationName].longitude);
        destinations.add(temp);
        i++;
      }
      print("Hello6");
      print(destinations);
      print("Hello7");

      return destinations;
    });
    return dest;
  } catch (e) {
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> getGroupLocationCoordinates(List<dynamic> uids) async {
  List<List<dynamic>> groupCoordinates = [];
  try {
    print(uids);
    for (var uid in uids) {
      await db.collection("Users").doc(uid).get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map;
        List<dynamic> temp = [];
        temp.add(data['location'].latitude);
        temp.add(data['location'].longitude);
        groupCoordinates.add(temp);
      });
    }
    return groupCoordinates;
  } catch (e) {
    print("Error with code: ${e.toString()}");
    return "Error with code: ${e.toString()}";
  }
}

Future<dynamic> updateUserSchedule(
    String uid, List<Map<String, String>> schedule) async {
  try {
    await db.collection("Users").doc(uid).update({"schedule": schedule});
  } catch (e) {
    print('errror ${e.toString()}');
    return false;
  }
}
