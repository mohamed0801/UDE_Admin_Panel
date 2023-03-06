// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:ude_admin_panel/module/estension.dart';

import 'package:ude_admin_panel/module/widgets.dart';

class SignOut extends StatelessWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context) {
    MBloc<bool> signOut = MBloc<bool>()..setValue(true);
    return StreamBuilder<bool>(
        stream: signOut.stream,
        builder: (context, snap) {
          return snap.hasData && snap.data!
              ? SizedBox(
                  height: 300,
                  width: context.width * 0.3 > 350 ? 450 : context.width * 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      'Etes vous sure de vouloir vous deconnecter'
                          .toLabel(bold: true, color: Colors.grey, fontsize: 18)
                          .margin9,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MButton(
                                  type: ButtonType.Cancel,
                                  onTap: () {
                                    signOut.setValue(false);
                                  },
                                  title: 'Cancel'),
                              const SizedBox(
                                width: 10,
                              ),
                              MButton(
                                  type: ButtonType.Save,
                                  onTap: () async {
                                    context.userBloc.signOut();
                                  },
                                  title: 'Save'),
                            ],
                          )
                        ],
                      ).padding9.card,
                    ],
                  ),
                ).center
              : 'Go To Dashboard'.toLabel(bold: true).center;
        });
  }
}
