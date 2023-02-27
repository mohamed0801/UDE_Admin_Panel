// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../module/estension.dart';
import '../../module/widgets.dart';
import '../Classe/Classe.dart';
import '../Teachers/Teachers.dart';

MBloc<int> _dashmenu = MBloc<int>()..setValue(1);

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: _dashmenu.stream,
        builder: (context, snap) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 300,
                    child: MEdit(hint: 'search...'),
                  ).padding9,
                  const MDarkLightSwitch(),
                ],
              ),
              const SizedBox(height: 35),
              //Top Menu
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _dashmenu.setValue(1),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: (snap.data ?? 0) == 1
                                      ? Colors.green.shade200
                                      : Colors.grey.shade200,
                                  width: 1))),
                      padding: const EdgeInsets.only(bottom: 15),
                      child: 'Teacher'
                          .toLabel(
                            color: (snap.data ?? 0) == 1
                                ? Colors.green.shade200
                                : Colors.grey,
                          )
                          .center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _dashmenu.setValue(2),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: (snap.data ?? 0) == 2
                                      ? Colors.green.shade200
                                      : Colors.grey.shade200,
                                  width: 1))),
                      padding: const EdgeInsets.only(bottom: 15),
                      child: 'Classe'
                          .toLabel(
                            color: (snap.data ?? 0) == 3
                                ? Colors.green.shade200
                                : Colors.grey,
                          )
                          .center,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade200, width: 1))),
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ''.toLabel(),
                  ).expand,
                ],
              ),
              (snap.data ?? 0) == 1
                  ? const Teachers().expand
                  : (snap.data ?? 0) == 2
                      ? const Classe().expand
                      : 'Others'.toLabel().center
            ],
          );
        }).padding9.margin9;
  }
}
