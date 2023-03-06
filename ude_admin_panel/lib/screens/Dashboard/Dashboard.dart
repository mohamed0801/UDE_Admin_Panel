// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ude_admin_panel/screens/Dashboard/Reset.dart';
import 'package:ude_admin_panel/screens/Dashboard/SignOut.dart';

import '../../module/estension.dart';
import '../../module/widgets.dart';
import 'DashboardContent.dart';
import 'SideBar.dart';

MBloc<int> _menu = MBloc<int>()..setValue(1);

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<int>(
        stream: _menu.stream,
        builder: (context, snap) {
          if (!snap.hasData) return const MWaiting();
          return Row(
            children: [
              SideBar(
                selectedIndex: _menu.value,
                onChanged: (val) {
                  _menu.setValue(val);
                },
              ),
              Container(
                child: snap.data == 1
                    ? const DashboardContent()
                    : snap.data == 2
                        ? const SignOut()
                        : snap.data == 3
                            ? const Reset()
                            : 'Go To Dashboard'.toLabel().center,
              ).expand,
            ],
          );
        },
      )),
    );
  }
}
