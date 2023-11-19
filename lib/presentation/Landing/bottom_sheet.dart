import 'package:enono/services/firestore_db.dart';
import 'package:flutter/material.dart';

Widget buildBottomSheet(BuildContext bottomSheetContext, String uid,
    {required List<dynamic> friendNamesOptions,
    required List<dynamic> friendUidsOptions}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.pop(bottomSheetContext),
    child: DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.4,
      minChildSize: 0.2,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          controller: controller,
          children: [
            const Divider(
              indent: 120,
              endIndent: 120,
              color: Color(0xFFAED6F1),
              thickness: 1.5,
              height: 16,
            ),
            const Center(
              child: Text(
                "Add Friend",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF21618C),
                    fontWeight: FontWeight.w400),
              ),
            ),
            const Divider(
              color: Color(0xFFA9CCE3),
              thickness: 1,
              height: 24,
            ),
            const Center(
              child: Text(
                "Send Request",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF154360),
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFA9CCE3)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: ExpansionTile(
                title: const Text(
                  'Friends',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                children:
                    FriendTile(uid, friendNamesOptions, friendUidsOptions),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

List<Widget> FriendTile(
    String uid, List<dynamic> friendNames, List<dynamic> friendUids) {
  List<Widget> friendOptionsWidgetList = [];
  for (int i = 0; i < friendNames.length; i++) {
    friendOptionsWidgetList.add(ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      title: Text(
        friendNames[i],
        style: const TextStyle(fontSize: 14, color: Color(0xFF154360)),
      ),
      trailing: Builder(builder: (context) {
        return GestureDetector(
            onTap: (() {
              openConfirmationDialog(
                  context, uid, friendNames[i], friendUids[i]);
            }),
            child: const Icon(
              Icons.send_rounded,
              color: Color(0xFF21618C),
              size: 18,
            ));
      }),
    ));
  }
  return friendOptionsWidgetList;
}

void openConfirmationDialog(BuildContext context, String uid,
        dynamic friendName, dynamic friendUid) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Friend request",
          style: TextStyle(color: Color(0xFF154360)),
        ),
        content: Text(
          "Send friend request to $friendName?",
          style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF21618C),
              fontWeight: FontWeight.w400),
        ),
        actions: [
          ElevatedButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC25348),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 8)),
              child: const Text(
                "Close",
                style: TextStyle(fontSize: 14, color: Colors.white),
              )),
          ElevatedButton(
              onPressed: (() {
                sendFriendRequest(uid, friendUid);
                final snackBar = SnackBar(
                  duration: const Duration(seconds: 5),
                  content: const Text("Sent friend request!"),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 100),
                  action: SnackBarAction(
                      label: 'Undo',
                      onPressed: (() {
                        declineFriendRequest(friendUid, uid);
                      })),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF48B07C),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 8)),
              child: const Text(
                "Send",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ))
        ],
      ),
    );