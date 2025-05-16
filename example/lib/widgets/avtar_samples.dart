import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class AvtarSamples extends StatelessWidget {
  const AvtarSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              UFUAvatar(size: UFUAvatarSize.extraLarge),
              UFUText(text: "extraLarge"),
              UFUText(text: "128 x 128"),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              UFUAvatar(size: UFUAvatarSize.size_72x72),
              UFUText(text: "size_72x72"),
              UFUText(text: "72 x 72"),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              UFUAvatar(size: UFUAvatarSize.large),
              UFUText(text: "large"),
              UFUText(text: "42 x 42"),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              UFUAvatar(size: UFUAvatarSize.medium),
              UFUText(text: "medium"),
              UFUText(text: "36 x 36"),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              UFUAvatar(size: UFUAvatarSize.size_30x30),
              UFUText(text: "size_30x30"),
              UFUText(text: "30 x 30"),
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              UFUAvatar(size: UFUAvatarSize.small),
              UFUText(text: "small"),
              UFUText(text: "24 x 24"),
            ],
          ),
        ],
      ),
    );
  }
}
