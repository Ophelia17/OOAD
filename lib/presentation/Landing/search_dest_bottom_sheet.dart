import 'package:enono/services/firestore_db.dart';
import 'package:enono/services/optimal_location.dart';
import 'package:flutter/material.dart';

String dest1 = "", dest2 = "", dest3 = "";

Widget buildSearchDestBottomSheet(BuildContext bottomSheetContext, String uid,
    {required dynamic friendUid}) {
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
                "Search Destination",
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
                "Criteria  :  Distance",
                style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF21618C),
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Center(
              child: Text(
                "Destination Type",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF21618C),
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
                child: DestinationTypedropdown(uid: uid, friendUid: friendUid)),
            const SizedBox(
              height: 16,
            ),
            const Center(
              child: Text(
                "Places To Go...",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF21618C),
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                searchedDestinationTile(dest1, "1."),
                searchedDestinationTile(dest2, "2."),
                searchedDestinationTile(dest3, "3.")
              ],
            )
          ],
        ),
      ),
    ),
  );
}

DropdownMenuItem<String> buildTypeTile(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: const TextStyle(color: Color(0xFF2980B9), fontSize: 15),
    ));

class DestinationTypedropdown extends StatefulWidget {
  DestinationTypedropdown(
      {super.key, required this.uid, required this.friendUid});
  dynamic uid;
  dynamic friendUid;

  @override
  State<DestinationTypedropdown> createState() =>
      _DestinationTypedropdownState();
}

class _DestinationTypedropdownState extends State<DestinationTypedropdown> {
  final destinationTypes = [
    'Cafe',
    'Departments',
    'Fast Food',
    'Labs',
    'Utilities'
  ];
  String? type;
  @override
  Widget build(BuildContext context) {
    String uid = widget.uid;
    String friendUid = widget.friendUid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFAED6F1)),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          onChanged: ((value) async {
            dynamic destinations = await getDestinationsByType(value);
            print("Hello in search dest bottom sheet");
            print('destinations are $destinations');
            List<dynamic> uids = [uid, friendUid];
            dynamic groupCoordinates = await getGroupLocationCoordinates(uids);
            print(groupCoordinates);
            setState(() {
              type = value;
            });
            dynamic optimalDestination =
                await optimalMeetingPoints(groupCoordinates, destinations);
            dest1 = optimalDestination[0];
            dest2 = optimalDestination[1];
            dest3 = optimalDestination[2];
            // dest1 = "hello";
            // dest2 = "bye-bye";
            // dest3 = "Hehe";
          }),
          value: type,
          items: destinationTypes.map(buildTypeTile).toList(),
        ),
      ),
    );
  }
}

Widget searchedDestinationTile(String dest, String rank) {
  return Container(
    height: 32,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: const BoxDecoration(
        color: Color(0xFFD1F2EB),
        borderRadius: BorderRadius.all(Radius.circular(8))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          rank,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const VerticalDivider(
          thickness: 2,
          color: Color(0xFFA3E4D7),
        ),
        Text(
          dest,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const VerticalDivider(thickness: 2, color: Color(0xFFA3E4D7)),
        const Icon(
          Icons.location_on_sharp,
          color: Colors.black,
          size: 16,
        )
      ],
    ),
  );
}