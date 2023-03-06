// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../module/estension.dart';
import '../../module/widgets.dart';

class SideBar extends StatelessWidget {
  final Function(int) onChanged;
  final int selectedIndex;
  const SideBar(
      {required this.onChanged, required this.selectedIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.widthResponse(0.23, 180, 250),
      child: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: context.accentColor.withOpacity(0.15),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${context.user!.firstname} ${context.user!.lastname}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ).center,
          ).margin6,
          const SizedBox(
            height: 75,
          ),
          MSideBarItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            selected: selectedIndex == 1,
            onTap: () {
              onChanged(1);
            },
          ),
          MSideBarItem(
            title: 'Sign out',
            icon: Icons.logout,
            selected: selectedIndex == 2,
            onTap: () {
              onChanged(2);
            },
          ),
          SizedBox(
            height: context.height * 0.6,
          ),
          MSideBarItem(
            title: 'Reset',
            icon: Icons.lock_reset_rounded,
            selected: selectedIndex == 3,
            onTap: () {
              onChanged(3);
            },
          ),
        ],
      ),
    );
  }
}
