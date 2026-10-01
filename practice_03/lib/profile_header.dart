import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/Profile.jpg',
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontFamily: 'ProfileFont'),
        ),
        Text(university, textAlign: TextAlign.center),
      ],
    );
  }
}
