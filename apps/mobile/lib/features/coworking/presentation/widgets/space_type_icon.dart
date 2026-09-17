import 'package:flutter/material.dart';
import '../../domain/entities/coworking_space.dart';

class SpaceTypeIcon extends StatelessWidget {
  final SpaceType type;
  final double size;

  const SpaceTypeIcon({super.key, required this.type, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Icon(_icon, size: size);
  }

  IconData get _icon => switch (type) {
        SpaceType.cafe => Icons.local_cafe,
        SpaceType.coworking => Icons.meeting_room,
        SpaceType.ceci => Icons.apartment,
      };
}
