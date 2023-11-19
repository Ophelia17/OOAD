import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileImage(
      {Key? key, required this.imagePath, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: [
        buildImage(imagePath),
        Positioned(
          bottom: 0,
          right: 0,
          child: buildEditButton(),
        )
      ],
    ));
  }

  Widget buildImage(String userImagePath) {
    final image = NetworkImage(userImagePath);
    return Container(
      height: 108,
      width: 96,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFFEBAD), width: 6),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
      ),
      child: Ink.image(
        image: image,
        fit: BoxFit.cover,
        child: InkWell(
          onTap: onClicked,
        ),
      ),
    );
  }

  Widget buildEditButton() {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          color: const Color(0xFFE7C55E),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: const Icon(
        Icons.edit,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}
